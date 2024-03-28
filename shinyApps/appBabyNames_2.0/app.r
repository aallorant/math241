library(shiny)
library(tidyverse)
library(babynames)
library(DT)

# User interface

ui <- fluidPage(
  titlePanel("Which Math 241 name is most popular?"),
  sidebarLayout(
    sidebarPanel(
      # Create a text input widget
      selectizeInput(inputId = "names",
                     label = "Enter Math 241 names here",
                     choices = NULL,
                     multiple = TRUE),
      p("Put single space between the names."),
      radioButtons(inputId = "variable",
                   label = "Variable of Interest",
                   choices = c("n", "prop"),
                   selected = "prop"),
      sliderInput("year_range", "Range of Years:",
                  min = min(babynames$year), 
                  max = max(babynames$year),
                  value = c(1980, 2010),
                  sep = ""),
      submitButton("Update Results!")
      
    ),
    mainPanel(
      plotOutput(outputId = "graph"),
      dataTableOutput(outputId = "table")
      
    )
  )
)

# Server function
server <- function(input, output, session){
  
  updateSelectizeInput(session, 'names', 
                       choices = unique(babynames$name), 
                       server = TRUE)
  
  
  dat_names <- reactive({ babynames %>%
    group_by(year, name) %>%
    summarize(n = sum(n)) %>%
    group_by(year) %>%
    mutate(prop = n/sum(n)) %>%
    filter(name %in% c(unlist(str_split(input$names, " "))),
           year >= input$year_range[1], 
           year <= input$year_range[2]) })
  
  
  output$graph <- renderPlot({
    
    ggplot(data = dat_names(), 
           mapping = aes_string(x = 'year', y = input$variable, color = 'name')) +
      geom_line(size = 2)
  })
  
  dat_names_agg <- reactive({ 
    dat_names() %>%
      group_by(name) %>%
      summarize(count = sum(n)) %>%
      arrange(desc(count))
  })
  
  output$table <- renderDataTable({
    datatable(dat_names_agg(), 
                  options = list(paging = FALSE,
                                 searching = FALSE,
                                 orderClasses = TRUE))
  })
  
}

# Creates app
shinyApp(ui = ui, server = server)
