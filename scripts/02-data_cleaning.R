#### Preamble ####
# Purpose: Cleans the map dataset and replication dataset
# Author: Moohaeng Sohn
# Date: 15 February, 2024
# Contact: alex.sohn@mail.utoronto.ca
# License: MIT
# Pre-requisites: Download packages and data used (instructions on data download is in the readme)

#### Workspace setup ####
library(tidyverse)
library(haven)
library(sf)

#### Load data ####
pref_year <- read_dta("inputs/data/py_merged.dta")
regions <- read_dta("inputs/data/region_merged.dta")
working <- read_dta("inputs/data/working_data.dta")
japan_prefectures <- st_read("inputs/data/japan_prefectures.shp")

#### Clean data ####
# Pick out only the relevant columns and rows with actual data
# There is only gdp data for 2008-2015
pref_year <- pref_year |>
  select(year, pref_id, area_id, pref_EN, pop0_19, pop20_64, pop65, gdp) |>
  filter(year >= 2008 & year <= 2015)
# Only take the summer months as that's the main focus of this study
regions <- regions |>
  filter(month %in% c(7,8,9)) |>
  select(year, month, area_id, pop0_19, pop20_64, pop65, power_usage = total, ptotal) |>
  filter(year >= 2008 & year <= 2015)
# Also only take summer months
working <- working |>
  filter(month %in% c(7,8,9)) |>
  select(year, month, area_id, age, saving_rate = saving_rs, stroker, temp) |>
  filter(year >= 2008 & year <= 2015)
# Delete unnecessary columns from map data
japan_prefectures <- japan_prefectures |>
  select(woe_label) |>
  # extract first word (prefecture name)
  mutate(
    woe_label = str_extract_all(woe_label, "^([\\w]+)") |> tolower()
  ) |>
  # english version of the prefecture "kouchi" is different from here to the replication dataset
  mutate(
    woe_label = ifelse(
      woe_label == "kochi",
      "kouchi",
      woe_label
    )
  )

# change any non-positive heat_stroke_rate to 0
working <- working |>
  mutate(
    stroker = pmax(stroker, 0)
  )

# Create GDP per capita for each prefecture for each year
pref_year <- pref_year |>
  mutate(
    gdp_capita = gdp / (pop0_19 + pop20_64 + pop65)
  )
# Create power usage per capita for each year/month and area
regions <- regions |>
  mutate(
    power_usage_capita = power_usage / (pop0_19 + pop20_64 + pop65)
  )

# minimize the tables before joining
regions <- regions |>
  select(
    year, month, area_id, power_usage_capita, ptotal
  )

# Take avg gdp for areas
pref_year <- pref_year |>
  group_by(year, area_id) |>
  summarize(
    area_gdp_capita = sum(gdp) / sum(pop0_19 + pop20_64 + pop65)
  )

# Make a table combining all the replication data
cleaned_data <- left_join(
    regions,
    working,
    by = join_by(year, month, area_id)
  ) |>
  left_join(
    pref_year
  )

# Final column name changes
cleaned_data <- cleaned_data |>
  select(year,
         month,
         area_id,
         age_group = age,
         saving_rate,
         heat_stroke_rate = stroker,
         elec_price = ptotal,
         avg_temp = temp,
         gdp_capita = area_gdp_capita)

#### Save data ####
write_csv(cleaned_data, "outputs/data/cleaned_data.csv")
st_write(japan_prefectures, "outputs/data/japan_prefectures.shp", append = FALSE)
