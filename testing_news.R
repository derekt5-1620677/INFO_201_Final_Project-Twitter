# install.packages("httr")
# install.packages("jsonlite")
library(httr)
library(jsonlite)

### We want to get the headlines and breaking news of the US as a whole. ###
### Therefore, we want to get the headlines, for easier comparison, ###
### we will sort by rank. ###

source("newsapikey.R")
# URI
base.uri <- "https://newsapi.org/v2"
resource.uri <- "/top-headlines"

# json.string.response <- GET(paste0(base.uri, resource.uri,
#                                    "?country=us", "&sortBy=popularity"),
#     add_headers("X-Api-Key" = news.api.key))

json.data.response <- GET(paste0(base.uri, resource.uri),
                            query = 
                              list("country" = "us", "sortBy" = "popularity"),
                            add_headers("X-Api-Key" = news.api.key))

json.string.content <- content(json.data.response, "text")
json.list <- fromJSON(json.string.content)
