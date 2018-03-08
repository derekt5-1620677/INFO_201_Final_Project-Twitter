# place your ui code here

library(dplyr)
library(shiny)
library(ggplot2)
library(tidyr)
library(maps)

ui <-fluidPage(
  titlePanel("Info 201 Twitter Data Final Project"),
  mainPanel(
    tabsetPanel(type = "tabs", tabPanel("Map", plotOutput("map")))
  )
)
