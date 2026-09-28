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

#Answer to the questions posed for part 2
#In this excel file, where the three sheets are titled "Readme", "County" and "ZIP", we see that the data records new ZEV sales and registrations, but not new purchases. This is because the data records new ZEV registrations used by the CEC, as something of a proxy network for new ZEV sales. The transactions included are qualifying new registrations of BEVs, PHEVs and FCEVs. The excluded transactions are used vehicle resales and transfers, repeat registrations, and vehicles that do not meet the CEC's vehicle criterion. On top of those questions, each row in the County sheet refers to an aggregate group of vehicles with the same year, quarter, county, fuel type, make and model. 

#Part 3: Checking the Dashboard
#1: Cumulative light-duty ZEV sales through 2026
library(dplyr)
zev |>
  summarize(total=sum(`Number of Vehicles`))
#2702646

#2: Year-to-date 2026 total sales
zev |>
  filter(`Data Year`==2026) |>
  summarize(total = sum(`Number of Vehicles`))
#151525

#3. Year-to-date 2026 total sales for the county that you’re from (if you’re not from California, use Alameda County, where we are now).
zev |>
  filter(`Data Year` == 2026, COUNTY == "Alameda") |>
  summarize(total = sum(`Number of Vehicles`))
#8754

#4: The 2026 total sales separated by BEV, PHEV, and FCEV
zev |> 
  filter(`Data Year` == 2026) |>
  group_by(FUEL_TYPE) |>
  summarize(total = sum(`Number of Vehicles`))
# FUEL_TYPE  total
#1 Electric  132453
#2 Hydrogen     171
#3 PHEV       18901

#5: The year-to-date (YTD) Zev Share
#This cannot be recreated as it requires sales / total vehicle sales, and zev only contains ZEV sales

#6: A table of counts of 2026 Tesla sales, split by model
zev |>
  filter(`Data Year` == 2026, MAKE == "Tesla") |>
  group_by(MODEL) |> 
  summarize(total = sum(`Number of Vehicles`)) |>
  arrange(desc(total))
#  MODEL      total
#1 Model Y    53682
#2 Model 3    17827
#3 Model X     2809
#4 Model S     1667
#5 Cybertruck  1499

#7: A table of counts of 2026 sales, split first by make, then by model
zev |>
  filter(`Data Year` == 2026) |>
  group_by(MAKE, MODEL) |> 
  summarize(total = sum(`Number of Vehicles`)) |>
  arrange(MAKE, desc(total))
#   MAKE         MODEL                   total
#   <chr>        <chr>                   <dbl>
# 1 Alfa Romeo   Tonale Hybrid              13
# 2 Alfa Romeo   Tonale Tributo Italiano     1
# 3 Aston Martin Valhalla                   16
# 4 Audi         Q6 e-tron                 325
# 5 Audi         A6 Sportback e-tron        78
# 6 Audi         S6 Sportback e-tron        51
# 7 Audi         SQ6 e-tron                 48
# 8 Audi         Q4 e-tron                  45
# 9 Audi         S e-tron GT                21
#10 Audi         Q6 Sportback e-tron        19
# 140 more rows

#Part 4: Beyond the Dashboard