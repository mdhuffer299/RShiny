#Server script for Indiana Weather Application

library(shiny)
library(leaflet)
library(maps)
library(lattice)

IN_W <- read.csv("./Data/IN_WT.csv")
IN_W_S <- subset(IN_W, select = c("STATION_NAME","ELEVATION","LATITUDE","LONGITUDE","DATE","EMXP","MMNT","EMXT","MXSD","DSNW","MMXT","TPCP","EMNT","MNTM","TSNW"))
IN_W_S$EMXP <- IN_W_S$EMXP/10
IN_W_S$MMNT <- IN_W_S$MMNT/10
IN_W_S$TPCP <- IN_W_S$TPCP/10
IN_W_S$TSNW <- IN_W_S$TSNW
IN_W_S$MMXT <- IN_W_S$MMXT/10
IN_W_S$MNTM <- IN_W_S$MNTM
names(IN_W_S) <- c("StationName","Elevation","Lat","Lon","Date","EMXP","MMNT","EMXT","MXSD","DSNW","MMXT","TPCP","EMNT","MNTM","TSNW")
WT <- aggregate(.~`StationName`, data= IN_W_S, mean)

WT$`StationName` <- as.character(WT$`StationName`)
WT[,c(2:15)] <- round(WT[,c(2:15)],2)


shinyServer(function(input, output, session) {

  dataSubset <- reactive({
    switch(input$a,   "Average Maximum Precipitation" = WT$EMXP,
           "Average Minimum Temp." = WT$MMNT,
           "Average Extreme Maximum Temp." = WT$EMXT,
           "Average Maximum Snow Depth" = WT$MXSD,
           "Average Days with more than 1 in. of Snow" = WT$DSNW,
           "Average Maximum Temp." = WT$MMXT,
           "Average Total Precipitation" = WT$TPCP,
           "Average Extreme Minimum Temp." = WT$EMNT)
  })
  
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("Thunderforest.Landscape") %>%
      setView(lng = -84 , lat = 40, zoom = 7)
  })
  
  
  output$hist <- renderPlot({
    hist(dataSubset(), xlab = input$a, main = "Histogram of the weather variable selected", col= c("red","green","blue","yellow"))
  })
  
  output$scplot <- renderPlot({
    print(xyplot(dataSubset() ~ Elevation, data = WT, xlab = NULL, ylab = input$a))
  })
  
  observe({
    leafletProxy("map", data = WT) %>%
      clearShapes() %>%
      addCircles(~Lon, ~Lat, radius = 100*(dataSubset()), color = "blue", layerId = ~StationName, weight = 10,
                 fillColor = "blue", fillOpacity = 0.7, opacity = 0.7)
    
  })
  
  showStationPopup <- function(StationName, lat, lng){
    selectedStation <- WT[WT$StationName == StationName,]
    content <- as.character(tagList(
      tags$h4("Station Name:", as.character(selectedStation$StationName)),
      sprintf("Average Maximum Precipitation: %s", selectedStation$EMXP),
      tags$br(),
      sprintf("Average Minimum Temp.: %s", selectedStation$MMNT),
      tags$br(),
      sprintf("Average Extreme Maximum Temp.: %s", selectedStation$EMXT),
      tags$br(),
      sprintf("Average Maximum Snow Depth: %s", selectedStation$MXSD),
      tags$br(),
      sprintf("Average Days with > 1 in. snow: %s", selectedStation$DSNW),
      tags$br(),
      sprintf("Average Maximum Temperature: %s", selectedStation$MMXT),
      tags$br(),
      sprintf("Average Total Precipitation: %s", selectedStation$TPCP),
      tags$br(),
      sprintf("Average Extreme Minimum Temperature: %s", selectedStation$EMNT)
    ))
    leafletProxy("map") %>% addPopups(lng, lat, content, layerId = StationName)
  }

  observe({
    leafletProxy("map") %>% clearPopups()
    event <- input$map_shape_click
    if(is.null(event))
      return()
    
    isolate({
      showStationPopup(event$id, event$lat, event$lng)
    })
  })
  
})
