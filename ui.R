

library(shiny)
# Adding client names 
clients= c("Reeds", "Toyota", "Zenni", "Verizon","Monster","Honeywell")
shinyUI(fluidPage(

  # Application title
  titlePanel("Social Reporting"),
  #creating the sidebar Panel for the client name input
  sidebarPanel(
    selectInput("client","Select Client",clients))
    
)
)
  
