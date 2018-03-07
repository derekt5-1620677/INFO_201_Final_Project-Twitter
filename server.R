##### Server Code #####

# install.packages("maps")
# install.packages("dplyr")
# install.packages("ggplot2")
# install.packages("shiny")
library(twitteR)
library(shiny)
library(ggplot2)
library(dplyr)
library(maps)


########################## Authentication ###############################

############# Twitter ###############
source("apikey.R")
setup_twitter_oauth(api.key, api.secret, access.token.secret)





############################# Data Wrangling ############################

###################################################
###### Gather available Twitter US locations ######
###################################################

available.locations.df <- read.csv("available_locations.csv",
                                   stringsAsFactors = FALSE)
ncol.of.first.avail.locations.df <- ncol(available.locations.df)

# Following line rids the first column because it contains the numbering for 
# each of the rows
available.locations.df <- 
  available.locations.df[, 2:ncol.of.first.avail.locations.df]

# Filters for US locations
us.locations.df <- filter(available.locations.df, country == "United States")



###############################################
####### Locations of interested cities ########
###############################################

# Read another CSV file of cities with their longitude and latitude 
# for plotting their location.
us.locations.long.and.lat <- read.csv("zip_codes_states.csv")

# Because it includes Puerto Rico, Alaska, and Hawaii, which is not what
# we want.

# Read another CSV file that has state abbreviations. This file
# includes Alaska and Hawaii.
us.state.abbreviations <- read.csv("states.csv")
# Filters for the 48 contiguous states
us.state.abbreviations <- 
  us.state.abbreviations %>%
  filter(State != "Alaska" & State != "Hawaii")


#####################################
# Filters all the locations are in the 48 states and those that
# avail in Twitter
#####################################
us.locations.long.and.lat <- 
  us.locations.long.and.lat %>% 
  filter(state %in% us.state.abbreviations[, "Abbreviation"]) %>%
  filter(city %in% us.locations.df[, "name"])



### Now we want to get the headlines across the US. ###
usa.map.df <- map_data("usa")

server <- function(input, output) {
  
  output$map <- renderPlot({
    # Get the news articles popular in the US
    source("testing_news.R")
    top.news.articles <- json.list$articles
    
    # See if any of the news articles are of interest to any of the 
    # cities in the US.
    news.article.title <- top.news.articles[2, "title"]
    local.woeids <- us.locations.df[, "woeid"]
    
    us.locations.local.trends <- getTrendsForAll(local.woeids)
    
    ggplot() + 
      geom_polygon(mapping = aes(x = long, y = lat, group = group), 
                   fill = "black",
                   data = usa.map.df) +
      geom_point(mapping = aes(x = longitude, y = latitude),
                 color = "white", size = 1, data = us.locations.long.and.lat) +
      coord_quickmap()
  })
  
  
  getTrendsForAll <- function(woeids) {
    return(lapply(woeids, getTrends))
  }
  
}