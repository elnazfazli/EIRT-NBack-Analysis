# ============================================================
# Project : EIRT-NBack-Analysis
# Author  : Elnaz Fazli
# Purpose : Load raw dataset
# ============================================================
library(haven)    # Read SPSS data
library(dplyr)    # Data manipulation
library(psych)    # describe
library(TAM)      # Explanatory IRT modeling
library(car)       # Variance Inflation Factor (VIF)

# Load required packages
file_path <- "data/mydata1.sav"
if (!file.exists(file_path)) stop("Data file not found. Please check the 'file_path'.")
df <- haven::read_sav(file_path)

