#Part 1: The CEC Dashboard
#Question 1: Which California counties have the highest number of zero-emission vehicle sales in 2026?
#Question 2: Which vehicle models and makes are the most popular zero-emission vehicles in California in 2026?
#Question 3: How do sales of BEVs, PHEVs and FCEVs differ across counties in California? 

#Part 2: The Data Behind the Dashboard
#install.packages("readxl")
library(readxl)
zev <- read_excel("C:/Users/ryann/Downloads/New_ZEV_Sales_Last_updated_07-17-2026_ada.xlsx",
  sheet = "County")

readme <- read_excel("C:/Users/ryann/Downloads/New_ZEV_Sales_Last_updated_07-17-2026_ada.xlsx",
  sheet = "Readme")
  
zip <- read_excel("C:/Users/ryann/Downloads/New_ZEV_Sales_Last_updated_07-17-2026_ada.xlsx",
  sheet = "ZIP")

View(zev)
View(readme)
View(zip)


