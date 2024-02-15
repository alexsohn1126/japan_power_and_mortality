#### Preamble ####
# Purpose: Downloads and saves the data from the Original paper
# Author: Moohaeng Sohn
# Date: 14 February, 2024
# Contact: alex.sohn@mail.utoronto.ca
# License: MIT
# Pre-requisites: Download packages used

#### FOR REPLICATION DATASET ####
# We use the dataset from the paper: https://doi.org/10.1257/app.20200505 by Guojun He and Takanao Tanaka.
# 
# The replication package is downloadable in the openICPSR website which requires an account to download.
# 
# Link to the dataset: https://doi.org/10.3886/E170502V1
# 
# Last accessed: 14 Feb, 2024
# 
# You will need the following files from the openICPSR website linked above
# - working_data.dta
# - region_merged.dta
# - py_merged.dta
# 
# All 3 files should be found directly within the data folder, not in any of the subfolders within the data folder.
# 
# Make sure to increase the number of records per page once you access the data folder or switch pages to find the data.
# 
# To download a file:
#   
# 1. Click the data you want to download
# 2. Click "Download This file" button
# 3. (If you haven't signed in) Click sign-in with your preferred method
#     3a. Create an account here if you don't have one
# 4. Click I Agree on the Terms of Use
# 5. The file should start downloading
# 6. Add those files into inputs/data

# You may need to perform this step if you have an incompatible version with rnaturalearth
# install.packages("devtools")
# devtools::install_github("ropensci/rnaturalearthhires")

#### Load packages ####
library(rnaturalearth)
library(sf)

#### Download data ####
# Download japan shapefile
japan_prefectures <- ne_states(country = "Japan", returnclass = "sf")
st_write(japan_prefectures, "inputs/data/japan_prefectures.shp")
