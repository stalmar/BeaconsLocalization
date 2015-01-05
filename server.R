library(shiny)

# Definition of constatnt things
#
## environment and beacons definition

room <-rbind(c(0,0), c(0,10), c(20,10), c(20,0))
midpoints<-rbind((room[1,]+room[2,])/2, (room[2,]+room[3,])/2, (room[3,]+room[4,])/2, (room[4,]+room[1,])/2 )
beaconsPositions<- rbind(room, midpoints)

calibration <- -44 # K+P_Tx, measured in dBm at 1 meter
plCoefficient <- 1.64 # theta, path loss coefficient
shadowing <- 6.82 # variation of Psi random attenuation due to shadowing, Gaussian variable 

### Assumption: reference distance for beacon is one meter
#
#Definition of functions
#
## distance and strentgh signal functions

euclideanDist <- function(x1, x2) {sqrt(sum((x1 - x2) ^ 2))}

signalStrength <- function (distance, calibration, shadowing, plCoefficient) {
        calibration - 10*plCoefficient*log10(distance) + rnorm(1,mean = 0, sd = sqrt(shadowing))
} 

## localization estimation functions

##....

# Definition of reactive things


# Define server logic required to generate and plot a random distribution
shinyServer(function(input, output) {
        
        # Avaliable beacons 
        
        beaconsAvaliable<-reactive({
                beaconsPositions[1:input$beaconsNumber,]
        }
                )
        
        # Splitting beaconsAvaliable to list to use it in distance computations later (for lapply - loops don't work well with reactives)
        
        beaconsAvaliableList<-reactive({
                split(beaconsAvaliable(), row(beaconsAvaliable()))
        })
        
        # Position of signal receiver
        
        position<-reactive({
                c(input$xPosition,input$yPosition)
        })
        
# plot position of receiver
        output$pointPosition <- renderPlot({
                plot(input$xPosition,input$yPosition,xlim= c(0, 20), ylim = c(0, 10), pch = 19, cex = 2 )
               points(beaconsAvaliable()[,1],beaconsAvaliable()[,2], pch = 10, cex = 2, col = "red" )
                })

# show beacons chosen

        output$chosen <- renderTable({
                beaconsAvaliable()
                })

# show list of beacons chosen

        output$chosenList <- renderPrint({
                beaconsAvaliableList()
                })

# compute distances from all avaliable beacons

beaconDistances<-reactive({lapply(beaconsAvaliableList(), function(x){euclideanDist(x,position())})})

output$distanceList <- renderPrint({
        beaconDistances()
        })

# compute one signal from each avaliable beacons

signalReceived<-reactive({lapply(beaconDistances(), function(x){signalStrength(x,calibration = calibration, shadowing = shadowing, plCoefficient = plCoefficient)
})})

output$signalList <- renderPrint({
        signalReceived()
})

})