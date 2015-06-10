library(shiny)
library(lubridate)
library(ggplot2)
library(plyr)
library(stringr)
library(dplyr)
# Adding client names 
clients= c("Reeds", "Toyota", "Zenni", "Verizon","Monster","Honeywell")

shinyUI(fluidPage(  
  # Application title
  titlePanel("Social Reporting"),
  #creating the sidebar Panel for the client name input
  sidebarPanel(
      selectInput("client","Select Client",clients),
    # sidebar panel for the date range input
      dateRangeInput("dates",label=h3("Enter the date range"),
                   min="2015-01-01",max="2015-12-31",start="2015-01-01",end="2015-05-1"),
    downloadButton(outputId = "report",label = "DownloadReport"),  
    downloadButton(outputId = "downloadplot",label = "Download Plot")

  ),
  
  #main Panel
  mainPanel(h2("Overall Report"),
            tableOutput('summ'),
            plotOutput("plot1")
  )
)
)

