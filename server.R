library(dplyr)
library(httr)
source('apiKey.R')
library(twitteR)


my.server <- function(input,output) {

#Gets trends in the United States
Trends <- getTrends("23424977")

#Selects top 10 trends 
trends.top.ten <- head(Trends, 10)

View(trends.top.ten)

hi <- trends.top.ten[, 1]
View(hi)
is.data.frame(hi)
as.data.frame(hi)
#Looks at all the trends and find the most favorited 'popular'
one <- trends.top.ten[1,1]
two <- trends.top.ten[2,1]
three <- trends.top.ten[3,1]
four <- trends.top.ten[4,1]
five <- trends.top.ten[5,1]
six <- trends.top.ten[6,1]
seven <- trends.top.ten[7,1]
eight <- trends.top.ten[8,1]
nine <- trends.top.ten[9,1]
ten <- trends.top.ten[10,1]

#Views first
one.popular <- searchTwitter(one, n=1, resultType = 'popular')
likes.1 <- one.popular[[1]]$favoriteCount

two.popular <- searchTwitter(two, n=1, resultType = 'popular')
likes.2 <- two.popular[[1]]$favoriteCount

three.popular <- searchTwitter(three, n=1, resultType = 'popular')
likes.3 <- three.popular[[1]]$favoriteCount

four.popular <- searchTwitter(four, n=1, resultType = 'popular')
likes.4 <- four.popular[[1]]$favoriteCount

five.popular <- searchTwitter(five, n=1, resultType = 'popular')
likes.5 <- five.popular[[1]]$favoriteCount

six.popular <- searchTwitter(six, n=1, resultType = 'popular')
likes.6 <- six.popular[[1]]$favoriteCount

seven.popular <- searchTwitter(seven, n=1, resultType = 'popular')
likes.7 <- seven.popular[[1]]$favoriteCount

eight.popular <- searchTwitter(eight, n=1, resultType = 'popular')
likes.8 <- eight.popular[[1]]$favoriteCount

nine.popular <- searchTwitter(nine, n=1, resultType = 'popular')
likes.9 <- nine.popular[[1]]$favoriteCount

ten.popular <- searchTwitter(ten, n=1, resultType = 'popular')
likes.10 <- ten.popular[[1]]$favoriteCount

number.of.likes <- c(likes.1,likes.2,likes.3,likes.4,likes.5,likes.6,likes.7,likes.8,likes.9,likes.10)


output$table <- renderDataTable({
  return(trends.top.ten)
})


}
