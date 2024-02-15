# Replication Study on Japan's Power Saving Policies' Effect on Mortality Rate

## Overview

This repository includes the replication study done on a study about Japan's power saving policies and their effect on mortality rate, especially on extremely hot days by Guojun He and Takanao Tanaka. The link to the paper is: [https://doi.org/10.1257/app.20200505](https://doi.org/10.1257/app.20200505).

## Replication
A minimum SSRP replication of 3 graphs that were in the original paper was done with R, and the code is located in `scripts/99-replicate_paper.R`, and the graphs generated are located in `outputs/replication`. 

## File Structure

The repo is structured as:

- `input/data` contains the data sources used in analysis including the raw data.
- `outputs/data` contains the cleaned dataset that was constructed.
- `outputs/paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper.
- `outputs/replication` contains the replicated graphs from the original paper.
- `scripts` contains the R scripts used to simulate, download and clean data.

## Downloading replication data
We use the dataset from the paper: ["Energy Saving May Kill: Evidence from the Fukushima Nuclear Accident"](https://doi.org/10.1257/app.20200505) by Guojun He and Takanao Tanaka.

The replication package is downloadable in the openICPSR website which requires an account to download.

Link to the dataset: [https://doi.org/10.3886/E170502V1](https://doi.org/10.3886/E170502V1)

Last accessed: 14 Feb, 2024

You will need the following files from the openICPSR website linked above
- working_data.dta
- region_merged.dta
- py_merged.dta

All 3 files should be found directly within the data folder, not in any of the subfolders within the data folder.

Make sure to increase the number of records per page once you access the data folder or switch pages to find the data.

To download a file:

1. Click the data you want to download
2. Click "Download This file" button
3. (If you haven't signed in) Click sign-in with your preferred method
    1. Create an account here if you don't have one
4. Click I Agree on the Terms of Use
5. The file should start downloading
6. Add those files into inputs/data

## LLM
No LLM was used in the writing of this paper.
