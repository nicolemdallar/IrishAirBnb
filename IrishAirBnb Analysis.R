# Analysis of AirBnb data from Ireland
# Nicole Dallar
# Updated 2020-02-26

# Load in libraries
packages = c("dplyr", "ggplot2", "tidyr", "stringr")
tmp = sapply(packages, function(p){
  if (!require(p, character.only = T)){
    install.packages(p)
    library(p, character.only = T)
  }
})

# Locate and read in the Airbnb data
baseDir = normalizePath("/Users/Nicole/Documents/GitHub/IrishAirBnb")
irishRaw = read.csv(file = paste0(baseDir, "/longlistings.csv"), strip.white = T, stringsAsFactors = F)

# Load functions from functions file
source(paste0(baseDir, "/Irish_functions.R"))

# Initial data exploration
class(irishRaw) #data.frame, good
colnames(irishRaw) #some seem useful, some boring
str(irishRaw) #see link I found explaining the data

# Drop columns I don't care about
# square feet is more than 90% NA. others are urls or all the same value.
# only kept avail 365
# kept bed type even though most are "real bed", same with experiences offered. whats up with those
irishSubset = irishRaw %>%
  select(-listing_url, -scrape_id, -thumbnail_url, -medium_url, -picture_url, -xl_picture_url, -host_url, -host_thumbnail_url,
         -host_picture_url, -latitude, -license, -requires_license, -weekly_price, -monthly_price, -square_feet, -jurisdiction_names,
         -longitude, -is_location_exact, -calendar_last_scraped, -country, -country_code, -availability_30, -availability_60,
         -availability_90)

# let's fix money columns to be actual numbers
# this could probably be made into a function. kind of enraging to do three separate mutates
irishMoney = irishSubset %>%
  mutate_at(c("price", "security_deposit", "cleaning_fee", "extra_people"), formatMoney)
   
#### Let's do some sanity checks ####
# let's remove prices over $999 and those for $0
# remove cleaning fees greater than 300
# security deposit over 1000
# extra people seems fine
# remove those WITHOUT availability... but this removes close to 6k rows. probably not going to do it
irishSane = irishMoney %>%
  filter(0 < price & price < 9999,
         cleaning_fee < 300,
         security_deposit < 1000)

