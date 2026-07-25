neo_items_nums <- list(
  neuroticism    = c(46,31,16,1,51,36,21,6,56,41,26,11),
  extraversion   = c(47,32,17,2,52,37,22,7,57,42,27,12),
  openness       = c(48,33,18,3,53,38,23,8,58,43,28,13),
  agreeableness  = c(49,34,19,4,54,39,24,9,59,44,29,14),
  conscientiousness = c(50,35,20,5,55,40,25,10,60,45,30,15)
)

reverse_items_nums <- list(
  neuroticism    = c(51,36,21,6,56,41,26,11),
  extraversion   = c(47,32,17,2,52,37,22,7),
  openness       = c(3,53,38,8,58,43,13),
  agreeableness  = c(49,34,4,29),
  conscientiousness = c(50,35,20,5,40,25,10,60)
)

data_neo <- df
for (scale in names(reverse_items_nums)) {
  nums <- reverse_items_nums[[scale]]
  found_cols <- vapply(nums,FUN.VALUE = character(1),FUN = function(n) find_col_for_number(n,data_neo))
  found_cols <- na.omit(found_cols)
  if (length(found_cols) > 0) {
    data_neo[found_cols] <- lapply(data_neo[found_cols],function(x) {
      xnum <- to_numeric_safe(x)
      ifelse (is.na(xnum),NA_real_,4 - xnum)
    })
  }
}

for (scale in names(neo_items_nums)) {
  nums <- neo_items_nums[[scale]]
  cols <- vapply(nums,FUN.VALUE = character(1),FUN = function(n) find_col_for_number(n,data_neo))
  present <- !is.na(cols)
  cols_found <- cols[present]
  scale_name <- switch(scale,
                       neuroticism = "NEO_N",
                       extraversion = "NEO_E",
                       openness = "NEO_O",
                       agreeableness = "NEO_A",
                       conscientiousness = "NEO_C")
  if (length(cols_found) > 0) {
    data_neo[cols_found] <- lapply(data_neo[cols_found],to_numeric_safe)
    data_neo[[scale_name]] <- rowSums(data_neo[cols_found],na.rm = FALSE)
  } else {
    data_neo[[scale_name]] <- NA_real_
  }
}
