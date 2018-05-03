library(shiny)
library(gmodels)
library(MASS)

#In the Server.R file, the computations and plots are produced 
#that are to be passed to the UI.R

NYC_Death <- read.csv("./Data/NYC_Death.csv")
x <- (NYC_Death$Count)


shinyServer(function(input, output) {

#Output for the Histogram and the if statements needed for the changing
#The density and number of bins in the Histogram
  
  output$hist_plot <- renderPlot({
    
    hist(NYC_Death$CODE, probability = TRUE, breaks = as.numeric(input$n_breaks),
         xlab = "Cause of Death", xlim = c(1,32), main = "Causes of Death for NYC", axes = TRUE, right = TRUE)
    
    if (input$in_obs) {
      rug(NYC_Death$CODE)
    }
    
    if (input$density) {
      denst <- density(NYC_Death$CODE, adjust = input$adjust)
      lines(denst, col = "blue")
    }
  })
  
#produces the output for the summary tab  
  
  output$summary <-renderPrint({
    summary(NYC_Death[,c(5,6)])
  })
  
  output$mean <-renderPrint({
    mean(x)
  })
  output$var <-renderPrint({
    var(x)
  })
  
#produces the three frequency tables displayed in the Tables tab
  
  output$table1 <- renderTable({
    
    CT1 <- with(NYC_Death, table(Ethnicity,Sex))
    prop.table(CT1)*100
    
  })
  
  output$table2 <- renderTable({
    CT2 <- with(NYC_Death,table(Ethnicity,Year))
    prop.table(CT2)*100
  })
  
  output$table3 <- renderTable({
    CT3 <- with(NYC_Death, table(Year, Sex))
    prop.table(CT3)*100
  })
  
#Adds the table displayed below the histogram to display the different Causes of Death
#That correspond to their respective codes
  
  output$table4 <- renderTable({
    NYC <- aggregate(CODE ~ Cause.of.Death, data = NYC_Death, FUN = mean)
  })
  
#The following outputs produce the 4 regression models summaries and Plots
  
  output$summary1 <- renderPrint({
    model1 <- glm.nb(NYC_Death$Count~NYC_Death$Ethnicity)
    summary(model1)
  })
  
  output$plot1 <- renderPlot({
    model1 <- glm.nb(NYC_Death$Count~NYC_Death$Ethnicity)
    layout(matrix(c(1,2,3,4),2,2))
    plot(model1)
  })
  
  output$summary2 <- renderPrint({
    model2 <- glm.nb(NYC_Death$Count~NYC_Death$Sex)
    summary(model2)
  })
  
  output$plot2 <- renderPlot({
    model2 <- glm.nb(NYC_Death$Count~NYC_Death$Sex)
    layout(matrix(c(1,2,3,4),2,2))
    plot(model2)
  })
  
  output$summary3 <- renderPrint({
    model3 <- glm.nb(NYC_Death$Count~NYC_Death$Ethnicity+NYC_Death$Sex)
    summary(model3)
  })
  
  output$plot3 <- renderPlot({
    model3 <- glm.nb(NYC_Death$Count~NYC_Death$Ethnicity+NYC_Death$Sex)
    layout(matrix(c(1,2,3,4),2,2))
    plot(model3)
  })
  
  output$ANOVA <- renderPrint({
    model1 <- glm.nb(NYC_Death$Count~NYC_Death$Ethnicity)
    model2 <- glm.nb(NYC_Death$Count~NYC_Death$Sex)
    model3 <- glm.nb(NYC_Death$Count~NYC_Death$Ethnicity+NYC_Death$Sex)
    anova(model1,model2,model3)
  })
})