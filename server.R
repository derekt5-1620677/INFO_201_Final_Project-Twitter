# install.packages("jsonlite")
# install.packages("httr")
# install.packages("maps")
# install.packages("dplyr")
# install.packages("ggplot2")
# install.packages("shiny")
# install.package("plotly")
# install.packages("streamR")
library(jsonlite)
library(httr)
library(twitteR)
library(shiny)
library(ggplot2)
library(dplyr)
library(maps)
library(plotly)
library(streamR)

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
  filter(city %in% us.locations.df[, "name"]) %>%
  select(latitude, longitude, city, state) # Selects location, city, and state

# Filters out rows that have multiple locations for the same city
row.num <- 1
new.us.loc.long.and.lat <- as.data.frame(c(c()))
while (row.num <= nrow(us.locations.long.and.lat)) {
  row <- us.locations.long.and.lat[row.num, ]
  if (row.num == 1) {
    new.us.loc.long.and.lat <- row
  } else if (!(row[, "city"] %in% new.us.loc.long.and.lat[, "city"])) {
    new.us.loc.long.and.lat <- rbind(new.us.loc.long.and.lat, row)
  }
  row.num = row.num + 1
}

ultimate.us.loc.woeid.df <- left_join(us.locations.df, new.us.loc.long.and.lat,
                                      by = c("name" = "city"))
ultimate.us.loc.woeid.df <- 
  ultimate.us.loc.woeid.df %>%
  filter(!is.na(latitude), !is.na(longitude), !is.na(state))


# Load in map data
usa.map.df <- map_data("state")


my.server <- function(input,output) {

    output$map <- renderPlot({
      # Get the news articles popular in the US
      news.article.title <- breakingNewsTitle()
      
      ## See if any of the news articles are of interest to any of the ##
      ## cities in the US. ##
      
      # Get locations
      local.woeids <- ultimate.us.loc.woeid.df[, "woeid"]
      # Now get trends for all the locations
      us.locations.local.trends <- getTrendsForAll(local.woeids)
      # See if the trending words can be found in the news titles
      # and then rank
      adjusted.rank <- GetAdjustedRank()
      
      
      ggplot() + 
        geom_polygon(mapping = aes(x = long, y = lat, group = group), 
                     fill = "white", color = "blue",
                     data = usa.map.df) +
        geom_point(mapping = aes(x = longitude, y = latitude, color = "Interest in Countrywide News"),
                   color = rgb(adjusted.rank, 0, 0, maxColorValue = 51),
                   size = 2, data = ultimate.us.loc.woeid.df) +
        scale_color_brewer(palette = "OrRd") +
        coord_quickmap()
  })
  
  ## Gets the most popular national headlines title as output
  output$breaking.news.headline <- renderText({
    return(breakingNewsTitle())
  })
    
  
  ## Gets the most popular national headlines title as reactive function
  breakingNewsTitle <- function() {
    json.list <- requestContent()
    top.news.articles <- json.list$articles
    news.article.title <- top.news.articles[[1]][["title"]]
    return(news.article.title)
  }
    
  ## Sends HTTP request and extracts content
  requestContent <- function() {
    source("newsapikey.R")
    # URI
    base.uri <- "https://newsapi.org/v2"
    resource.uri <- "/top-headlines"
    
    # Get response through sending HTTPS request
    json.data.response <- GET(paste0(base.uri, resource.uri),
                              query = 
                                list("country" = "us", "sortBy" = "popularity"),
                              add_headers("X-Api-Key" = news.api.key))
    # Extract content as string and convert in R list format
    json.string.content <- content(json.data.response, "text")
    json.list <- fromJSON(json.string.content)
    return(json.list)
  }
  
  
  getTrendsForAll <- function(woeids) {
    return(lapply(woeids, getTrends))
  }
  
  
  ## Returns a vector that correlates color intensity with rank
  ## of national news for the location. If rank is 1, then color intensity is 51.
  ## (The reason for that number is to allow for when the national news is not even
  ## in the local trends).
  FindMatchAndRankAdjustedAll <- function(list.of.us.locations.local.trends, news.article.title) {
    # us.locations.local.trends is a list of dataframes
    # Each dataframe is a set of trends from a particular city.
    
    # Note: "name" column has words
    # Gets a vector of trending words in tweets
    vector.of.ranks <- c()
    
    # Get all the ranks for each city and location
    i = 1
    while (i <= length(list.of.us.locations.local.trends)) {
      rank <- FindMatchAndRank(list.of.us.locations.local.trends[[i]][, "name"], news.article.title)
      if (is.na(rank)) {
        rank <- 51
      }
      # Extract the woeid
      woeid <- list.of.us.locations.local.trends[[i]][1, "woeid"]
      vector.of.ranks <- c(vector.of.ranks, c(woeid = rank))
      i <- i + 1
    }
    
    rank.final <- 52 - vector.of.ranks
    return(rank.final)
  }
  
  # Returns the rank for national news in "local.trends" of a particular city.
  ## 1 would be the most popular (ranked as 1st). Bigger numbers
  ## means less popularity.
  FindMatchAndRank <- function(local.trends, news.article.title) {
    
    # Finds which local trending tweet words have words from the top news
    # article.
    vect.of.log <- sapply(local.trends, grepl, news.article.title)
    
    # Finds how popular the news is with that location
    index <- FindRank(local.tweet.trends, vect.of.log)
    return(index)
  }
  
  FindRank <- function(tweet.trends, lv) {
    return(match(TRUE, lv))
  }
  
  GetAdjustedRank <- reactive({
    local.woeids <- ultimate.us.loc.woeid.df[, "woeid"]
    # Now get trends for all the locations
    us.locations.local.trends <- getTrendsForAll(local.woeids)
    
    # See if the trending words can be found in the news titles
    # and then rank
    adjusted.rank <- FindMatchAndRankAdjustedAll(us.locations.local.trends, breakingNewsTitle())
    return(adjusted.rank)
  })
  
  
  output$loc.and.ranking <- renderText({
    row <- nearPoints(ultimate.us.loc.woeid.df, input$click.location,
                      xvar = "longitude", yvar = "latitude")
    adjusted.rank <- GetAdjustedRank()
    rank <- -(adjusted.rank[row[1, "woeid"]] - 52)
    city <- row[1, "name"]
    return(paste0(city, ": ", rank))
  })
}
