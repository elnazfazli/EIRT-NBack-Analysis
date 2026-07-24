# ============================================================
# Project : EIRT-NBack-Analysis
# Author  : Elnaz Fazli
# Purpose : Load raw dataset
# ============================================================
ibrary(haven)    
library(dplyr)  
library(psych)    # describe
library(TAM)      # EIRT / tam.mml / tam.latreg
library(car)      # vif
file_path <- "data/mydata1.sav"
if (!file.exists(file_path)) stop("فایل پیدا نشد .بررسی مسیر 'file_path'")
df <- haven::read_sav(file_path)
