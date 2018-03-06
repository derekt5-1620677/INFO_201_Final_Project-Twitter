# place your server code here
library(ggplot2)

# Data
# <- read.csv()

server <- function(input, output) {
  output$map <- renderPlot({
    # ggplot()
  })
}