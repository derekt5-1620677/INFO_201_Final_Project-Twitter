# reserved for app
#install.packages("streamR")
#install.packages("ROAuth")
library(streamR)
library(twitteR)

library(shiny)

library(dplyr)
#library(lubridate)
library(grid)
#library(png)
#library(ROAuth)
library(devtools)

source("apikey.R")
source("apikeystreamR.R")
# installs library by Pablo Barbera, author of streamR for twitter analysis
# this library was intended for a course at NYU-AD but was showcased in another
# twitter data tutorial:
# http://kivanpolimis.com/social-media-twitter-api-and-r.html   (tutorial)
# https://github.com/pablobarbera/NYU-AD-160J                   (source)
install_github("pablobarbera/NYU-AD-160J/NYU160J")
library(NYU160J)
library(ggplot2)
#library(plotly)


source("ui.R")
source("server.R")

shinyApp(ui, server)
# source("Sentiment-Analysis-on-Twitter-Data-with-Shiny--master/cleanuptweets.R")
# library(lubridate)
# 
# ajw.seattle.latt <- 47.606209
# ajw.seattle.long <- -122.332071
# 
# availableTrendLocations()
# ajw.closest.trend.data <- closestTrendLocations(ajw.seattle.latt, ajw.seattle.long)
# ajw.seattle.trending <- getTrends(ajw.closest.trend.data[[3]])
# head(ajw.seattle.trending)


# test code for figuring out location data
# DC_tweets <- getTrends(2514815)
# head(DC_tweets$name)
# test1 <- getTrends(2490383)
# head(test1$name)
# 
# filterStream("ClintonTrump_tweets.json", track = c("Clinton", "Trump"), 
#              locations = c(-125, 25, -66, 50), timeout = 60, oauth = my_oauth)
# ClintonTrump_tweets.df <- parseTweets("ClintonTrump_tweets.json", simplify = FALSE)
# head(ClintonTrump_tweets.df)
# #shinyApp(ui, server)

#filterStream("tweetsUS_120.json", locations = c(-125, 25, -66, 50), timeout = 120,
#             oauth = my_oauth)
tweets_120.df <- parseTweets("tweetsUS_120.json", verbose = FALSE)
tweets_120.df <- tweets_120.df %>% filter(!is.na(lat))
write.csv(tweets_120.df, "tweetsUS_120.csv")
# #flatten(tweets.df)
# #tweets.df<- cleanTweets(tweets.df)
# 
# map.data <- map_data("state")
# points <- data.frame(x = as.numeric(tweets.df$lon), y = as.numeric(tweets.df$lat))
# points <- points[points$y > 25, ] %>% na.omit()
# 
# ajw.us.tweets <- ggplot(map.data) + 
#   geom_map(aes(map_id = region), map = map.data, fill = "white", color = "grey20", size = 0.25) + 
#   expand_limits(x = map.data$long, y = map.data$lat) + 
#   theme(axis.line = element_blank(), axis.text = element_blank(), axis.ticks = element_blank(), 
#         axis.title = element_blank(), panel.background = element_blank(), panel.border = element_blank(), 
#         panel.grid.major = element_blank(), plot.background = element_blank(), 
#         plot.margin = unit(0 * c(-1.5, -1.5, -1.5, -1.5), "lines")) + 
#   geom_point(data = points, aes(x = x, y = y), size = 1, alpha = 1/5, color = "darkblue")

# plot(ajw.us.tweets)
# p <- ggplotly(ajw.us.tweets)
# ggplot(map.data) + 
#   geom_map(aes(map_id = region), map = map.data, fill = "white", color = "grey20", size = 0.25) + 
#   expand_limits(x = map.data$long, y = map.data$lat) + 
#   theme(axis.line = element_blank(), axis.text = element_blank(), axis.ticks = element_blank(), 
#         axis.title = element_blank(), panel.background = element_blank(), panel.border = element_blank(), 
#         panel.grid.major = element_blank(), plot.background = element_blank(), 
#         plot.margin = unit(0 * c(-1.5, -1.5, -1.5, -1.5), "lines")) + 
#   geom_point(data = points, aes(x = x, y = y), size = 0.75, alpha = 1/5, color = "darkblue")

#devtools::install_github("ropensci/plotly")

