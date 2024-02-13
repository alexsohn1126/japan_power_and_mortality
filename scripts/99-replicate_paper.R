#### Preamble ####
# Purpose: Replicates Graphs With Data From the Original Paper
# Author: Moohaeng Sohn
# Date: February 12th, 2024
# Contact: alex.sohn@mail.utoronto.ca
# License: MIT
# Pre-requisites: Have the required data downloaded in the inputs/data folder


#### Workspace setup ####
library(tidyverse)
library(haven)

#### Load in Nuclear data ####
nuclear <- read_dta("inputs/data/nuclear.dta")

#### Make Nuclear Power Usage Graph ####
nuclear_graph_data <- nuclear |>
  group_by(year) |>
  summarize(
    total_energy = sum(all),
    total_nuclear = sum(nuclear),
    utilization = total_nuclear / total_energy
  ) |>
  mutate(
    # Mark dates before the Fukushima Incident
    before_incident = if_else(as.Date(paste(year, "12-01", sep="-")) < as.Date("2011-03-11"), "Before", "After")
  )
nuclear_graph_data|>
  ggplot(aes(x=year, y=utilization)) +
  geom_line(color="gray",
            size=1) +
  geom_point(aes(color=before_incident,
                 shape=before_incident),
             size = 5) +
  geom_vline(xintercept = 2010.5,
             color= "#808080",
             linetype = "dashed",
             size = 1) +
  theme_classic() +
  scale_x_continuous(breaks = seq(2008, 2015, by=1)) +
  labs(
    x= "Year",
    y = "Nuclear Power Utilization",
    color = "Before or After the Fukushima Incident",
    shape = "Before or After the Fukushima Incident"
  ) + 
  theme(legend.position = 'bottom')

#### Load Electricity Usage and Cost Data ####
ec_usage_cost <- tibble(read_dta("inputs/data/elec_region.dta"))

#### Replicate Electricity Usage and Cost Graph ####
ec_graph_data <- ec_usage_cost |>
  filter(month %in% c(12,1,2,3,7,8,9)) |>
  mutate(
    season = if_else(month %in% c(12,1,2,3), "Winter", "Summer")
  ) |>
  group_by(year, season) |>
  summarize(
    avg_cost = mean(ptotal),
    avg_usage = mean(total)
  ) |>
  ungroup()

# Get 2010 winter averages
winter_2010_avg_ec_usage <- ec_graph_data |>
  filter(year == 2010 & season == "Winter") |>
  pull('avg_usage')
winter_2010_avg_ec_cost <- ec_graph_data |>
  filter(year == 2010 & season == "Winter") |>
  pull('avg_cost')

# Get 2010 Summer averages
summer_2010_avg_ec_usage <- ec_graph_data |>
  filter(year == 2010 & season == "Summer") |>
  pull('avg_usage')
summer_2010_avg_ec_cost <- ec_graph_data |>
  filter(year == 2010 & season == "Summer") |>
  pull('avg_cost')

# Make a new row with all the ratios
ec_graph_data <- ec_graph_data |>
  mutate(
    cost_ratio = if_else(season == "Summer",
                         avg_cost / summer_2010_avg_ec_cost,
                         avg_cost / winter_2010_avg_ec_cost),
    usage_ratio = if_else(season == "Summer",
                         avg_usage / summer_2010_avg_ec_usage,
                         avg_usage / winter_2010_avg_ec_usage)
  )

# Make 2 vectors with average of those 2 seasons
# One for Usage ratio
# One for Cost ratio
yearly_avg_usage <- c()
yearly_avg_cost <- c()

# For each year get the average usage and average cost and add to the vector
for (y in 2004:2015){
  curr_avg_usage <- ec_graph_data |>
    filter(year == y) |>
    pull(usage_ratio)
  curr_avg_cost <- ec_graph_data |>
    filter(year == y) |>
    pull(cost_ratio)
  print(curr_avg_cost)
  # we need double for yearly avg because there's summer and winter rows per year
  yearly_avg_usage <- c(yearly_avg_usage, mean(curr_avg_usage), mean(curr_avg_usage))
  yearly_avg_cost <- c(yearly_avg_cost, mean(curr_avg_cost), mean(curr_avg_cost))
}

# Add in the average usage and average cost column
final_ec_graph_data <- ec_graph_data |>
  mutate(
    yearly_cost = yearly_avg_cost,
    yearly_usage = yearly_avg_usage
  ) |>
  select(
    -avg_cost,
    -avg_usage
  ) |>
  pivot_longer(
    cols = -c(year, season),
    names_to = "dataType",
    values_to = "values"
  ) |>
  # filter out winter yearly cost rows as it overlaps with summer yearly cost rows (they contain same info)
  filter(!((dataType == "yearly_cost" | dataType == "yearly_usage") & season == "Winter")) |>
  # Add season to datatype so we can separate it when we graph
  mutate(
    dataType = paste(season, dataType, sep="-")
  )

final_ec_graph_data |>
  ggplot(aes(x = year)) +
  theme_classic() +
  scale_x_continuous(breaks = seq(2004, 2015, by=1)) +
  scale_linetype_manual(values=c("twodash", "dotted", "twodash", "dotted", "twodash", "dotted"),
                        labels=c('Summer Cost', 'Summer Usage', 'Year Cost', 'Year Usage', 'Winter Cost', 'Winter Usage')) +
  scale_shape_manual(values=c(17, 16, 15, 18, 16, 17),
                     labels=c('Summer Cost', 'Summer Usage', 'Year Cost', 'Year Usage', 'Winter Cost', 'Winter Usage')) +
  scale_color_manual(
    values=c('red','red', 'darkgray', 'darkgray','blue','blue'),
    labels=c('Summer Cost', 'Summer Usage', 'Year Cost', 'Year Usage', 'Winter Cost', 'Winter Usage')
    ) +
  geom_line(
    aes(
      y = values,
      color = dataType,
      linetype = dataType
    ),
    size = 0.8
  ) +
  geom_point(
    aes(
      y = values,
      shape = dataType,
      color = dataType
    ),
    size = 4
  ) +
  labs(
    x = "Year",
    y = "Ratio of cost/usage compared to 2010",
    color = "Ratios",
    shape = "Ratios",
    linetype = "Ratios"
  )

#### Load in Saving Target and Consumption data ####
saving_target <- tibble(read_dta('inputs/data/saving_r.dta'))
consumption <- tibble(read_dta('inputs/data/elec_region.dta'))

#### Replicate Graph ####
# Organize saving target By year and area code
region_yearly_st <- saving_target |>
  mutate(
    id = paste(year, area_id, sep = "-"),
  ) |>
  group_by(id) |>
  summarize(
    st = mean(saving_rs)
  )

# Get total energy consumption by season and year and id
season_yearly_cons <- consumption |>
  filter(month %in% c(1,2,3, 7,8,9, 12)) |>
  mutate(
    season = if_else(month %in% c(1,2,3,12), "Winter", "Summer")
  ) |>
  group_by(season, year, area_id) |>
  summarize(
    total = sum(total)
  ) |>
  ungroup()

# Get 2010 winter consumption data by area and sort by area_id
winter_2010_cons <- season_yearly_cons |>
  filter(year == 2010 & season == "Winter") |>
  arrange(area_id) |>
  pull(total)

# Get 2010 summer ...
summer_2010_cons <- season_yearly_cons |>
  filter(year == 2010 & season == "Summer") |>
  arrange(area_id) |>
  pull(total)

# Get % change for each year and area id
perc_change <- season_yearly_cons |>
  mutate(
    change = 
      if_else(
        season == "Winter",
        # Use the fact that winter_2010_cons[area_id] gives us 2010 consumption 
        total / winter_2010_cons[area_id] - 1,
        total / summer_2010_cons[area_id] - 1
      )
  ) |>
  # Only using data past 2010 
  filter(year > 2010) |>
  mutate(
    id = paste(year, area_id, sep = "-"),
  ) |>
  select(
    season,
    id,
    change
  )
  
# Merge 2 tibbles
merged_table <- left_join(
  perc_change,
  region_yearly_st,
  by = "id"
)

# Make graph
merged_table |>
  ggplot(x = st, y = change) +
  geom_point(
    aes()
  )
  
  



























