

my.ui <- fluidPage(
  mainPanel(
    tabsetPanel(type = "tabs",
                tabPanel("Popular Tweets",
                h2("Trending Tweets of the Day"),
                dataTableOutput("table")),
                helpText("yo"),
                plotOutput("Plot")
               
  )
  
  
))
