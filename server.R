# place your server code here
# install.packages("plotly")
library(plotly)
library(dplyr)
library(maps)

##### Data Wrangling #####
## Here we filter for US locations only ##
available.locations.df <- read.csv("available_locations.csv",
                                   stringsAsFactors = FALSE)
ncol.of.first.avail.locations.df <- ncol(available.locations.df)
# The following line gets rid of the row numbers on the data frame
available.locations.df <- 
  available.locations.df[, 2:ncol.of.first.avail.locations.df]
# Filtering for US locations
us.locations.df <- filter(available.locations.df, country == "United States")

## We want to get trends for the US as a whole, and then compare these to ##
## the trends of each available city. ##
server <- function(input, output) {
  
  
  
  output$map <- renderPlot({
    
  })
}