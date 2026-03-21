library(dplyr)
library(tidyr)
library(tidyverse)
library(ggplot2)
library(gridExtra)
library(corrplot)
# load data into R
df <- read.csv("data/Airbnb_Open_Data.csv")
# check the structure of the data
str(df)
############# Data Cleaning #############
# check duplicated row
duplicates <- duplicated(df)
sum(duplicates)
# delete the duplicated rows
duplicated_rows <- df[duplicates, ]
22
df <- df[!duplicated(df), ]
nrow(df)
# convert price and service price into numeric
df$price <- gsub("[$,]", "", df$price)
df$service.fee <- gsub("[$,]", "", df$service.fee)
df$price <- as.numeric(df$price)
df$service.fee <- as.numeric(df$service.fee)
str(df$price)
str(df$service.fee)
# check NA values
df[] <- lapply(df, function(x) {
ifelse(x == "", NA, x)
})
sapply(df, function(x) sum(is.na(x)))
# check unique values in categorical variables
categorical <- c('host_identity_verified', 'neighbourhood.group', 'country',
'country.code', 'cancellation_policy', 'room.type')
unique_values <- lapply(df[categorical], function(x) {
23
unique(x)
})
unique_values
# find Brooklyn and brookln, Manhattan and manhatan, which are the same places, convert them
into the same
df <- df %>%
mutate(neighbourhood.group = ifelse(neighbourhood.group == 'manhatan', 'Manhattan',
neighbourhood.group)) %>%
mutate(neighbourhood.group = ifelse(neighbourhood.group == 'brookln', 'Brooklyn',
neighbourhood.group))
# fill country and country.code with united states and us
df <- df %>%
mutate(country = ifelse(is.na(country), 'United States', country)) %>%
mutate(country.code = ifelse(is.na(country.code), 'US', country.code))
# remove the last column licence, only have two non-NA values
ncol(df)
df <- select(df,-license)
ncol(df)
# remove NA rows with price is missing
24
nrow(df)
df <- df[!is.na(df$price), ]
nrow(df)
# Convert to Date using the correct format
str(df$last.review)
df$last.review <- as.Date(df$last.review, format = "%m/%d/%Y")
str(df$last.review)
numerical_cols <- sapply(df, is.numeric)
numerical_cols
write.csv(df, 'Airbnb.csv')