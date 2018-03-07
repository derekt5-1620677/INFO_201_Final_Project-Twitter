##### Server Code #####

# install.packages("maps")
# install.packages("dplyr")
library(dplyr)
library(maps)

##### Data Wrangling #####
## Gather US locations ##
available.locations.df <- read.csv("available_locations.csv",
                                   stringsAsFactors = FALSE)
ncol.of.first.avail.locations.df <- ncol(available.locations.df)

# Following line rids the first column because it contains the numbering for 
# each of the rows
available.locations.df <- 
  available.locations.df[, 2:ncol.of.first.avail.locations.df]

# Filters for US locations
us.locations.df <- filter(available.locations.df, country == "United States")


## Now we want to get the headlines of US as a whole. ##
source("testing_news.R")
usa.map.df <- map_data("usa")

server <- function(input, output) {
  
  output$map <- renderPlot({
    ggplot()
  })
}