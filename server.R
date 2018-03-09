# install.packages("jsonlite")
# install.packages("httr")
# install.packages("maps")
# install.packages("dplyr")
# install.packages("ggplot2")
# install.packages("shiny")
# install.package("plotly")
library(jsonlite)
library(httr)
library(twitteR)
library(shiny)
library(ggplot2)
library(dplyr)
library(maps)
library(plotly)

#### Derek ####

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

#### End of Derek ####


my.server <- function(input,output) {

### apisara ###
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
  arrange.for.text <- arrange(name.and.likes, -number.of.likes)
  
  #selects first row and column of newly arranged data
  most.pop.arranged <- arrange.for.text[1,1]
  
  #converts to character vector
  character.arranged <- as.character(most.pop.arranged)
  
  #Searches for the text of the most popular tweet
  text.for.popular <- searchTwitter(character.arranged, n=1, resultType = 'mixed')
  text.sentence <- text.for.popular[[1]]$text
  
  #Selects rows and column of interest
  #top.popular <- arrange.by.likes[1,1]
  top.popular <- arrange.for.text[1,1]
  
  #top.liked <- arrange.by.likes[1,2]
  top.liked <- arrange.for.text[1,2]
  
  #Creates a changing text that corresponds with the data table
  output$text <- renderText({
    bar.info <- paste("From the data above, we can see that the most popular tweet (by most talked
                      about and most liked) at this exact momment is about",top.popular,", with",top.liked,
                      "likes. The tweet states",text.sentence)
    
  })
  
### florie ###
  fl.trends.data <- read.csv("./available_locations.csv")
  
  # tallies the total number of cities 
  fl.trends.count <- reactive({
    fl.trends.namecount <- fl.trends.data %>%
      filter(name != "Worldwide") %>%
      filter(country == input$city.name) %>%
      summarize(total = n())
    return(fl.trends.namecount)
  })
  # decides if city should be plural or singular based on count
  ChooseWord <- function(number) {
    if (number != 1) {
      paste("cities")
    } else {
      paste("grcity")
    }
  } 
  # prints the text
  country.text <- reactive({
    paste("This table shows the", fl.trends.count(), ChooseWord(fl.trends.count()),
          "where the most popular tweets come from in", input$city.name, ".")
  })
  output$fl.countrytext <- renderText(country.text())
  
  # filtering the dataset so only the cities in specified input country show
  fl.trends.country <- reactive({
    fl.trends.name <- fl.trends.data %>%
      filter(name != "Worldwide") %>%
      select(country, name) %>%
      filter(country == input$city.name)
    return(fl.trends.name)
  })
  # outputting the table
  output$fl.countrytable <- renderTable(fl.trends.country())

  
  ### Derek ####
  output$map <- renderPlot({
    # Get the news articles popular in the US
    json.list <- requestContent()
    top.news.articles <- json.list$articles
    news.article.title <- top.news.articles[1, "title"]
    
    ## See if any of the news articles are of interest to any of the #
    ## cities in the US. ##
    
    # Get locations
    local.woeids <- ultimate.us.loc.woeid.df[, "woeid"]
    # Now get trends for all the locations
    us.locations.local.trends <- getTrendsForAll(local.woeids)
    
    # See if the trending words can be found in the news titles
    # and then rank
    adjusted.rank <- FindMatchAndRankAdjustedAll(us.locations.local.trends, news.article.title)
    
    ggplot() + 
      geom_polygon(mapping = aes(x = long, y = lat, group = group), 
                   fill = "white", color = "blue",
                   data = usa.map.df) +
      geom_point(mapping = aes(x = longitude, y = latitude, color = "Interest in Countrywide News"),
                 color = adjusted.rank, data = ultimate.us.loc.woeid.df) +
      coord_quickmap()
  })
  
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
      vector.of.ranks <- c(vector.of.ranks, rank)
      i <- i + 1
    }
    
    rank.final <- 52 - vector.of.ranks
    return(rank.final)
  }
  
  # Returns the rank for "local.trends" of a particular city
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
  
  ### About Tab ###
  
  output$about_tab <- renderUI({
    return("Welcome! This app makes use of the Twitter API and the twitteR library
           by Jeff Gentry. Our goal is to provide various small visualizations to
           better understand how trending tweets match up current social issues/news 
           stories. This project is brought to you by Florrie Li, Apisara Krassner, 
           Derek Tseng, and Andrew Wu.")
  })
}
