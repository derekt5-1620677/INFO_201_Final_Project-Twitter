library(shiny)
library('dplyr')

fl.ui <- fluidPage(
  mainPanel(
    tabsetPanel(type = "tabs",
                tabPanel("Summary of Locations", dataTableOutput("fl.table"), textOutput("fl.text")))
  )
)

fl.trends.data <- read.csv("./available_locations.csv")

fl.server <- function(input, output) {
  output$fl.table <- renderDataTable(
    fl.trends.table <- fl.trends.data %>%
      filter(country != "") %>%
      group_by(country) %>%
      select(country) %>%
      mutate(cities = n()) %>%
      distinct()
  )
  output$fl.text <- renderText("This table gives the number of different cities in the
                               countries that are allowed access to Twitter.")
}

shinyApp(ui = fl.ui, server = fl.server)

                    
