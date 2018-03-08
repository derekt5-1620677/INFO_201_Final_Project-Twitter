# reserved for app

source('apiKey.R')

library(shiny)

source('ui.R')

source('server.R')

shinyApp(ui = my.ui , sever = my.server )

