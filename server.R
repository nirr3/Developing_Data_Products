
data("iris")
library(shiny)
library(caret)
library(rattle)
shinyServer(function(input,output){
  set.seed(12345)
  
  inTrain <- reactive({createDataPartition(iris$Species, p = input$Train_Test_Ratio, list =FALSE)
  })
  train.data <- reactive({data.frame(iris[inTrain(),])
  })
  test.data <- reactive({data.frame(iris[-inTrain(),])
  })
  
  fit.rpart <- reactive({
    train(
      as.formula(paste("Species~",paste(ifelse(input$Sepal_Length == TRUE, "+ Sepal.Length",""),
                                        ifelse(input$Sepal_Width == TRUE, "+ Sepal.Width",""),
                                        ifelse(input$Petal_Length == TRUE, "+ Petal.Length",""),
                                        ifelse(input$Petal_Width == TRUE, "+ Petal.Width",""), collapse = ""))), data=train.data(), method="rpart")
  })
  
  
  pred.rpart <- reactive({
    predict(fit.rpart(), newdata = test.data())
  })
  reactive
  output$plot1 <- renderPlot({
    fancyRpartPlot(fit.rpart()$final)
  })
  rpart.acc <- reactive({
    confusionMatrix(pred.rpart(),test.data()$Species)
  })
  
  output$pred1 <- renderPrint({rpart.acc()})
})
