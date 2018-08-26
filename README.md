---
title: "Developing Data Products Week 4 Assignment"
author: "Nicklas Ankarstad"
date: "August 26, 2018"
output:
  ioslides_presentation:
    keep_md: yes
    widescreen: yes
runtime: shiny
resource_files:
- ui.R
- server.R
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = FALSE)
```

## Overview 

As data scientists, we often have to make decisions on how much of our data we should include in our training data set versus our testing data set. We also look at many different variables that help improve the accuracy of our final model. This Shiny app provides a dynamic way to help address these items by allowing users to: 

- Explore the size of the training and testing data splitting
- Include or exclude  variables in the training of the decision tree model
- Evaluate the impact on decision tree formation and model performance

## Slide With Code

The shiny app uses the iris data set which is comprised of four varibales we can use to predict the species of the flower. The data set contains three different species:

```{r}
summary(iris$Species)
```

```{r load_packages, echo=FALSE,include=FALSE}
data("iris")
library(shiny)
library(caret)
library(rattle)
library(e1071)
```

## Shiny App

```{r iris, echo = FALSE}

shinyApp(ui= (fluidPage(
  titlePanel("Classify Flowers Species"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("Train_Test_Ratio", "What percentage of the data should be included in training set?",.10,.90, value =.75),
      checkboxInput("Sepal_Length","Include Sepal Length in Model", value = TRUE),
      checkboxInput("Sepal_Width","Include Sepal Width in Model", value = TRUE),
      checkboxInput("Petal_Length","Include Petal Length in Model", value = TRUE),
      checkboxInput("Petal_Width","Include Petal Width in Model", value = TRUE)
    ),
    mainPanel(
      plotOutput("plot1"),
      h3("Confusion Matrix for the Model"),
      verbatimTextOutput("pred1")
    )
  )
)) 
,server =(function(input,output){
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
}))
```

## Conclusion

The Shiny app illustrates the impacts and importance of splitting the data correctly and selecting the right variables. This further illustrates the importance of hiring good data scientists.

