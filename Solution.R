#load data
temp_df <- read.table("temps.txt", header = TRUE)
head(temp_df)

#convert wide format to long format (years are made into a single column)
year_cols <- grep("^X", colnames(temp_df))
years <- as.numeric(sub("X", "", colnames(temp_df)[year_cols]))

#convert data frame to matrix, matrix to vector
temp_data <- as.vector(as.matrix(temp_df[, year_cols]))

#remove null values
temp_data <- temp_data[!is.na(temp_data)]

cat("Total observations:", length(temp_data),"\n")
days_per_season <- nrow(temp_df)
cat("Days per season:", days_per_season,"\n")

#create time series (daily data, seasonal pattern each year)
start_year <- min(years)
ts_temps <- ts(temp_data, frequency = days_per_season, start = c(start_year, 1))

#HoltWinters - Additive and Multiplicative fit models
#additive fit model
hw_additive <- HoltWinters(ts_temps, seasonal = "additive")
print("=== ADDITIVE MODEL ===")
print(hw_additive)
#Sum of Squared Error - Additive
cat("SSE:", hw_additive$SSE, "\n\n")

#multiplicative fit model
hw_multiplicative <- HoltWinters(ts_temps, seasonal = "multiplicative")
print("=== MULTIPLICATIVE MODEL ===")
print(hw_multiplicative)
#Sum of Squared Error - Multiplicative
cat("SSE:", hw_multiplicative$SSE, "\n\n")

#plotting both additive and multiplicative fit
#additive fit
par(mfrow = c(2, 1))
plot(hw_additive, main = "Holt-Winters Additive Model") 
#multiplicative fit
plot(hw_multiplicative, main = "Holt-Winters Multiplicative Model") 
par(mfrow = c(1, 1))

#compare additive and multiplicative fit
if(hw_additive$SSE < hw_multiplicative$SSE) {
  hw_model <- hw_additive
  model_type <- "ADDITIVE"
  cat("ADDITIVE model has lower SSE\n\n")
} else {
  hw_model <- hw_multiplicative
  model_type <- "MULTIPLICATIVE"
  cat("MULTIPLICATIVE model has lower SSE\n\n")
}

#extract trend component to see if summer end is shifting
trend_component <- hw_model$fitted[,"trend"]

#create a proper data frame for analysis
#each year has days_per_season observations
temp_df2 <- data.frame(
  temp = temp_data,
  year = rep(years, each = days_per_season),
  day = rep(1:days_per_season, length(years))
)

#focus on late season - last 50% of the season
late_day_start <- round(days_per_season * 0.5)  
late_season <- temp_df2[temp_df2$day >= late_day_start, ]

#calculate average late season temp by year
late_season_avg <- aggregate(temp ~ year, data = late_season, mean)

#simple linear trend test
trend_test <- lm(temp ~ year, data = late_season_avg)
summary(trend_test)

#plotting the trend
plot(late_season_avg$year, late_season_avg$temp, 
     type = "b", pch = 19,
     xlab = "Year", ylab = "Avg Late Season Temp (F)",
     main = "Late Season Temperature Trend")
abline(trend_test, col = "red", lwd = 2)

coeff_trend <- round(coef(trend_test)[2],3)
p_value <- round(summary(trend_test)$coefficients[2,4], 4)

cat("\n=== SUMMER END ANALYSIS ===\n")
cat("Slope of late season temperature trend:",coeff_trend, "°F per year\n")
cat("P-value:",p_value, "\n")

#analyzing the trend for conclusion
if(coeff_trend > 0 & p_value < 0.05) {
  print("Summer end appears to be getting LATER")
} else if(coeff_trend < 0 & p_value < 0.05) {
  print("Summer end appears to be getting EARLIER")
} else {
  print("No significant trend in summer end timing")
}
