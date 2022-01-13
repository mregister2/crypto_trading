library(tidyverse)
library(quantmod)

list <- read_csv("div_list.csv")

Symbol <- "JPM"
from <- "2021-01-01"
to <- "2022-01-13"

dividends <- function(Symbol){
  
  div <-  getDividends(Symbol)
  
  tibble(Symbol, div)
}

data <- pmap_dfr(list, dividends)




dividends(Symbol)
x

getDividends(Symbol)
