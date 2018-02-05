#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(RCurl)
library(RJSONIO)
library(plyr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    
    url <- function(address, return.call = "json", sensor = "false") {
        root <- "http://maps.google.com/maps/api/geocode/"
        u <- paste(root, return.call, "?address=", address, "&sensor=", sensor, sep = "")
        return(URLencode(u))
    }
    
    
    geoCode <- function(address,verbose=FALSE) {
        if(verbose) cat(address,"\n")
        u <- url(address)
        doc <- getURL(u)
        x <- fromJSON(doc,simplify = FALSE)
        if(x$status=="OK") {
            lat <- x$results[[1]]$geometry$location$lat
            lng <- x$results[[1]]$geometry$location$lng
            location_type <- x$results[[1]]$geometry$location_type
            formatted_address <- x$results[[1]]$formatted_address
            return(c(lat, lng, location_type, formatted_address, u))
        } else {
            return(c(NA,NA,NA, NA))
        }
    }
    
    
    myResult <- function() {
        return(geoCode(input$text1))
    }
    
    output$mymap <- renderLeaflet({
        leaflet() %>% addTiles() %>% addMarkers(lat = as.numeric(myResult()[[1]]), lng = as.numeric(myResult()[[2]]), popup = "Starting point")
    })

    output$mymap2 <- renderLeaflet({
        if(myResult()[[2]] > 0){
            leaflet() %>% addTiles() %>% addMarkers(lat = -as.numeric(myResult()[[1]]), lng = as.numeric(myResult()[[2]]) - 180, popup = "Opposite side of the earth")
        } else {
            leaflet() %>% addTiles() %>% addMarkers(lat = -as.numeric(myResult()[[1]]), lng = as.numeric(myResult()[[2]]) + 180, popup = "Opposite side of the earth")
        }
    })
    
    output$long <- renderText({
        paste("longitude = ", myResult()[[2]])
    })
    
    output$lat <- renderText({
        paste("latitude = ", myResult()[[1]])
    })
    
    output$long2 <- renderText({
        if(myResult()[[2]] > 0){
            paste("longitude = ", as.numeric(myResult()[[2]]) - 180)
        } else {
            paste("longitude = ", as.numeric(myResult()[[2]]) + 180)
        }
    })
    
    output$lat2 <- renderText({
        paste("latitude = ", -as.numeric(myResult()[[1]]))
    })
    
})
