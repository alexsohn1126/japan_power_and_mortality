#### Preamble ####
# Purpose: Cleans the Japanese 
# Author: Moohaeng Sohn
# Date: 14 February, 2024
# Contact: alex.sohn@mail.utoronto.ca
# License: MIT
# Pre-requisites: Download packages and data used (instructions on data download is in the readme)

#### Workspace setup ####
library(tidyverse)
library(haven)

#### Load data ####
pref_year <- read_dta("inputs/data/py_merged.dta")
regions <- read_dta("inputs/data/region_merged.dta")
working <- read_dta("inputs/data/working_data.dta")

#### Clean data ####
# Pick out only the relevant columns and rows with actual data
# There is only gdp data for 2008-2015
pref_year <- pref_year |>
  select(year, pref_id, area_id, pref_name, pop0_19, pop20_64, pop65, gdp) |>
  filter(year >= 2008 & year <= 2015)
# Only take the summer months as that's the main focus of this study
regions <- regions |>
  filter(month %in% c(7,8,9)) |>
  select(year, month, area_id, power_usage = total) |>
  filter(year >= 2008 & year <= 2015)
# Also only take summer months
working <- working |>
  filter(month %in% c(7,8,9)) |>
  select(year, month, area_id, saving_rates = saving_rs, stroker, temp) |>
  filter(year >= 2008 & year <= 2015)

# Create new columns relevant to us
# GDP per capita for each prefecture
pref_year <- pref_year |>
  mutate(
    gdp_capita = gdp / (pop0_19 + pop20_64 + pop65)
  )
# 

#### Save data ####
write_csv(cleaned_data, "outputs/data/analysis_data.csv")
