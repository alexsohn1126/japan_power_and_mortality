# Replication Study on Japan's Power Saving Policies' Effect on Mortality Rate

## Overview

This repository includes the replication study done on a study about Japan's power saving policies and their effect on mortality rate, especially on extremely hot days by Guojun He and Takanao Tanaka. The link to the paper is: [https://doi.org/10.1257/app.20200505](https://doi.org/10.1257/app.20200505).

## Replication
A minimum SSRP replication of 3 graphs that were in the original paper was done with R, and is located within `scripts/99-replicate_paper.R`.

## File Structure

The repo is structured as:

-   `input/data` contains the data sources used in analysis including the raw data.
-   `outputs/data` contains the cleaned dataset that was constructed.
-   `outputs/paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data.

## LLM
No LLM was used in the writing of this paper.