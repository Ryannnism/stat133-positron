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
#Part A: One question I had was "Which vehicle models and makes are the most popular zero-emission vehicles in California in 2026?"
zev |> 
  filter(`Data Year` == 2026) |>
  group_by(MAKE, MODEL) |> 
  summarize(total = sum(`Number of Vehicles`)) |> 
  arrange(desc(total))
# Groups:   MAKE [43]
#   MAKE    MODEL                total
#   <chr>   <chr>                <dbl>
# 1 Tesla   Model Y              53682
# 2 Tesla   Model 3              17827
# 3 Hyundai IONIQ 5               7421
# 4 Toyota  bZ                    5102
# 5 Toyota  RAV4 Plug-in Hybrid   3186
# 6 Rivian  R1S                   2820
# 7 Tesla   Model X               2809
# 8 Ford    Mustang Mach-E        2659
# 9 Honda   Prologue              2598
#10 Toyota  Prius Plug-in Hybrid  2514
# 140 more rows

#It seems here that the Tesla Model Y was the most popular make and model in 2026 with the limited data that I have. Unfortunately, the 2026 data only has year-to-date records till June 30th, so it doesn't represent the whole calendar year.

#Part B: Tax Credit effect
zev |> 
  filter(`Data Year`==2025, FUEL_TYPE %in% c("Electric", "PHEV"), Quarter %in% c("3", "4")) |>
  group_by(FUEL_TYPE, Quarter) |> 
  summarize(total = sum(`Number of Vehicles`)) 
# A tibble: 4 × 3
# Groups:   FUEL_TYPE [2]
#  FUEL_TYPE Quarter  total
#  <chr>       <dbl>  <dbl>
# 1 Electric        3 110380
# 2 Electric        4  70360
# 3 PHEV            3  16595
# 4 PHEV            4   8587



#It seems that there is a clear Q3 2025 surge followed by a Q4 drop for bot BEVs and PHEVs. Electric sales decreased from 110380 in Q3 to 70360 in Q4, which is a sharp decrease of about 36.3% (used R as a calculator in the console). The PHEV sales decreased from 16595 to 8587 which is a decrease of 48.3$. The decline after Q3 was larger for PHEV than BEV. This however, does not prove that the expiration of tax incentives were the sole cause of the decline, where there are other confounding factors such as seasonal and personal preferences that may have affected sales.

#Part C: Herfindahl Index
hi <- function(x) { 
  shares <- x / sum(x)
  sum(shares^2)
}

hi_year <- zev |>
  group_by(`Data Year`, MAKE) |>
  summarize(total = sum(`Number of Vehicles`)) |> 
  group_by(`Data Year`) |>
  summarize(HI = hi(total))

hi_year
# A tibble: 19 × 2
#   `Data Year`    HI
#          <dbl> <dbl>
#  1        2008 1    
#  2        2009 0.498
#  3        2010 0.542
#  4        2011 0.568
#  5        2012 0.298
#  6        2013 0.181
#  7        2014 0.148
#  8        2015 0.122
#  9        2016 0.142
# 10        2017 0.138
# 11        2018 0.251
# 12        2019 0.273
# 13        2020 0.388
# 14        2021 0.323
# 15        2022 0.375
# 16        2023 0.280
# 17        2024 0.222
# 18        2025 0.192
# 19        2026 0.280

#The interpretation of this is such that as there is a higher Herfindahl Index value, the market is more concentrated among a few makes, and when it is lower, then it is less concentrated. 
#This result suggests that past 2022, the pattern such that it becomes less concentrated. In 2022, it was 0.375, and in 2025, it was 0.192. Discounting 2026, because it hasn't been a full calendar year, so I won't include that in this statement as it isn't controllable and fixed yet. This trend however is not consistent across the whole data set as concentration increased during some earlier years where it was rising from 0.498 in 2009 to 0.568 in 2011. 
