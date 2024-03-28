# Load libraries
library(shiny)
library(mosaic)
library(tidyverse)



# User interface

ui <- fluidPage(
  titlePanel("Graph of Births"),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("day", label = "Which Days Do you Want to Display?", 
                         choices = unique(Births2015$wday),
                         selected = "Sun"),
      dateRangeInput("dates",
                     label = "Select Range of Dates",
                     start = "2015-01-01", end = "2015-12-31",
                     min = "2015-01-01", max = "2015-12-31")
    ),
    mainPanel(plotOutput("graph")
    )
  )
)

# Server function

server <- function(input, output){
  
  output$graph <- renderPlot({
    
    Births2015 %>%
      filter(wday %in% input$day, 
             date <= input$dates[2], date >= input$dates[1]) %>%
      ggplot(mapping = aes(x = date, y = births, 
                           color = wday)) + 
      geom_point() + 
      theme(legend.position = "bottom")
  })
  
}

# Creates app

shinyApp(ui = ui, server = server)