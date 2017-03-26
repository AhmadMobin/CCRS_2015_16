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

#Population Pyramid Data
#pop_pyramid<- read.csv("C:\\Users\\amobin\\Dropbox\\CIHI\\CCRS_2015\\Population_Pyramid.csv")
pop_pyramid<-read.csv (text=getURL("https://raw.githubusercontent.com/AhmadMobin/CCRS_2015_16/master/Population_Pyramid.csv"),header = TRUE, stringsAsFactors = FALSE, fileEncoding = "UTF-8")
#removing the two bottom rows
pop_pyramid<-pop_pyramid[c(-6,-7),]
agelabels<- c("0-64", "65-74", "75-84", "85-94", "95+") #Age Labels for pyramid
#Setting colours for population pyramid
mcol<-("blue")
fcol<-("red")

#Changing columns from factor to numeric
pop_pyramid$MN_M_Percentage<-as.numeric(as.character(pop_pyramid$MN_M_Percentage))#MALE-MANITOBA
pop_pyramid$MN_F_Percentage<-as.numeric(as.character(pop_pyramid$MN_F_Percentage))#FEMALE-MANTIOBA
pop_pyramid$SASK_M_Percentage<-as.numeric(as.character(pop_pyramid$SASK_M_Percentage))#MALE-SASKATCHEWAN
pop_pyramid$SASK_F_Percentage<-as.numeric(as.character(pop_pyramid$SASK_F_Percentage))#FEMALE-SASKATCHEWAN
pop_pyramid$AB_M_Percentage<-as.numeric(as.character(pop_pyramid$AB_M_Percentage))#MALE-ALBERTA
pop_pyramid$AB_F_Percentage<-as.numeric(as.character(pop_pyramid$AB_F_Percentage))#FEMALE-ALBERTA
