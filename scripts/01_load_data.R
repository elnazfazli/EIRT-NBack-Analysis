library(haven)

file_path <- "data/mydata1.sav"

if (!file.exists(file_path))
  stop("Dataset not found.")

df <- read_sav(file_path)
