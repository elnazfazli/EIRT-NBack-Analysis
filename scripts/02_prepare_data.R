# ============================================================
# Prepare dataset
# Rename variables
# Identify N-back item columns
# ============================================================
if ("nback" %in% names(df)) df <- df %>% rename(Nback_total = nback)
if ("timenback" %in% names(df)) df <- df %>% rename(RT_ms = timenback)
if ("IQ" %in% names(df)) df <- df %>% rename(Raven_IQ = IQ)

# Identify item response variables
qcols <- grep("^q\\d+$",names(df),value = TRUE)
if (length(qcols) == 0) stop("No variables with prefix 'q' found.")

to_numeric_safe <- function(x) as.numeric(as.character(x))
find_col_for_number <- function(num,df,prefixes = c("Neo","NEO","neo","q")) {
  for (p in prefixes) {
    nm <- paste0(p,num)
    if (nm %in% names(df)) return(nm)
  }
  return(NA_character_)
}
