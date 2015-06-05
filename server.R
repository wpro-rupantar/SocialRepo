#server file
library(shiny)
library(lubridate)
library(ggplot2)
library(plyr)
library(stringr)
library(dplyr)

# initializing the server
shinyServer(function(input,output){
  ### loading and cleaning the location and likes data
  data1<-read.csv("/Users/rupantarrana/Project/social.reporting/Rshiny/data/wpro2015.csv")
  
  # parsing the date for the data
  data1$Date<-mdy(data1$Date)
  
  # removing the first column that has no data
  data1=data1[,-1]
  
  #removing the last two rows that has no data
  n=nrow(data1)
  data1=data1[-c(n-1,n),]
  
  data2r=reactive({
    # Extracting date range from the user input
    a<-as.POSIXct(input$dates[1]) 
    b<-as.POSIXct(input$dates[2]) 
    df2= data1 %>%
      filter(Date > a & Date < b)
    df2
  })
  
  output$summ<-renderTable({
    datar<-as.data.frame(data2r())
    datar
  })
    
    
  data3=as.data.frame(t(data2[-1]))
  colnames(data3)=c("start_likes","end_likes")
  data3$New_Likes = data3$end_likes-data3$start_likes
  # remove the NAs
  data3=na.omit(data3)
  
  # create new fields for city and state
  data3$state = str_sub(rownames(data3),-2)
  data3$city = str_extract(rownames(data3),"[aA-zZ]+.?[aA-zZ]+")
  # state summary
  data4= ddply(data3,~state,summarize,Total.new.likes=sum(New_Likes))
  data4= arrange(data4,desc(Total.new.likes))
  data4
  
  # city summary
  
  data5= ddply(data3,~city,summarize,Total.new.likes=sum(New_Likes))
  data5= arrange(data5,desc(Total.new.likes))
  data5
  
  #rendering
  
})
