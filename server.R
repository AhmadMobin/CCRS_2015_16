library(shiny)
library(shinydashboard)
library(RCurl)
library(foreign)
library(DT)
library(ggvis)
library(plotrix)

#load data sets:

#First Tab Data
#resident_data<- read.csv("C:\\Users\\AMobin\\Desktop\\CCRS_2015.csv") 
resident_data<- read.csv(text=getURL("https://raw.githubusercontent.com/AhmadMobin/CCRS_2015_16/master/CCRS_2015.csv"),header = TRUE, stringsAsFactors = FALSE, fileEncoding = "UTF-8")

#Second Tab Data
#ALL RESIDENTS
#All_Residents_profile_data<- read.csv("C:\\Users\\AMobin\\Desktop\\Profile_All_Residents.csv") #Second Tab Data
All_Residents_profile_data<- read.csv(text=getURL("https://raw.githubusercontent.com/AhmadMobin/CCRS_2015_16/master/Profile_All_Residents.csv"),header = TRUE, stringsAsFactors = FALSE, fileEncoding = "UTF-8")

#ADMITTED RESIDENTS
#Admitted_Residents_profile_data<-read.csv("C:\\Users\\AMobin\\Desktop\\Profile_Admitted_Residents.csv") #Second Tab Data
Admitted_Residents_profile_data<- read.csv(text=getURL("https://raw.githubusercontent.com/AhmadMobin/CCRS_2015_16/master/Profile_Admitted_Residents.csv"),header = TRUE, stringsAsFactors = FALSE, fileEncoding = "UTF-8")

#DISCHARGED RESIDENTS
#Discharged_Residents_profile_data<-read.csv("C:\\Users\\AMobin\\Desktop\\Profile_Discharge_Residents.csv") #Second Tab Data
Discharged_Residents_profile_data<-read.csv (text=getURL("https://raw.githubusercontent.com/AhmadMobin/CCRS_2015_16/master/Profile_Discharge_Residents.csv"),header = TRUE, stringsAsFactors = FALSE, fileEncoding = "UTF-8")

#ASSESSED RESIDENTS
#Assessed_Residents_profile_data<-read.csv("C:\\Users\\AMobin\\Desktop\\Profile_Assessed_Residents.csv") #Second Tab Data
Assessed_Residents_profile_data<-read.csv (text=getURL("https://raw.githubusercontent.com/AhmadMobin/CCRS_2015_16/master/Profile_Assessed_Residents.csv"),header = TRUE, stringsAsFactors = FALSE, fileEncoding = "UTF-8")


#RENAMING COLUMNS

#RESIDENT DATA-1ST TAB
names (resident_data) [2]<-"Total Assessed"
names (resident_data) [3]<-"Total Discharged"
names (resident_data) [4]<-"Total Admitted"


#ALL RESIDENTS-2ND TAB
names (All_Residents_profile_data) [2]<-"Number of Residents"
names (All_Residents_profile_data) [3]<-"Average Age"
names (All_Residents_profile_data) [4]<-"Younger than 65 (%)"
names (All_Residents_profile_data) [5]<-"Age 85 and Older (%)"
names (All_Residents_profile_data) [6]<-"Female (%)"
#Admitted Residents-2ND TAB
names (Admitted_Residents_profile_data) [2]<-"Number of Admitted Residents"
names (Admitted_Residents_profile_data) [3]<-"Admitted Residents-Proportion of all Residents"
names (Admitted_Residents_profile_data) [4]<-"Admitted from acute/other hospital (%)"
names (Admitted_Residents_profile_data) [5]<-"Admitted from residential care (%)"
#Dicharged Residents-2ND TAB
names (Discharged_Residents_profile_data) [2]<-"Number of Discharged Residents"
names (Discharged_Residents_profile_data) [3]<-"Discharged Residents-Proportion of all Residents"
names (Discharged_Residents_profile_data) [4]<-"Died in facility (%)"
names (Discharged_Residents_profile_data) [5]<-"Discharged to acute/other hospital (%)"
names (Discharged_Residents_profile_data) [6]<-"Discharged home (%)"
names (Discharged_Residents_profile_data) [7]<-"Discharged to residential care (%)"
#Assessed Residents-2ND TAB
names (Assessed_Residents_profile_data) [2]<-"Number of Assessed Residents"
names (Assessed_Residents_profile_data) [3]<-"Diagnosis of Dementia (%)"
names (Assessed_Residents_profile_data) [4]<-"Diagnosis of Hypertension (%)"
names (Assessed_Residents_profile_data) [5]<-"Diagnosis of Cancer (%)"
names (Assessed_Residents_profile_data) [6]<-"Diagnosis of Diabetes (%)"
names (Assessed_Residents_profile_data) [7]<-"Total Dependence in ADLs (%)"
names (Assessed_Residents_profile_data) [8]<-"Severe Cognitive Impairment (%)"
names (Assessed_Residents_profile_data) [9]<-"Some Indication of Health Instability (%)"
names (Assessed_Residents_profile_data) [10]<-"Signs of Depression (%)"
names (Assessed_Residents_profile_data) [11]<-"Limited or no Social Engagement (%)"
names (Assessed_Residents_profile_data) [12]<-"Daily Pain(%)"
names (Assessed_Residents_profile_data) [13]<-"Some Aggressive Behaviour (%)"
names (Assessed_Residents_profile_data) [14]<-"Trigger 6 or more CAPs (%)"
names (Assessed_Residents_profile_data) [15]<-"Some bladder incontinence (%)"
names (Assessed_Residents_profile_data) [16]<-"Some bowel incontinence (%)"



# Define server logic 
shinyServer(function(input, output) {  
  
######################FIRST TAB######################  
#GRAPH:
  res <- reactive({
    # Lables for axes
    #yvar_name <- names(res_data)[axis_vars == input$yvar]
    
    # Normally we could do something like props(x = ~BoxOffice, y = ~Reviews),
    # but since the inputs are strings, we need to do a little more work.
    yvar <- prop("y", as.symbol(input$yvar))
    
    
    resident_data %>%
      ggvis(x = ~Province, y = yvar, fill=~Province, 
            stroke.hover := "blue", strokeWidth := 3) %>% 
      layer_bars() %>%
      #manaully inserting my own colours of choice  
      scale_nominal("fill", range= c("red", "yellow", "green")) %>% 
      add_axis("y", title_offset = 50, subdivide=2) %>%
      set_options(width = 700, height = 500)
  })
  
  res %>% bind_shiny("plot1") 
  
  #First Tab Table:
  output$mytable1 <- DT::renderDataTable({
    DT::datatable(options = list(paging = FALSE, searching= FALSE, 
                                   autoWidth = TRUE,
                                   columnDefs = list(list(width = '500px', targets = "_all"))),
      resident_data[,input$show_vars, drop = FALSE]
                  )  
  }) 
  
  

  
  ######################SECOND TAB: ALL RESIDENTS######################    
  #GRAPH:
  profile <- reactive({
    # Lables for axes
    #yvar_name <- names(profile_data)[axis_vars_2 == input$yvar2]
    
    # Normally we could do something like props(x = ~BoxOffice, y = ~Reviews),
    # but since the inputs are strings, we need to do a little more work.
    yvar2 <- prop("y", as.symbol(input$yvar2))
    
    
    All_Residents_profile_data %>%
      ggvis(x = ~Province, y = yvar2, fill=~Province, 
            stroke.hover := "blue", strokeWidth := 3) %>% 
      layer_bars() %>%
      #manaully inserting my own colours of choice  
      scale_nominal("fill", range= c("red", "yellow", "green")) %>% 
      add_axis("y", title_offset = 50, subdivide=2) %>%
      set_options(width = 700, height = 500)
  })
  
  profile %>% bind_shiny("plot2")     
 
  #Table- ALL RESIDENTS:
  
  #Reactive function for the table 
  output$mytable2a <- DT::renderDataTable({
    DT::datatable(options = list(paging = FALSE, searching= FALSE, 
                                 autoWidth = TRUE,
                                 columnDefs = list(list(width = '500px', targets = "_all"))),
                 All_Residents_profile_data[, input$show_vars_2a, drop = FALSE]
    )  
  })   

  ######################SECOND TAB_Admitted Residents######################    
  #GRAPH:
  profile_2 <- reactive({
    # Lables for axes
    #yvar_name <- names(profile_data)[axis_vars_2 == input$yvar2]
    
    # Normally we could do something like props(x = ~BoxOffice, y = ~Reviews),
    # but since the inputs are strings, we need to do a little more work.
    yvar3 <- prop("y", as.symbol(input$yvar3))
    
    
    Admitted_Residents_profile_data %>%
      ggvis(x = ~Province, y = yvar3, fill=~Province, 
            stroke.hover := "blue", strokeWidth := 3) %>% 
      layer_bars() %>%
      #manaully inserting my own colours of choice  
      scale_nominal("fill", range= c("red", "yellow", "green")) %>% 
      add_axis("y", title_offset = 50, subdivide=2) %>%
      set_options(width = 700, height = 500)
  })
  
  profile_2 %>% bind_shiny("plot3")    
  #Table- ADMITTED RESIDENTS:
  
  #Reactive function for the table 
  output$mytable2b <- DT::renderDataTable({
    DT::datatable(options = list(paging = FALSE, searching= FALSE, 
                                 autoWidth = TRUE,
                                 columnDefs = list(list(width = '500px', targets = "_all"))),
                  Admitted_Residents_profile_data[, input$show_vars_2b, drop = FALSE]
    )  
  })    
######################SECOND TAB_Discharged Residents######################   
  #GRAPH:
  profile_3 <- reactive({
    # Lables for axes
    #yvar_name <- names(profile_data)[axis_vars_2 == input$yvar2]
    
    # Normally we could do something like props(x = ~BoxOffice, y = ~Reviews),
    # but since the inputs are strings, we need to do a little more work.
    yvar4 <- prop("y", as.symbol(input$yvar4))
    
    
    Discharged_Residents_profile_data %>%
      ggvis(x = ~Province, y = yvar4, fill=~Province, 
            stroke.hover := "blue", strokeWidth := 3) %>% 
      layer_bars() %>%
      #manaully inserting my own colours of choice  
      scale_nominal("fill", range= c("red", "yellow", "green")) %>% 
      add_axis("y", title_offset = 50, subdivide=2) %>%
      set_options(width = 700, height = 500)
  })
  
  profile_3 %>% bind_shiny("plot4")    
  #TABLE
  #Table- DISCHARGED RESIDENTS:
  
  #Reactive function for the table 
  output$mytable2c <- DT::renderDataTable({
    DT::datatable(options = list(paging = FALSE, searching= FALSE, 
                                 autoWidth = TRUE, 
                                 columnDefs = list(list(width = '500px', targets = "_all"))),
                  Discharged_Residents_profile_data[, input$show_vars_2c, drop = FALSE]
    )      
  })      

  ######################SECOND TAB_ASSESSED Residents######################   
  #GRAPH:
  profile_4 <- reactive({
    # Lables for axes
    #yvar_name <- names(profile_data)[axis_vars_2 == input$yvar2]
    
    # Normally we could do something like props(x = ~BoxOffice, y = ~Reviews),
    # but since the inputs are strings, we need to do a little more work.
    yvar5 <- prop("y", as.symbol(input$yvar5))
    
    
    Assessed_Residents_profile_data %>%
      ggvis(x = ~Province, y = yvar5, fill=~Province, 
            stroke.hover := "blue", strokeWidth := 3) %>% 
      layer_bars() %>%
      #manaully inserting my own colours of choice  
      scale_nominal("fill", range= c("red", "yellow", "green")) %>% 
      add_axis("y", title_offset = 50, subdivide=2) %>%
      set_options(width = 700, height = 500)
  })
  
  profile_4 %>% bind_shiny("plot5") 

  #TABLE
  #Table- ASSESSED RESIDENTS:
  
  #Reactive function for the table 
  output$mytable2d <- DT::renderDataTable({
    DT::datatable(options = list(paging = FALSE, searching= FALSE, 
                                 autoWidth = TRUE, 
                                 columnDefs = list(list(width = '500px', targets = "_all"))),
                  Assessed_Residents_profile_data[, input$show_vars_2d, drop = FALSE]
    )            
  })         
        
})     

