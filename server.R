library(dplyr)
library(httr)
source('apiKey.R')
library(twitteR)
#install.packages("plotly")
library(plotly)

my.server <- function(input,output) {

#Gets trends in the United States
Trends <- getTrends("23424977")

#Selects top 10 trends 
trends.top.ten <- head(Trends, 10)

#Extracts only the first column and all rows of data
tweet.names <- trends.top.ten[, 1]

#Makes into data frame
tweet.names <- as.data.frame(tweet.names)

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

#Views number of favorites for the most popular tweets "mixed (includes popular + real time results)"
one.popular <- searchTwitter(one, n=1, resultType = 'mixed')
likes.1 <- one.popular[[1]]$favoriteCount
sentence <- one.popular[[1]]$

two.popular <- searchTwitter(two, n=1, resultType = 'mixed')
likes.2 <- two.popular[[1]]$favoriteCount

three.popular <- searchTwitter(three, n=1, resultType = 'mixed')
likes.3 <- three.popular[[1]]$favoriteCount

four.popular <- searchTwitter(four, n=1, resultType = 'mixed')
likes.4 <- four.popular[[1]]$favoriteCount

five.popular <- searchTwitter(five, n=1, resultType = 'mixed')
likes.5 <- five.popular[[1]]$favoriteCount

six.popular <- searchTwitter(six, n=1, resultType = 'mixed')
likes.6 <- six.popular[[1]]$favoriteCount

seven.popular <- searchTwitter(seven, n=1, resultType = 'mixed')
likes.7 <- seven.popular[[1]]$favoriteCount

eight.popular <- searchTwitter(eight, n=1, resultType = 'popular')
likes.8 <- eight.popular[[1]]$favoriteCount

nine.popular <- searchTwitter(nine, n=1, resultType = 'mixed')
likes.9 <- nine.popular[[1]]$favoriteCount

ten.popular <- searchTwitter(ten, n=1, resultType = 'mixed')
likes.10 <- ten.popular[[1]]$favoriteCount

#Creates a vector of the likes
number.of.likes <- c(likes.1,likes.2,likes.3,likes.4,likes.5,likes.6,likes.7,likes.8,likes.9,likes.10)

#Turns vector into dataframe
number.of.likes <- as.data.frame(number.of.likes)

#Combines the two dataframe of intereest (tweets and number of likes)
name.and.likes <- cbind(tweet.names, number.of.likes)

output$table <- renderDataTable({
  return(name.and.likes)
})

#Arranges table in order by most liked first in a decreasing order
arrange.by.likes <- arrange(name.and.likes, -number.of.likes)

#Selects rows and column of interest
top.popular <- arrange.by.likes[1,1]

top.liked <- arrange.by.likes[1,2]

#Creates a changing text that corresponds with the data table
output$text <- renderText({
  bar.info <- paste("From the data above, we can see that the most popular tweet (by most talked
                    about and most liked) at this exact momment is about",top.popular,", with",top.liked,
                    "likes.")
  
})

}
