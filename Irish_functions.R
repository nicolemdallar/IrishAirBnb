# Analysis of AirBnb data from Ireland
# Functions
# Nicole Dallar
# Updated 2020-02-26

formatMoney = function(x) {
  no_dollar = str_replace(x, pattern = "[$]", replacement = "")
  no_comma = str_replace(no_dollar, pattern = ",", replacement = "")
  new_price = as.numeric(no_comma)
  return(new_price)
}
