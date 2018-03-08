

my.ui <- fluidPage(
  mainPanel(
    tabsetPanel(type = "tabs",
                tabPanel("Popular Tweets",
                h2("Current Trending Tweets"),
                helpText("The table below shows the top ten trending topics that are tweeted in the
                          United States and selects the most popular (most liked) tweet in each topic."),
                tableOutput("table"),
                plotOutput("plot"),
                h3("The Most Popular Tweet Currently"),
                textOutput("text"))
               
  )
  
  
))
