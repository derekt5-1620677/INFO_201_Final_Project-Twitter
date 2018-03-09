library(shiny)
library(dplyr)

my.ui <- fluidPage(
  
  # Title
  titlePanel("Tweet Words"),
  
  
  mainPanel(
    tabsetPanel(
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
