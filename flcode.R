library(shiny)
library('dplyr')

# creates the UI for the app, with a widget on the side and a tab containing data table
fl.ui <- fluidPage(
  sidebarPanel(
    textInput("city.name", label = "Enter a Country")
  ),
  mainPanel(
    tabsetPanel(type = "tabs",
                tabPanel("Location Summary", textOutput("fl.countrytext"), tableOutput("fl.countrytable"))
               )
  )
)



fl.server <- function(input, output) {
  # reading the csv file
  fl.trends.data <- read.csv("./available_locations.csv")
  
  # tallies the total number of cities 
  fl.trends.count <- reactive({
    fl.trends.namecount <- fl.trends.data %>%
      filter(name != "Worldwide") %>%
      filter(country == input$city.name) %>%
      summarize(total = n())
    return(fl.trends.namecount)
  })
  # decides if city should be plural or singular based on count
  ChooseWord <- function(number) {
    if (number != 1) {
      paste("cities")
    } else {
      paste("grcity")
    }
  } 
  # prints the text
  country.text <- reactive({
    paste("This table shows the", fl.trends.count(), ChooseWord(fl.trends.count()),
          "where the most popular tweets come from in", input$city.name, ".")
  })
  output$fl.countrytext <- renderText(country.text())
  
  # filtering the dataset so only the cities in specified input country show
  fl.trends.country <- reactive({
    fl.trends.name <- fl.trends.data %>%
      filter(name != "Worldwide") %>%
      select(country, name) %>%
      filter(country == input$city.name)
    return(fl.trends.name)
  })
  # outputting the table
  output$fl.countrytable <- renderTable(fl.trends.country())
}

shinyApp(ui = fl.ui, server = fl.server)

                    
