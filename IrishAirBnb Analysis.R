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
  mutate(newPrice1 = str_replace(price, pattern = ",", replacement = ""),
         newCleaningFee1 = str_replace(cleaning_fee, pattern = ",", replacement = ""),
         newSecurityDep1 = str_replace(security_deposit, pattern = ",", replacement = "")) %>%
  mutate(newPrice2 = str_extract(newPrice1, pattern = "[0-9]*\\."),
         newCleaningFee2 = str_extract(newCleaningFee1, pattern = "[0-9]*\\."),
         newSecurityDep2 = str_extract(newSecurityDep1, pattern = "[0-9]*\\.")) %>%
  mutate(price_fixed = str_replace(newPrice2, pattern = ".", replacement = ""),
         cleaning_fee_fixed = str_replace(newCleaningFee2, pattern = ".", replacement = ""),
         security_deposit_fixed = str_replace(newSecurityDep2, pattern = ".", replacement = ""))
 
pricenew = str_extract(irishMoney$price, pattern = "[0-9]*\\.")
   
#Let's do some sanity checks
# PRICE
table(irish$price, useNA = "ifany") #ok let's remove $0 and remove the ones over $1000 without reviews
# annoyingly there are commas. let's remove them. maybe try string extract instead?
irish$price1 = str_replace(irish$price, pattern = ",", replacement = "")
irish$price2 = str_replace(irish$price1, pattern = "\\$", replacement = "")
irish$price3 = str_replace(irish$price2, pattern = "\\.00", replacement = "")
irish$price = as.numeric(irish$price3)
# ok let's remove ones over 1000 that will host less than 10 people, and those that charge $0
irish = irish[!(irish$price > 1000 & irish$accommodates > 10),]
irish = irish[irish$price != 0,]

# 

