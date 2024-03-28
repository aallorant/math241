# Load libraries
library(shiny)
library(mosaic)
library(tidyverse)



# User interface
ui <- fluidPage(
  titlePanel("Graph of Births"),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("day", label = h3("Which Days Do you Want to Display?"), 
                         choices = unique(Births2015$wday),
                         selected = "Sun")
    ),
    mainPanel(plotOutput("graph")
    )
  )
)

# Server function
server <- function(input, output){
  
  output$graph <- renderPlot({
    
    Births2015 %>%
      filter(wday %in% input$day) %>%
    ggplot(mapping = aes(x = date, y = births, 
                         color = wday)) + 
      geom_point() + 
      theme(legend.position = "bottom")
  })
  
}

# Creates app
shinyApp(ui = ui, server = server)