## Interactive Learning Classroom Application
## Michael Huffer

library(shiny)
library(DT)

source("global.R")

shinyApp(
  ui = fluidPage(
    fluidRow(
      column(2,offset=.5,
             selectInput("course", h4("Course"),courses,width = 100)),
      column(2,
             selectInput("RM_NUM", h4("Room"),classes,width = 100)),
      column(2,
             selectInput("Semester", h4("Semester"),c("Fall 2015","Spring 2016","Fall 2016","Spring 2017")
                         ,width = 120)),
      column(2,
             textInput("date",h4("Date"), value ="",width = 100))),
    
    fluidRow(column(width = 4,
                    radioButtons("studentID_DU1", h3("Student 1"), 
                                 choice1,selected = NULL)),
             
             column(width = 4,
                    radioButtons("studentID_DU2", h3("Student 2"),
                                 choice2,selected = NULL))),
    br(),
    fluidRow(column(width = 4,
                    actionButton("submit1", "Submit 1")),
             column(width = 4,
                    actionButton("submit2", "Submit 2")),
             column(width = 4,
                    actionButton("combine", "Combine")))
  ),
  server = function(input, output, session){
    
    
    #Whenever a field is filled, aggregate all form data
    
    formData1 <-reactive({
      data1 <- sapply(fields1, function(x) input[[x]])
      data1 <- c(data1, time = humanTime())
      data1
    })
    
    #When submit button is clicked, save the data
    observeEvent(input$submit1, {
      saveData1(formData1())
    })
    
    # Show the previous responses and update when submit is clicked
    output$response1 <- DT::renderDataTable({
      input$submit1
      loadData1()
    })
    
    formData2 <-reactive({
      data2 <- sapply(fields2, function(x) input[[x]])
      data2 <- c(data2, time = humanTime())
      data2
    })
    
    #When submit button is clicked, save the data
    observeEvent(input$submit2, {
      saveData2(formData2())
    })
    
    # Show the previous responses and update when submit is clicked
    output$response2 <- DT::renderDataTable({
      input$submit2
      loadData2()
    })
    
    
    #Combine the two tables
    formData <-reactive({
      data <- rbind(response1,response2)
    })
    
    #When submit button is clicked, save the data
    observeEvent(input$combine, {
      saveData(formData())
    })
    
    # Show the previous responses and update when submit is clicked
    output$response <- DT::renderDataTable({
      input$combine
      loadData()
    })
  }
)
