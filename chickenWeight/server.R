library(plyr)
library(ggplot2)
library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    # Calculate the ending (max) Chick weight for reach Chick using tapply
    maxChickWeight <- adply(tapply(ChickWeight$weight, ChickWeight$Chick, max), 
                            .margins=1)
    colnames(maxChickWeight) <- c('Chick', 'maxWeight')
    
    # Subset the source ChickWeight DataFrame based on diet & ending chick weight
    # user inputs
    chickDataSet <- reactive({ 
        chicks <- subset(maxChickWeight, maxWeight<input$chicks[2] & maxWeight>input$chicks[1])
        subset(ChickWeight,Diet==c(input$diet1, input$diet2) & Chick %in% chicks$Chick)
        })
    
    # Use renderUI to render the sliderInput because we want to base the min/max
    # values on the data frame and not hard-code them
    output$chickWeightSlider <- renderUI({
        maxMaxCW <- max(maxChickWeight$maxWeight)
        minMaxCW <- min(maxChickWeight$maxWeight)        
        sliderInput("chicks",
                    h5("Select Ending Chick Weight"),
                    min = minMaxCW,
                    max = maxMaxCW,
                    value = c(minMaxCW,maxMaxCW))
    })
    
    # Use ddply to summarize statistics about the two diets selected for comparison
    output$ChickSummary <- renderDataTable({
        d <- ddply(chickDataSet(), .(Chick, Diet), summarize, min=min(weight), 
              max=max(weight), perGrowth = (max-min)/min*100)
        ddply(d, .(Diet), summarize, 
              count=length(unique(Chick)), aveStartWeight = mean(min),
              aveEndWeight = mean(max), avePerGrowth = mean(perGrowth))
    })    
    
    # Render the ggplot showing a comparison of the diets selected
    output$weightPlot <- renderPlot({
        p <- ggplot(aes(x=Time, y=weight), 
                    data=chickDataSet()) + 
            geom_line(aes(group=Chick)) + facet_wrap(~Diet) + 
            ggtitle("Diet comparison of Diets:")
        print(p)
    })

})