#loading of all the neccesary libraries

library(shiny)


# Define UI for application shows position in the room - real and estimated
shinyUI(pageWithSidebar(
        
        # Application title
        headerPanel("Estimate your position with Beacons!"),
        
        # Sidebar with a slider input for number of observations
        sidebarPanel(
                sliderInput("xPosition", 
                            "Choose your position in the Room: x:", 
                            min = 1,
                            max = 20, 
                            value = 10,
                            step = 0.1),
                sliderInput("yPosition", 
                            "Choose your position in the Room: y:", 
                            min = 1,
                            max = 10, 
                            value = 5,
                            step = 0.1),
                selectInput("beaconsNumber", "Choose number of beacons in the Room:", choices = c(3:8))
        ),
        
        # Show a plot of point's position
        mainPanel(
                plotOutput("pointPosition"),
                tableOutput("chosen"),
                verbatimTextOutput("chosenList"),
                verbatimTextOutput("distanceList"),
                verbatimTextOutput("signalList")
                
                                                
        )
))