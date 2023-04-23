###################################################
# Advanced Data Analytics Final Project R Code
# Author: Thomas Petr
###################################################
rm(list = ls())   #clear memory

###################################################

library(plm)
library(lmtest)
library(sandwich)
library(car)
library(stargazer)
library(openxlsx)
library(tidyverse)
library(knitr)
library(lubridate)
library(tibble)
library(dplyr)

setwd("C:/Users/tompe/Dropbox/final_R/Term_Project_Code")

weekly_spot <- read.csv("aggregate_data_actual.csv")
weekly_video <- read.csv("video_media.csv")
dates_spot <- read.csv("dates_spotify.csv")

weekly_video <- weekly_video[(weekly_video$in_data==1),]
weekly_video <- weekly_video[, 1:4]

x <- rep(c(1:170), times = 6120/170)
weekly_video$week_num <- x

weekly_video <- weekly_video[, c(5,3,2,4,1)]

weekly_video_youtube <- weekly_video[(weekly_video$youtube==1),]
weekly_video_youtube <- weekly_video_youtube[, c(1,2,3,5)]
names(weekly_video_youtube)[names(weekly_video_youtube) == 'rel_interest'] <- 'rel_interest_youtube'
weekly_video_youtube <- weekly_video_youtube[, c(1,2,3)]


weekly_video_tiktok <- weekly_video[(weekly_video$youtube==0),]
weekly_video_tiktok <- weekly_video_tiktok[, c(1,2,3,5)]
names(weekly_video_tiktok)[names(weekly_video_tiktok) == 'rel_interest'] <- 'rel_interest_tiktok'

weekly_video <- merge(weekly_video_youtube, weekly_video_tiktok, by = c("week_num", "country"))


weekly_data <- merge(weekly_video, weekly_spot, by.x=c("week_num", "country"), by.y=c("week", "country"))


who_data <- read.csv("who_data.csv")
who_data <- who_data[(who_data$Country_code=='AR' | who_data$Country_code=='AU' | who_data$Country_code=='BR' | who_data$Country_code=='CL' | who_data$Country_code=='DE' | who_data$Country_code=='DK' | who_data$Country_code=='ES' | who_data$Country_code=='FR' | who_data$Country_code=='ID' | who_data$Country_code=='IE' | who_data$Country_code=='IT' | who_data$Country_code=='JP' | who_data$Country_code=='MX' | who_data$Country_code=='SE' | who_data$Country_code=='TH' | who_data$Country_code=='TR' | who_data$Country_code=='UK' | who_data$Country_code=='US'),]
dates_who <- read.csv("dates_who.csv")


# want both new_cases and new_deaths because later in the pandemic there are cases but fewer deaths (vaccine)
# organized_who <- data.frame(week=numeric(), country=character(), new_cases=numeric(), new_deaths=numeric())
# day = 1
# tot_days = 1
# sum_deaths = 0
# sum_cases = 0
# week = 52
# for(i in 1:15580){
#   # found = FALSE
#   # for(d in 1:820){
#   #   if(who_data[i, 1] == dates_who[d, 1]){
#   #     found = TRUE
#   #     break
#   #   }
#   # }
#   # if(!found){
#   #   #placeholder
#   #   organized_who[nrow(organized_who)+1,] <- c(week, NA, NA, NA)
#   #   # Skip if not found
#   #   next
#   # }
#   
#   sum_cases = sum_cases + who_data[i, 5]
#   sum_deaths = sum_deaths + who_data[i, 7]
#   curr_country = who_data[i, 2]
# 
#   tot_days = tot_days + 1
#   day = day + 1
# 
#   if(day == 8){
#     day = 1
#     # organized_who[i,1] <- week
#     # organized_who[i,2] <- curr_country
#     # organized_who[i,3] <- sum_cases
#     # organized_who[i,4] <- sum_deaths
# 
#     organized_who[nrow(organized_who)+1,] <- c(week, curr_country, sum_cases, sum_deaths)
#     
#     #resest for next week
#     sum_deaths=0
#     sum_cases=0
# 
#     week = week + 1
#     day = 1
#   }
# 
#   # reached the end of a country's data
#   if(tot_days == 821){
#     # week will be incomplete so remove/reset for next country
#     sum_cases = 0
#     sum_deaths = 0
#     tot_days = 1
#     day = 1
#     week = 52
#   }
# }
# 
# organized_who <- organized_who %>% drop_na()
# write.csv(organized_who, "organized_who.csv", row.names = FALSE)

# organized who data only goes up to week 168 = remove 169 and 170 in other data
organized_who <- read.csv("organized_who.csv")

weekly_data <- weekly_data[!(weekly_data$week_num == 170 | weekly_data$week_num == 169),]

# merge who data with all weekly data
weekly_data <- merge(weekly_data, organized_who, by.x=c("week_num", "country"), by.y=c("week", "country"))


write.csv(weekly_data, "weekly_data.csv", row.names = FALSE)

## Data is now formatted correctly after here









