library(shiny)
library(shinydashboard)
library(RCurl)
library(foreign)
library(DT)
library(ggvis)
library(plotrix)


# Define UI for application that draws a histogram
dashboardPage(skin = "black",      
              dashboardHeader(title= "2015-16 CCRS Data Over-View"), #Insert the Main Title
              
              dashboardSidebar(  
                sidebarMenu( 
                  menuItem("Number of Residents", tabName= "first"),
                  menuItem("Resident Profile", tabName= "second"),
                  menuItem("Age and Gender", tabName= "third")
                  #menuItem("Physical and Mental Multimorbidity",tabName="fourth")
                )),     
              dashboardBody(  
                tabItems(
                  tabItem(tabName= "first",
                          h3("The number of residents in continuing care facilities submitting to CCRS by province/territory"),        
                          HTML ('</br>'), 
                          #Inserting Drop-Down Menu
                            selectInput("yvar", "Choose a variable:", choices= c ("Total Assessed", "Total Discharged","Total Admitted"), selected = "Total Assessed"), 
                            ggvisOutput("plot1"),
                          #Table 1: Check Box,
                          checkboxGroupInput('show_vars', 'Columns to show in the table:',
                                             names(resident_data), selected = names(resident_data)),
                 
                  DT::dataTableOutput('mytable1')
                                      ),
                  tabItem(tabName="second",
                          tabsetPanel(
                            tabPanel("All Residents", #SUB TAB: ALL RESIDENTS
                          h3("Selected characteristics of residents in continuing care facilities"),        
                          HTML ('</br>'),                       
                          #Inserting Drop-Down Menu
                          selectInput("yvar2", "Choose a variable:", choices= c ("Number of Residents", "Average Age","Younger than 65 (%)", "Age 85 and Older (%)", "Female (%)"), selected = "Number of Residents"), 
                          ggvisOutput("plot2"),

                          #Table 2a: Check Box- ALL RESIDENTS 
                          checkboxGroupInput('show_vars_2a', 'Columns to show in the table:',
                                             names(All_Residents_profile_data), selected = names(All_Residents_profile_data)),
                          DT::dataTableOutput('mytable2a')
                          ),
                            tabPanel("Admitted Residents", #SUB TAB: ADMITTED RESIDENTS
                                     h3("Selected characteristics of residents in continuing care facilities"),        
                                     HTML ('</br>'),
                          #Inserting Drop-Down Menu
                           selectInput("yvar3", "Choose a variable:", choices= c ("Number of Admitted Residents", "Admitted Residents-Proportion of all Residents","Admitted from acute/other hospital (%)", "Admitted from residential care (%)")), 
                           ggvisOutput("plot3"),
                          #Table 2b: Check Box- ADMITTED RESIDENTS 
                          checkboxGroupInput('show_vars_2b', 'Columns to show in the table:',
                                             names(Admitted_Residents_profile_data), selected = names(Admitted_Residents_profile_data)),
                          DT::dataTableOutput('mytable2b')                         
                                     ),
                            tabPanel("Discharged Residents", #SUB TAB: DISCHARGED RESIDENTS
                                     h3("Selected characteristics of residents in continuing care facilities"),        
                                     HTML ('</br>'),                      
                                     #Inserting Drop-Down Menu
                                     selectInput("yvar4", "Choose a variable:", choices= c ("Number of Discharged Residents", "Discharged Residents-Proportion of all Residents","Died in facility (%)", "Discharged to acute/other hospital (%)", "Discharged home (%)", "Discharged to residential care (%)")), 
                                                 ggvisOutput("plot4"),
                                     #Table 2c: Check Box- DISCHARGED RESIDENTS 
                                     checkboxGroupInput('show_vars_2c', 'Columns to show in the table:',
                                                        names(Discharged_Residents_profile_data), selected = names(Discharged_Residents_profile_data)),
                                     DT::dataTableOutput('mytable2c') 
                                     ),
                            tabPanel("Assessed Residents", #SUB TAB: ASSESSED RESIDENTS
                                     h3("Selected characteristics of residents in continuing care facilities"),        
                                     HTML ('</br>'),                                     
                                     #Inserting Drop-Down Menu
                                     selectInput("yvar5", "Choose a variable:", 
                                                 choices= c (#"Full Table",
                                       "Number of Assessed Residents",
                                       "Diagnosis of Dementia (%)",
                                       "Diagnosis of Hypertension (%)",
                                       "Diagnosis of Cancer (%)",
                                       "Diagnosis of Diabetes (%)",
                                       "Total Dependence in ADLs (%)",
                                       "Severe Cognitive Impairment (%)",
                                       "Some Indication of Health Instability (%)",
                                       "Signs of Depression (%)",
                                       "Limited or no Social Engagement (%)",
                                       "Daily Pain(%)",
                                       "Some Aggressive Behaviour (%)",
                                       "Trigger 6 or more CAPs (%)",
                                       "Some bladder incontinence (%)",
                                       "Some bowel incontinence (%)")), 
                                     ggvisOutput("plot5"),
                                     #Table 2d: Check Box- ASSESSED RESIDENTS 
                                     checkboxGroupInput('show_vars_2d', 'Columns (max 14) to show in the table:',
                                                        names(Assessed_Residents_profile_data), selected = c("Province","Number of Assessed Residents", "Diagnosis of Dementia (%)", "Diagnosis of Hypertension (%)", "Diagnosis of Cancer (%)")), # this table is too big to have all columns displayed
                                     DT::dataTableOutput('mytable2d')                                      
                                     )
                                        )),
                          tabItem(tabName= "third",
                                  h3("Age and Gender of residents in continuing care facilities"),        
                                  HTML ('</br>')
                                  )                          
                  ))
  )      
