library(shiny)
library(dplyr)

my.ui <- fluidPage(
  
  # Title
  titlePanel("Live Twitter Data"),
  
  
  mainPanel(
    tabsetPanel(type = "tabs",
                tabPanel("Popular Tweets", 
                         h2("Current Trending Tweets"), 
                         helpText("The table below shows the top ten trending 
                                  topics that are tweeted in the United States 
                                  and selects the most popular (most liked) tweet 
                                  in each topic."),
                         dataTableOutput("table"), 
                         h3("The Most Popular Tweet Currently"), textOutput("text")),
                tabPanel("Location Summary",
                         sidebarPanel(
                           textInput("city.name", label = "Enter a Country")),
                         textOutput("fl.countrytext"), 
                         tableOutput("fl.countrytable")),
                tabPanel("Map Of News Interest", 
                         # Help Text
                         helpText("This map shows the popularity of breaking nationwide",
                                  "headlines in all available tweet locations. "),
                         helpText("It plots a point at each of the available Twitter ",
                                  "locations. The more popular the national ",
                                  "headlines are in a particular location, the redder ",
                                  "the point becomes. Below, we can see how interested ",
                                  "the cities are in the following national headlines ",
                                  textOutput("breaking.news.headline", container = span)),
                         textOutput("loc.and.ranking"),
                         plotOutput("map", click = "click.location")
                         )
                )
    )
)