library(shiny)
library(shinythemes)

#UI layout that is displayed when NYC app is ran
shinyUI(fluidPage(theme = shinytheme("readable"),
  titlePanel("New York City Causes of Death"),
    mainPanel(
#Creating multiple tabs for the different outputs produced
      tabsetPanel(type = "tabs",
                  tabPanel("Plot", 
                           
 #Different reactive Inputs for the histogram displayed
 #Changes the number of bins viewed in the histogram
 #Adds the individual observations and if the Density is shown on the histogram
 
                           selectInput(inputId = "n_breaks", label = "Number of bins in Histogram:",
                                       choices = c(8, 16, 24, 32),
                                       selected = 32),
                           
                           checkboxInput(inputId = "in_obs", label = strong("Show Individual Observations"),
                                         value = FALSE),
                           
                           checkboxInput(inputId = "density", label = strong("Show Density Estimation"),
                                         value = FALSE),
 
                           conditionalPanel(condition ="input.density == true",
                                            sliderInput(inputId = "adjust", label = "Bandwidth Adjustment:",
                                                        min = 0, max = 2, value = .8, step = 0.2)),
                           plotOutput(outputId = "hist_plot", height = "300px"),
                           tableOutput("table4")
                           ),

 
 #Produces the Frequency tables for the different Variables in this Dataset
 #Also adds a title for each individual table produced
 
                  tabPanel("Freq. Table of Sex, Ethnicity, and Year", 
                           tags$p("Ethnicity and Sex"),tableOutput("table1"),
                           tags$p("Ethnicity and Year"),tableOutput("table2"),
                           tags$p("Year and Sex"),tableOutput("table3")),
 
                  tabPanel("Summary", verbatimTextOutput("summary"),tags$p("Mean of Count"),
                           verbatimTextOutput("mean"),tags$p("Variance of Count"),
                           verbatimTextOutput("var")),
 
 #Creates more Tabs that show the output for the different regression models
 
                  tabPanel("Regression Model", verbatimTextOutput("summary1"), plotOutput("plot1")),
                  tabPanel("Regression Model", verbatimTextOutput("summary2"), plotOutput("plot2")),
                  tabPanel("Regression Model", verbatimTextOutput("summary3"), plotOutput("plot3")),
                  tabPanel("ANOVA Output", verbatimTextOutput("ANOVA"))
                  
        )
      )
    )
  )