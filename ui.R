#loading of all the neccesary libraries

library(shiny)


# Define UI for application shows position in the room - real and estimated
shinyUI(pageWithSidebar(
        
        # Application title
        headerPanel("Estimate your position with Beacons!"),
        
        # Sidebar with a slider input for number of observations
        sidebarPanel(
                ('Change your position (black dot) in the room and see how your estimated position (red viewfinder) changes. You can also change number of beacons (BLE transmitters) in the room and see how it affects the estimation error. Enjoy!'),
                (' '),
                sliderInput("xPosition", 
                            "Change your position in the room: x:", 
                            min = 0,
                            max = 20, 
                            value = 10,
                            step = 0.1),
                sliderInput("yPosition", 
                            "Change your position in the room: y:", 
                            min = 0,
                            max = 10, 
                            value = 5,
                            step = 0.1),
                selectInput("beaconsNumber", "Choose number of beacons in the Room:", choices = c(3:8))
        ),
        
        # Show a plot of point's position
        mainPanel(
                plotOutput("pointPosition"),
                plotOutput("signalPlot")                                        
        )
))