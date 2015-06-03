

library(shiny)
# Adding client names 
clients= c("Reeds", "Toyota", "Zenni", "Verizon","Monster","Honeywell")
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Social Reporting"),
  #creating the sidebar Panel for the client name input
  sidebarPanel(
    selectInput("client","Select Client",clients)),
  # sidebar panel for the date range input
  dateRangeInput("dates",label=h3("Enter the date range"),
                 min="2015-01-01",max="2015-12-31",start="2015-01-01",end="2015-12-31")
,

#main Panel
mainPanel(
  tabsetPanel(type="tab",
              tabPanel("Reports"),
              tabPanel("Plots"))
)
)
)

