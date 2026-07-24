resp_mat <- as.matrix(sapply(df[,qcols,drop = FALSE],to_numeric_safe))
Q_matrix <- matrix(1,nrow = ncol(resp_mat),ncol = 1)
data_neo <- data_neo %>%
  mutate(RT_ms_log = log(RT_ms)) %>%     
  mutate(RT_ms_z = scale(RT_ms_log))     

z_targets <- intersect(c("NEO_N","NEO_E","NEO_O","NEO_A","NEO_C","Raven_IQ","RT_ms"),names(data_neo))
data_neo <- data_neo %>% mutate(across(all_of (z_targets),~ as.numeric(scale(.x)),.names = "{.col}_z"))
for (scale in c("NEO_N","NEO_E","NEO_O","NEO_A","NEO_C")) {
  zname <- paste0(scale,"_z")
  if (zname %in% names(data_neo) & "Raven_IQ_z" %in% names(data_neo)) {
    intname <- paste0(scale,"_x_Raven")
    data_neo[[intname]] <- data_neo[[zname]] * data_neo$Raven_IQ_z
  }
}
neo_z <- paste0(c("NEO_N","NEO_E","NEO_O","NEO_A","NEO_C"),"_z")
interact_z <- paste0(c("NEO_N","NEO_E","NEO_O","NEO_A","NEO_C"),"_x_Raven")
main_predictors <- c("Raven_IQ_z","RT_ms_z")
all_predictors <- c(neo_z,main_predictors,interact_z)
