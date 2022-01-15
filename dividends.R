##### Compile dividend and price data for a list of stocks

library(tidyverse)
library(tidyquant)
options(scipen = 999, digits = 2)

#load list of stocks
list <- read_csv("list.csv")


#create function to pull stock dividends in the last year
dividends <- function(Symbol, from = Sys.Date() - 365, to = Sys.Date()){
  
  div <-  tibble(Symbol, div = getDividends(Symbol, from, to)) %>%
    group_by(Symbol) %>%
    summarise(Dividend = sum(div))
  
  
}

#run the function for each stock in the list
data <- pmap_dfr(list, dividends)

#compile prices and calculate 52-week Hi and Lo
prices <- tq_get(list,
               from = Sys.Date() - 365,
               to = Sys.Date(),
               get = "stock.prices") %>%
  group_by(Symbol) %>%
  summarize(Lo_52 = min(adjusted), Hi_52 = max(adjusted))

#get latest stock price
last <- tq_get(list,
               from = Sys.Date()-1,
               to = Sys.Date(),
               get = "stock.prices") %>%
  select(Symbol, date, adjusted)

#combine data and calculate dividend yield and change from 52-week Hi
dividend_stocks <- prices %>%
  left_join(last, by = "Symbol") %>%
  left_join(data, by = "Symbol") %>%
  mutate(chg_HI = (Hi_52 - adjusted)/Hi_52,
         yield = Dividend/adjusted)

#save as csv
write_csv(x = dividend_stocks, file = "dividend_stocks_011522.csv")


