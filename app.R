library(shiny)

source('apikey.R')
source('ui.R')
source('server.R')

shinyApp(ui = my.ui , server = my.server )


