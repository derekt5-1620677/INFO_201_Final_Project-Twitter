

my.ui <- fluidPage(
  mainPanel(
    tabsetPanel(type = "tabs",
                tabPanel("Popular Tweets",
                h2("Trending Tweets of the Day"),
                helpText("The table below shows the top ten trending topics that are tweeted and 
                selects the most popular (most liked) tweet in each topic."),
                dataTableOutput("table"),
                textOutput("text"))
               
  )
  
  
))
