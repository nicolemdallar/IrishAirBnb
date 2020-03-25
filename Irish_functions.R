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

iqrRemoveOutliers = function(x) {
  iqr = IQR(x, na.rm = T)
  firstQ = quantile(x, na.rm = T)[2]
  thirdQ = quantile(x, na.rm = T)[4]
  minRemove = firstQ - (1.5 * iqr)
  maxRemove = thirdQ + (1.5 * iqr)
  return(paste0("For this column remove any values below ", minRemove, " or above ", maxRemove, "."))
}
