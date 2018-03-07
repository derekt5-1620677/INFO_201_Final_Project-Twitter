# place your server code here
# install.packages("plotly")
library(plotly)
library(dplyr)
library(maps)

##### Data Wrangling #####
## Here we get the data we want ##
available.locations.df <- read.csv("available_locations.csv",
                                   stringsAsFactors = FALSE)
ncol.of.first.avail.locations.df <- ncol(available.locations.df)
available.locations.df <- 
  available.locations.df[, 2:ncol.of.first.avail.locations.df]

us.locations.df <- filter(available.locations.df, country == "United States")


## Now we output a map of all the trends for each city.
server <- function(input, output) {
  
  output$map <- renderPlot({
    
  })
}