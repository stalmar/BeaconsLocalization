library(shiny)
library(calibrate)
library(plyr)

# Definition of constatnt things
#
## environment and beacons definition

# room <-rbind(c(0,0), c(0,10), c(20,10), c(20,0))
# midpoints<-rbind((room[1,]+room[2,])/2, (room[2,]+room[3,])/2, (room[3,]+room[4,])/2, (room[4,]+room[1,])/2 )
# beaconsPositions<- rbind(room, midpoints)

room <-rbind(b1= c(0,0), b2 = c(0,10), b3 = c(20,10), b4 = c(20,0))
midpoints<-rbind(b5= (room[1,]+room[2,])/2, b6 = (room[2,]+room[3,])/2, b7 = (room[3,]+room[4,])/2, b8 = (room[4,]+room[1,])/2 )
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

distanceEstimation <- function(signal, calibration, plCoefficient) {
        10^((calibration - signal)/(10*plCoefficient))
}

# Definition of reactive things and server logic in general

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
        
        # compute distances from all avaliable beacons
        
        beaconDistances<-reactive({lapply(beaconsAvaliableList(), function(x){euclideanDist(x,position())})})
        
        # simulate one signal from each avaliable beacons
        
        signalReceived<-reactive({lapply(beaconDistances(), function(x){signalStrength(x,calibration = calibration, shadowing = shadowing, plCoefficient = plCoefficient)
        })})
        
        output$signalPlot <- renderPlot({
                barplot(as.numeric(signalReceived()), ylim = c(-70, 0), names.arg = row.names(beaconsAvaliable()), main = "Signals received from beacons (RSSI)")
        })
        
        # estimate distances from beacons given signal received (inverse to above)
        
        distancesEstimated<-reactive({lapply(signalReceived(), function(x){distanceEstimation(x,calibration = calibration, plCoefficient = plCoefficient)
        })})
        
        # Vectorize for easier min-max computations
        
        d<-reactive({as.numeric(distancesEstimated())})
        #dim(distancesVectorized())<-reactive({c()})
        
        b<-reactive({beaconsAvaliable()})
        
        # minMaxEstimations<-reactive({
        #         cbind(b(),b()[,1]- d(),b()[,1]+ d(),b()[,2]- d(),b()[,2]+ d())
        #                 })
        
        minMaxEstimatedReceiver<-reactive({0.5*c(max(b()[,1]- d())+min(b()[,1]+ d()),max(b()[,2]- d())+min(b()[,2]+ d()) )})
        
        output$receiver <- renderPrint({
                estimatedReceiver()
        })
        
        output$beaconsWithDistances <- renderTable({
                minMaxEstimations()
        })
        
        # estimate position of receiver with mini-max algorithm
        
        
# plot positions of receiver and estimated receiver

        output$pointPosition <- renderPlot({
                plot(input$xPosition,input$yPosition,xlim= c(0, 20), ylim = c(0, 10.5), pch = 19, cex = 2, xlab = "x dimension of the room", ylab = "y dimension of the room")
               points(beaconsAvaliable()[,1],beaconsAvaliable()[,2], pch = 22, cex = 2, col = "blue" )
               points(minMaxEstimatedReceiver()[1],minMaxEstimatedReceiver()[2], pch = 10, cex = 2, col = "red" )
               
               textxy(beaconsAvaliable()[,1],beaconsAvaliable()[,2], labs = row.names(beaconsAvaliable()), cex = 1, m = c(-1, 0)) 
               })
# plot names of beacons

output$names<-renderPrint({
        row.names(beaconsAvaliable())
        })


# show beacons chosen

        output$chosen <- renderTable({
                beaconsAvaliable()
                })

# show list of beacons chosen

        output$chosenList <- renderPrint({
                beaconsAvaliableList()
                })


})

