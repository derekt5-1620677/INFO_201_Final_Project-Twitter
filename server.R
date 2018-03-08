# place your server code here

library(streamR)
library(twitteR)

library(shiny)

library(dplyr)
library(lubridate)
library(grid)
library(png)
library(ROAuth)
library(devtools)

#tweets.df <- read.csv(file = "tweetsUS_300.csv",stringsAsFactors = FALSE, fileEncoding="UTF-8-BOM")
tweets.df <- parseTweets("tweetsUS_300.json", verbose = FALSE)
points <- data.frame(x = as.numeric(tweets.df$lon), y = as.numeric(tweets.df$lat))
points <- points[points$y > 25, ] %>% na.omit()

#tweets.df <- data.frame(tweets.df)
server <- function(input, output) {
  output$map <- renderPlot({
    
    map.data <- map_data("state")
    # points <- data.frame(x = as.numeric(tweets.df$lon), y = as.numeric(tweets.df$lat))
    # points <- points[points$y > 25, ] %>% na.omit()
    
    ajw.us.tweets <- ggplot(map.data) + 
      geom_map(aes(map_id = region), map = map.data, fill = "white", color = "grey20", size = 0.25) + 
      expand_limits(x = map.data$long, y = map.data$lat) + 
      theme(axis.line = element_blank(), axis.text = element_blank(), axis.ticks = element_blank(), 
            axis.title = element_blank(), panel.background = element_blank(), panel.border = element_blank(), 
            panel.grid.major = element_blank(), plot.background = element_blank(), 
            plot.margin = unit(0 * c(-1.5, -1.5, -1.5, -1.5), "lines")) + 
      geom_point(data = points, aes(x = x, y = y), size = 1, alpha = 1/5, color = "darkblue")  
    
    return(ajw.us.tweets)
  })
  
  output$map_info <- renderUI({
    # tweet.data <- tweets.df %>% filter(!is.na(lat))
    # 
    # click.data <- input$map_click
    # click.point <- tweet.data %>% filter(lat == click.data[1], lon == click.data[2])
    
    
    nearPoints(points, input$map_click, xvar = x)
  })
}