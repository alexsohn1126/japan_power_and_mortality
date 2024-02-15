#### Preamble ####
# Purpose: Simulates and tests the main dataset we will use
# Author: Moohaeng Sohn
# Date: 14 February, 2024
# Contact: alex.sohn@mail.utoronto.ca
# License: MIT
# Pre-requisites: Download packages used


#### Workspace setup ####
library(tidyverse)

#### Simulate data ####
num_years = 8
start_year = 2008
end_year = start_year + num_years - 1
num_area = 10
# For each year, 3 months 
# for each month, 10 areas (num_area)
# for each area, 3 age groups
# 720 rows total

curr_data <- tibble(
  year = rep(start_year:end_year, each= 3 * 3, times = num_area),
  # 3 months for summer: July, Aug, Sep
  month = rep(7:9, 3 * num_years * num_area),
  area_id = rep(1:num_area, each = 3 * 3 * num_years),
  age_group = rep(c("0_19", "20_64", "65"), each = 3, times = num_years * num_area),
  saving_rate = rbeta(3 * 3 * num_years * num_area, shape1 = 2, shape2 = 5),
  heat_stroke_rate = 100 * rbeta(3 * 3 * num_years * num_area, shape1 = 2, shape2 = 5),
  elec_price = 20 * rbeta(3 * 3 * num_years * num_area, shape1 = 2, shape2 = 5),
  gdp_capita = 1000 + 100 * rbeta(3 * 3 * num_years * num_area, shape1 = 2, shape2 = 5),
)


#### Test data ####
curr_data$year |> is.numeric()
all((curr_data$year |> min()) >= 1900)
all((curr_data$year |> max()) <= 2024)

curr_data$month |> is.numeric()
all((curr_data$month |> min()) >= 1)
all((curr_data$month |> max()) <= 12)

curr_data$area_id |> is.numeric()
all((curr_data$area_id |> min()) >= 1)
all((curr_data$area_id |> max()) <= 10)

curr_data$age_group |> is.character()
all(curr_data$age_group %in% c("0_19", "20_64", "65"))

curr_data$saving_rate |> is.numeric()
all((curr_data$saving_rate |> min()) >= 0)
all((curr_data$saving_rate |> max()) <= 1)

curr_data$heat_stroke_rate |> is.numeric()
all((curr_data$heat_stroke_rate |> min()) >= 0)
# heat stroke rate is measured in x in 100,000
all((curr_data$heat_stroke_rate |> max()) <= 100000)

curr_data$elec_price |> is.numeric()
all((curr_data$elec_price |> min()) >= 0)

curr_data$gdp_capita |> is.numeric()
all((curr_data$gdp_capita |> min()) >= 0) 







