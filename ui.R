### Enter the commentary to explain how the app works...



library(shiny)

# Define UI for application the develops scatter plot
shinyUI(fluidPage(
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

