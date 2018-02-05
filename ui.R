#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(RCurl)
 

shinyUI(fluidPage(
    
    titlePanel("Drill Through the Earth!"),
    
    sidebarLayout(
        sidebarPanel(
            textInput("text1", "Enter an address, click 'Submit' and this app will locate and display the position on the exact opposite side of the Earth", "City Hall Santiago Chile"),
            submitButton("Submit"),
            HTML("<br><b>Here are the geocoordinates of the location entered:</b>"),
            textOutput("long"),
            textOutput("lat"),            
            HTML("<br><b>Drill through the Earth and you'll arrive at:</b>"),
            textOutput("long2"),
            textOutput("lat2"),
            HTML("<br><b>*Note - if the second map is entirely blue you've landed in water.  Zoom out (click the minus on the map) to see where.</b>")
        ),
        
        mainPanel(
            HTML("<h4>Start drilling here:</h4>"),
            leafletOutput("mymap"),
            HTML("<h4>You'll come out here:</h4>"),
            leafletOutput("mymap2")
        )
    )
))
