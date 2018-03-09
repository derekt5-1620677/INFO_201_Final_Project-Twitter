library(shiny)
library('dplyr')

# creates the UI for the app, with a widget on the side and a tab containing data table
fl.ui <- fluidPage(
  sidebarPanel(
    textInput("city.name", label = "Enter a Country Name"),
    helpText("lower case (i.e. canada)")
  ),
  mainPanel(
    tabsetPanel(type = "tabs",
                tabPanel("Location Summary", textOutput("fl.countrytext"), tableOutput("fl.countrytable")),
                          h2("Interpretation"), helpText("This table shows the worldwide locations of trending tweets.
                                 The data is dependent on the number of tweets in a certain
                                                         city. We want this information because it tells us where news
                                                         travels to and what type of people care (i.e. people in the 
                                                         city vs people in the suburbs)."))
                
  )
)



fl.server <- function(input, output) {
  # reading the csv file
  fl.trends.data <- read.csv("./available_locations.csv")
  
  # tallies the total number of cities 
  fl.trends.count <- reactive({
    fl.trends.namecount <- fl.trends.data %>%
      filter(name != "Worldwide") %>%
      mutate(country = tolower(country)) %>%
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
      mutate(country = tolower(country)) %>%
      select(country, name) %>%
      filter(country == input$city.name)
    return(fl.trends.name)
  })
  # outputting the table
  output$fl.countrytable <- renderTable(fl.trends.country())
  
  output$fl.mytext <- renderText("This table shows the worldwide locations of trending tweets.
                                 The data is dependent on the number of tweets in a certain
                                 city. We want this information because it tells us where news
                                 travels to and what type of people care (i.e. people in the 
                                 city vs people in the suburbs).")
}

shinyApp(ui = fl.ui, server = fl.server)

                    
