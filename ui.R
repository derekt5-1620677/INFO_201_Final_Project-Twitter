# place your ui code here
ui <- fluidPage(
  # Title
  titlePanel("Tweet Words"),
  
  # Main Panel
  mainPanel(
    # Heading
    h2("Map"),
    
    # Map Tab
    tabsetPanel(
      type = "tabs",
      tabPanel(
        "Map",
        plotOutput("map")
      )
    )
    
  )
  
  
)