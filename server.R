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
  
  ## data cleaning is done 
  # making reactive selection of the data
  
  data2r=reactive({
    # Extracting date range from the user input
    a<-as.POSIXct(input$dates[1]) 
    b<-as.POSIXct(input$dates[2]) 
    
    df2<-data1 %>%
      filter(Date > a & Date < b)
    # selecting the first and the last from the selected data
    df2<-as.data.frame(t(df2[c(1,nrow(df2)),]))
    
    colnames(df2)= c("start_likes","end_likes")
    df2 = df2[-1,]
    # remove the NAs
    data3=na.omit(df2)
    # create new fields for city and state
    data3$state = str_sub(rownames(data3),-2)
    data3
    data3$city = str_extract(rownames(data3),"[aA-zZ]+.?[aA-zZ]+")
    data3$new_likes = as.integer(data3$end_likes) - as.integer(data3$start_likes)
    rownames(data3)= NULL
    data3=select(data3,state,city,as.integer(start_likes),as.integer(end_likes),as.integer(new_likes))%>%
      arrange(desc(new_likes))%>%
      top_n(10,new_likes)
    #ddply(data3,~state,summarize,Total.new.likes=sum(new_likes))
  })
  
  # display the output of the top 10
  output$summ<-renderTable({
    data2r()[1:10,]
    
  })
  
  
  
  # state summary
  data3r = reactive({ 
    
    ddply(data2r(),~city,summarize,Total.new.likes=sum(new_likes))%>%
      arrange(desc(Total.new.likes))
    # data4= arrange(data4,desc(Total.new.likes))
  })
  
    # display for the data
  output$summ2<-renderTable({
    data3r()
  })
  output$plot1=renderPlot({
    p1 = ggplot(data3r(),aes(x=city,y=Total.new.likes)) +
      geom_bar(stat="identity",fill = "lightblue") + coord_flip() + theme_bw()
    print(p1)
  })
  #   
  #   # city summary
  #   
  #   data5= ddply(data3,~city,summarize,Total.new.likes=sum(New_Likes))
  #   data5= arrange(data5,desc(Total.new.likes))
  #   data5
  #   
  #   #rendering
  #   
})
