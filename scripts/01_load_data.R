# ============================================================
# Project : EIRT-NBack-Analysis
# Author  : Elnaz Fazli
# Purpose : Load raw dataset
# ============================================================
library(haven)    # خواندن SPSS
library(dplyr)    # ویرایش دیتا
library(psych)    # describe
library(TAM)      # مدل EIRT / tam.mml / tam.latreg
library(car)      # vif

# ---------- 2.مسیر فایل و خواندن دیتا ----------
file_path <- "data/mydata1.sav"
if (!file.exists(file_path)) stop("فایل پیدا نشد.بررسی مسیر 'file_path'")
df <- haven::read_sav(file_path)

