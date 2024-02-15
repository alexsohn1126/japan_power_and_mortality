#### Preamble ####
# Purpose: Tests cleaned data
# Author: Moohaeng Sohn
# Date: 15 February, 2024
# Contact: alex.sohn@mail.utoronto.ca
# License: MIT
# Pre-requisites: Download packages and data used (instructions on data download is in the readme)


#### Workspace setup ####
library(tidyverse)

#### Test data ####
curr_data <- read.csv("outputs/data/cleaned_data.csv")

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
