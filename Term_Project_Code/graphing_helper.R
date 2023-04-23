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
library(panelr)
library(corrplot)

setwd("C:/Users/tompe/Dropbox/final_R/Term_Project_Code")

weekly_data <- read.csv("weekly_data_final.csv")
weekly_spot <- read.csv("aggregate_data_sorted.csv")
dates_spot <- read.csv("dates_spotify.csv")


# Modification to some data
weekly_data$rel_interest_youtube <- weekly_data$rel_interest_youtube/100
weekly_data$rel_interest_tiktok <- weekly_data$rel_interest_tiktok/100
weekly_data$lstreams <- log(weekly_data$streams)

weekly_data$week <- as.Date(weekly_data$week, format = "%m/%d/%Y")
weekly_data$year <- format(weekly_data$week, format = "%Y")

# weekly_spot$date <- rep(as.Date("1/1/2001", format = "%m/%d/%Y"), 3074)
# for(i in 1:3074){
#   for(j in 1:170){
#     if(weekly_spot[i, 1] == dates_spot[j, 2]){
#       weekly_spot[i, 4] <- as.Date(dates_spot[j, 1], format = "%m/%d/%Y")
#       next
#     }
#   }
# }
# 
# write.csv(weekly_spot, "aggregate_data_sorted.csv", row.names = FALSE)

weekly_spot$year <- format(weekly_spot$date, format = "%Y")

# weekly_data <- weekly_data[order(weekly_data$week_num),]

weekly_spot <- weekly_spot %>%
  rename(week_num=week)

# For comparison to Sim, Cho, Hwang, and Telang data
weekly_data_modified <- weekly_spot[weekly_spot$week_num <= 104,]
weekly_data_modified$treated_covid_limited <- ifelse((weekly_data_modified$year >= 2020 
                                                      & weekly_data_modified$year < 2021), 1, 0)
weekly_data_modified$after_start_limited <- ifelse(((weekly_data_modified$week_num >= 11 
                                                     & weekly_data_modified$week_num <= 52) 
                                                    | weekly_data_modified$week_num >= 63), 1, 0)



################################################################################

## Data Analysis and Regressions

# plot data on top of each other like in original paper - visual assist

weekly_data_graphing <- data.frame(week_num = rep(1:52,2), streams = rep(0, 104), year = rep(0, 104))
for(i in 1:104){
  sum_streams <- sum(weekly_data_modified[weekly_data_modified$week_num==i,]$streams)
  weekly_data_graphing[i, 2] <- sum_streams
  weekly_data_graphing[i, 3] <- ifelse(i > 52, 2020, 2019)
}
weekly_data_graphing$lstreams <- log(weekly_data_graphing$streams)

# write.csv(weekly_data_graphing, "weekly_data_spot_graphed.csv", row.names = FALSE)
# write.csv(weekly_data_modified, "aggregate_data_sorted.csv", row.names = FALSE)

weekly_data_graphing$year <- as.factor(weekly_data_graphing$year)
ggplot(weekly_data_graphing, aes(x=week_num, y=lstreams, group=year)) +
  geom_line(aes(color=year), size = 1) +
  geom_point(aes(color=year), size = 2) +
  geom_vline(xintercept = 11, size = 2) +
  ggtitle("2019 vs 2020 Log(Total Streams) vs Week Number in Year")


ggplot(weekly_data_graphing, aes(x=week_num, y=streams, group=year)) +
  geom_line(aes(color=year), size = 1) +
  geom_point(aes(color=year), size = 2) +
  geom_vline(xintercept = 11, size = 2) +
  ggtitle("2019 vs 2020 Log(Total Streams) vs Week Number in Year")









