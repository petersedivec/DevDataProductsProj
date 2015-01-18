library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Effect of Diet on Chick Weight ~ Growth Comparison Over Time"),
    
    # Sidebar with a slider input for the number of bins
    sidebarLayout(
        sidebarPanel(
            h4("ChickWeight Data Set Controls"),
            p("The input controls allowsuser to select ending weight of a Chick
              and to select two diets for a side-by-side comparison"),
            uiOutput("chickWeightSlider"),
            selectInput("diet1", label="Diet", choices = unique(ChickWeight$Diet), 
                        selected = 1),
            selectInput("diet2", label="Diet", choices = unique(ChickWeight$Diet), 
                        selected = 2),
            h4("Diet Comparison Output"),
            p("The output illustrated to the right provides a visualization of 
              chick growth as a function of time and a side-by-side comparison
              of the two diets selected. The data table summarizes the chick 
              data by diet providing the total # of chicks, average starting and
              ending weights and the % growth over time"),
            h4("Note / Warning"),
            p("If you select the same Diet and/or are too restrictive by 
              selecting Chick End Weight, it's possible that you will only see
              a single graph or no graph at all if you over constrain the data
              set")
            ),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("weightPlot"),
            h4("Data Table Summarizing Chick Growth by Diet"),
            dataTableOutput('ChickSummary')
        )
    )
))
