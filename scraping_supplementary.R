
# Install/load rvest package
#install.packages("rvest")
library(rvest)

# Read html format from website
html <- read_html("https://en.wikipedia.org/wiki/Comma-separated_values")
html
class(html)


#######################################################
# Scrape the table format version (1st interpretation)
#######################################################

# Pipe html to node to table
# Get xpath using inspect function on website

# Both the XPaths below should work 
# //*[@id="mw-content-text"]/div[1]/table[2]/tbody
# //*[@id="mw-content-text"]/div[1]/table[2]

csv_table <- html %>% 
  html_nodes(xpath='//*[@id="mw-content-text"]/div[1]/table[2]/tbody') %>%
  html_table()
csv_table

# Another way (1)
csv_table2 <- html %>% 
  #html_nodes("table") %>%  #superceded by html_elements()
  html_elements("table") %>%
  html_table()
csv_table2
csv_table2[[2]]

# Another way (2) 
csv_table3 <- html %>% 
  html_elements(css="tbody") %>%
  html_table()
csv_table3
csv_table3[[2]]

# Write to csv file
write.csv(csv_table, file="car.csv", row.names=FALSE)

# Read csv file to verify
df1=read.csv("car.csv")
df1
class(df1)
str(df1)


#####################################################
# Scrape the CSV format version (2nd interpretation)
#####################################################

csv_table_alt <- html %>% 
  html_elements(xpath='//*[@id="mw-content-text"]/div[1]/pre[1]/text()') %>%
  html_text()
csv_table_alt

# Using SelectorGadget to get Xpath
html %>% 
  html_nodes(xpath='//pre[(((count(preceding-sibling::*) + 1) = 56) and parent::*)]') %>%
  html_text()

# Using SelectorGadget to get CSS path
html %>% 
  html_nodes('pre:nth-child(56)') %>%
  html_text()

# Write to csv file
write.table(csv_table_alt, file="car_alt.csv", quote=FALSE, col.names=FALSE, row.names=FALSE)

# Read csv file to verify
df2=read.csv("car_alt.csv")
df2
class(df2)
str(df2)


# References:
# https://rvest.tidyverse.org/articles/rvest.html
# https://rvest.tidyverse.org/articles/selectorgadget.html

# YouTube Links:
# https://www.youtube.com/watch?v=kYkSE3zWa9Y&t=89s
