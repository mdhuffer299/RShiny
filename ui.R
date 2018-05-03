#UI script for Indiana Weather Application

library(shiny)
library(leaflet)

vars <- c(
  "Average Maximum Precipitation",
  "Average Minimum Temp.",
  "Average Extreme Maximum Temp.",
  "Average Maximum Snow Depth",
  "Average Days with more than 1 in. of Snow",
  "Average Maximum Temp.",
  "Average Total Precipitation",
  "Average Extreme Minimum Temp."
)

shinyUI(navbarPage("Indiana Weather from 2004 to 2010", id = "wt",
                   
                   tabPanel("Map",
                            
                            leafletOutput("map", width = "100%", height = 600),
                            
                            absolutePanel(id = "controls", class = "panel panel-default", fixed = FALSE,
                                          draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                                          width = 350, height = "auto",
                                          
                                          h4("Weather data from 2004 to 2010"),
                                          selectInput("a", "Variable", choices = vars, selected = "EMXP"),
                                          
                                          plotOutput("hist", height = 200),
                                          plotOutput("scplot", height = 250)
                  )
            )
      )
  )
