# =====================================================
# EIRT-NBack-Analysis
# File: 01_load_data.R
# Author: Elnaz Fazli
# =====================================================

library(haven)
library(dplyr)

# Load data
data <- read_sav("data/mydata1.sav")

# Display data structure
str(data)
