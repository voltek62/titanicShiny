
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Titanic: Machine Learning from Disaster"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      
      withTags({
        div(class="header", checked=NA,
            
            p("Use Machine Learning to predict which passengers survived the tragedy."),
            
            p("Choose your algorithm and adjust in order to see the Importance on each features"),
            
            a(href="https://github.com/voltek62/titanicShiny/", "Source Code on GitHub"),
            
            p("")
      )}),
        

      selectInput("algo", "Machine Learning:",
                  c("Random Forest" = "rf",
                    "Classifier C5" = "tm"
                    )),   
      
      sliderInput("age", "Age:",
                  min = 1, max = 100, value = c(1,100)),
      
      selectInput("sex", "Sex:",
                  c("all" = "0",
                    "Male" = "male",
                    "Female" = "female"
                    )),       
      
      selectInput("pclass", "Passenger Class:",
                  c("all" = "0",
                    "1st" = "1",
                    "2nd" = "2",
                    "3rd" = "3")),
          
      sliderInput("fare", "Passenger Fare:",
                  min = 0, max = 512, value = c(0,512)) 
      
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
))
