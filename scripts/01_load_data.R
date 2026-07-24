ibrary(haven)    
library(dplyr)  
library(psych)    # describe
library(TAM)      # مدل EIRT / tam.mml / tam.latreg
library(car)      # vif
file_path <- "C:/Users/user/Desktop/mydata1.sav"
if (!file.exists(file_path)) stop("فایل پیدا نشد.بررسی مسیر 'file_path'")
df <- haven::read_sav(file_path)
