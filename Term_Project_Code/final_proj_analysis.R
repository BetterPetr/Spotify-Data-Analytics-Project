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

weekly_spot_graphed <- read.csv("weekly_data_spot_graphed.csv")
weekly_spot <- read.csv("aggregate_data_sorted.csv")

# Modification to some data
weekly_data$rel_interest_youtube <- weekly_data$rel_interest_youtube/100
weekly_data$rel_interest_tiktok <- weekly_data$rel_interest_tiktok/100
weekly_data$lstreams <- log(weekly_data$streams)


weekly_data$week <- as.Date(weekly_data$week, format = "%m/%d/%Y")
weekly_data$year <- format(weekly_data$week, format = "%Y")

weekly_orig <- weekly_data

# For comparison to Sim, Cho, Hwang, and Telang data
weekly_data_modified <- weekly_data[weekly_data$week_num <= 104,]
weekly_data_modified$treated_covid_limited <- ifelse((weekly_data_modified$year >= 2020 
                                                      & weekly_data_modified$year < 2021), 1, 0)
weekly_data_modified$after_start_limited <- ifelse(((weekly_data_modified$week_num >= 11 
                                                    & weekly_data_modified$week_num <= 52) 
                                                   | weekly_data_modified$week_num >= 63), 1, 0)

weekly_data_modified <- weekly_data_modified[order(weekly_data_modified$week_num),]
weekly_data_modified <- subset(weekly_data_modified, select = -c(streams, lstreams))
weekly_spot <- weekly_spot[order(weekly_spot$week_num, weekly_spot$country),]

weekly_data_modified$streams <- weekly_spot$streams
weekly_data_modified$lstreams <- weekly_spot$lstreams


# Dummies
weekly_data$treated_covid <- ifelse(weekly_data$year >= 2020, 1, 0)
weekly_data$after_start <- ifelse(weekly_data$week >= as.Date("3/11/2020", format = "%m/%d/%Y"), 1, 0)
weekly_data$treated_vaccine <- ifelse(weekly_data$year >= 2021, 1, 0)
weekly_data$after_vaccine <- ifelse(weekly_data$week >= as.Date("3/1/2021", format= "%m/%d/%Y"), 1, 0)
weekly_data$after_start_limited <- ifelse(weekly_data$week_num >= 63 & weekly_data$week_num < 125, 1, 0)


################################################################################

# Check for multicollinearity
corr_d <- weekly_data[, c(3,4,6,7,8,9,11,12,13,14,15)]
corrplot(cor(corr_d))


## Data Analysis and Regressions

# Try to recreate their results (Sim, Cho, Hwang, Telang)
# results show that the effect of COVID is actually negligible in the long-run

fit_1 <- plm(lstreams ~ treated_covid_limited + after_start_limited 
             + treated_covid_limited:after_start_limited, data = weekly_spot, 
             index=c("country", "week_num"), model = "within")
summary(fit_1)
coeftest(fit_1, vcovHC(fit_1, cluster="group", type="HC0")) #Robust SE
# robust SE for Stargazer
cov1 <- vcovHC(fit_1, cluster = "group", type = "HC0")
robust_se1 <- sqrt(diag(cov1))

## Stargazer of Data
stargazer(fit_1, 
          se=list(robust_se1), 
          column.labels=c("FE DiD Model"), 
          type="text", digits=3, omit.stat=c("f", "ser"))


# TikTok Data Analyses

fit_2 <- plm(rel_interest_tiktok ~ treated_covid_limited + after_start_limited
             + treated_covid_limited:after_start_limited, data = weekly_data_modified,
             index = c("country", "week_num"), model = "within")
summary(fit_2)
coeftest(fit_2, vcovHC(fit_2, cluster="group", type="HC0")) #Robust SE
# robust SE for Stargazer
cov2 <- vcovHC(fit_2, cluster = "group", type = "HC0")
robust_se2 <- sqrt(diag(cov2))

## Stargazer of Data
stargazer(fit_2, 
          se=list(robust_se2), 
          column.labels=c("FE DiD Model"), 
          type="text", digits=3, omit.stat=c("f", "ser"))


# YouTube Data Analyses

fit_3 <- plm(rel_interest_youtube ~ treated_covid_limited + after_start_limited
             + treated_covid_limited:after_start_limited, data = weekly_data_modified,
             index = c("country", "week_num"), model = "within")
summary(fit_3)
coeftest(fit_3, vcovHC(fit_3, cluster="group", type="HC0")) #Robust SE
# robust SE for Stargazer
cov3 <- vcovHC(fit_3, cluster = "group", type = "HC0")
robust_se3 <- sqrt(diag(cov3))

## Stargazer of Data
stargazer(fit_3, 
          se=list(robust_se3), 
          column.labels=c("FE DiD Model"), 
          type="text", digits=3, omit.stat=c("f", "ser"))


stargazer(fit_1, fit_2, fit_3,
          se=list(robust_se1, robust_se2, robust_se3), 
          column.labels=c("FE DiD Spotify", "FE DiD TikTok", "FE DiD YouTube"), 
          type="text", digits=3, omit.stat=c("f", "ser"))


# Regressions - trying to take severity of pandemic into account

weekly_data_modified$new_cases[weekly_data_modified$new_cases<=0] <- 1
weekly_data_modified$new_deaths[weekly_data_modified$new_deaths<=0] <- 1
weekly_data_modified$lnew_cases <- log(weekly_data_modified$new_cases)
weekly_data_modified$lnew_deaths <- log(weekly_data_modified$new_deaths)

fit_4 <- plm(rel_interest_tiktok ~ treated_covid_limited + after_start_limited
             + treated_covid_limited:after_start_limited + lag(lnew_cases),
             data = weekly_data_modified, index = c("country", "week_num"), model = "within")
summary(fit_4)
coeftest(fit_4, vcovHC(fit_4, cluster="group", type="HC0")) #Robust SE


fit_5 <- plm(rel_interest_youtube ~ treated_covid_limited + after_start_limited
             + treated_covid_limited:after_start_limited + lag(lnew_cases),
             data = weekly_data_modified, index = c("country", "week_num"), model = "within")
summary(fit_5)
coeftest(fit_5, vcovHC(fit_5, cluster="group", type="HC0")) #Robust SE


fit_6 <- plm(lstreams ~ treated_covid_limited + after_start_limited 
             + treated_covid_limited:after_start_limited + lag(lnew_cases), 
             data = weekly_data_modified,index=c("country", "week_num"), model = "within")
summary(fit_6)
coeftest(fit_6, vcovHC(fit_6, cluster="group", type="HC0")) #Robust SE


# robust SE for Stargazer
cov4 <- vcovHC(fit_4, cluster = "group", type = "HC0")
robust_se4 <- sqrt(diag(cov4))

# robust SE for Stargazer
cov5 <- vcovHC(fit_5, cluster = "group", type = "HC0")
robust_se5 <- sqrt(diag(cov5))

# robust SE for Stargazer
cov6 <- vcovHC(fit_6, cluster = "group", type = "HC0")
robust_se6 <- sqrt(diag(cov6))

## Stargazer of Data
stargazer(fit_4, fit_5, fit_6, 
          se=list(robust_se4, robust_se5, robust_se6), 
          column.labels=c("FE DiD TikTok WHO", "FE DiD YouTube WHO", "FE DiD Spotify WHO"), 
          type="text", digits=3, omit.stat=c("f", "ser"))




################################################################################

## Data Visualization


data <- panel_data(weekly_data, id = country, wave = week_num)

# log(streams) vs week_num by country
data %>% ggplot(aes(x=week_num, y=lstreams)) +
  geom_point(aes(colour=country)) +
  geom_smooth(method="lm") +
  facet_wrap( ~ country)

# streams vs week_num
data %>% ggplot(aes(x=week_num, y=streams)) +
  geom_point(aes(colour=country)) +
  geom_smooth(method="lm") +
  facet_wrap( ~ country)

# rel_interest_tiktok vs week_num by country
data %>% ggplot(aes(x=week_num, y=rel_interest_tiktok)) +
  geom_point(aes(colour=country)) +
  geom_smooth(method="lm") +
  facet_wrap( ~ country)

# rel_interest_youtube vs week_num by country
data %>% ggplot(aes(x=week_num, y=rel_interest_youtube)) +
  geom_point(aes(colour=country)) +
  geom_smooth(method="lm") +
  facet_wrap( ~ country)

# new_cases vs week_num by country, data unmodified
data %>% ggplot(aes(x=week_num, y=new_cases)) +
  geom_point(aes(colour=country)) +
  geom_smooth(method="lm") +
  facet_wrap( ~ country)

# new_deaths vs week_num by country
data %>% ggplot(aes(x=week_num, y=new_deaths)) +
  geom_point(aes(colour=country)) +
  geom_smooth(method="lm") +
  facet_wrap( ~ country)






