library(shiny)
library(dplyr)

my.ui <- fluidPage(
  
  # Title
  titlePanel("Tweet Words"),
  
  
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
                           textInput("city.name", label = "Enter a Country")
                         ),
                         textOutput("fl.countrytext"), 
                         tableOutput("fl.countrytable")),
                tabPanel("Map Of News Interest",
                         plotOutput("map"))
               
  )
  
  
))
