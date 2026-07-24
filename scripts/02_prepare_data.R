library(dplyr)

if ("nback" %in% names(df))
  df <- df %>% rename(Nback_total = nback)

if ("timenback" %in% names(df))
  df <- df %>% rename(RT_ms = timenback)

if ("IQ" %in% names(df))
  df <- df %>% rename(Raven_IQ = IQ)

qcols <- grep("^q\\d+$", names(df), value = TRUE)

if (length(qcols) == 0)
  stop("No item columns found.")
