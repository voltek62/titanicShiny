
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(randomForest)
library(C50)
library(dplyr)
set.seed(1)
train <- read.csv("train.csv", stringsAsFactors=FALSE)

extractFeatures <- function(data) {
  features <- c("Pclass",
                "Age",
                "Sex",
                "Parch",
                "SibSp",
                "Fare",
                "Embarked",
                "Survived")
  fea <- data[,features]
  fea$Age[is.na(fea$Age)] <- -1
  fea$Fare[is.na(fea$Fare)] <- median(fea$Fare, na.rm=TRUE)
  fea$Embarked[fea$Embarked==""] = "S"
  fea$Sex      <- as.factor(fea$Sex)
  fea$Embarked <- as.factor(fea$Embarked)
  return(fea)
}

getFeatures <- function(data) {
  features <- c("Pclass",
                "Age",
                "Sex",
                "Parch",
                "SibSp",
                "Fare",
                "Embarked")
  fea <- data[,features]
  return(fea)
}


shinyServer(function(input, output) {

  output$distPlot <- renderPlot({
    
    train2 <- extractFeatures(train)
    
    # Age
    train2 <- train2[train2$Age>(input$age[[1]]) & train2$Age<(input$age[[2]]),]
    
    # Fare
    train2 <- train2[train2$Fare>(input$fare[[1]]) & train2$Fare<(input$fare[[2]]),] 
    
    # Pclass
    if (input$pclass!="0") {
      train2 <- train2[train2$Pclass==input$pclass,]
    }

    # Sex
    if (input$sex!="0") {
      train2 <- train2[train2$Sex==input$sex,]
    }   
    
    #print(dim(train2))
    
    if (input$algo=="rf") {    
      
      if(dim(train2)[1]>10)
      {
        rf <- randomForest(getFeatures(train2), as.factor(train2$Survived), importance=TRUE)
        imp_rf <- importance(rf, type=1)
        featureImportance_rf <- data.frame(Feature=row.names(imp_rf), Importance=imp_rf[,1])
        
        ggplot(featureImportance_rf, aes(x=reorder(Feature, Importance), y=Importance)) +
          geom_bar(stat="identity", fill="#53cfff") +
          coord_flip() + 
          theme_light(base_size=20) +
          xlab("") +
          ylab("Importance") + 
          ggtitle("Random Forest - Feature Importance\n") +
          theme(plot.title=element_text(size=18))    
      }
    }
    else {
      
      if(dim(train2)[1]>30)
      {
        tm <- C5.0(x = getFeatures(train2), y = as.factor(train2$Survived),
                   control = C5.0Control(winnow = TRUE))
        
        featureImportance_tm <-C5imp(tm, metric = "usage", pct = FALSE)
        featureImportance_tm <- cbind(Feature = rownames(featureImportance_tm), featureImportance_tm)
        
        ggplot(featureImportance_tm, aes(x=reorder(Feature, Overall), y=Overall)) +
          geom_bar(stat="identity", fill="#53cccf") +
          coord_flip() + 
          theme_light(base_size=20) +
          xlab("") +
          ylab("Importance") + 
          ggtitle("C5.0 Classifier - Feature Importance\n") +
          theme(plot.title=element_text(size=18))      
      }     
      
      
    }


  })

})
