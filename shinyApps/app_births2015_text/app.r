# Load libraries
library(shiny)
library(mosaic)
library(tidyverse)
library(glue)
library(lubridate)

# User interface

ui <- fluidPage(
  titlePanel("Super Awesome Graph of Births!"),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("day", label = "Which Days Do you Want to Display?", 
                         choices = unique(Births2015$wday),
                         selected = unique(Births2015$wday)),
      dateRangeInput("dates",
                     label = "Select Range of Dates",
                     start = as_date("2015-01-01"), end = as_date("2015-12-31"),
                     min = as_date("2015-01-01"), max = as_date("2015-12-31"))
    ),
    mainPanel(plotOutput("graph"), textOutput("max_babies")
    )
  )
)

# Server function

server <- function(input, output){
  
  Births2015_reactive <- reactive({
    Births2015 %>%
      filter(wday %in% input$day, 
             date <= input$dates[2], date >= input$dates[1])
    
  })
  
  
  output$graph <- renderPlot({
    
    Births2015_reactive() %>%
      ggplot(mapping = aes(x = date, y = births, 
                           color = wday)) + 
      geom_point() + 
      theme(legend.position = "bottom")
  })
  
  output$max_babies <- renderText({
    Births2015_max <- Births2015_reactive() %>%
      filter(births == max(births))
    
    
    glue("Between ", format(min(Births2015_reactive()$date), "%A, %B %d, %Y"), " and ",
         format(max(Births2015_reactive()$date), "%A, %B %d, %Y"),
         " and for the selected days of the week, the day with the most babies born was ", 
         format(Births2015_max$date, "%A, %B %d, %Y"),
         " with ", Births2015_max$births,
         " babies born that day!")
  })
  
}

# Creates app

shinyApp(ui = ui, server = server)