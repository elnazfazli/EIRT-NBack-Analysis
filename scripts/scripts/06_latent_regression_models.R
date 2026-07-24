models_list <- list(
  model1 = neo_z,                               # فقط NEO
  model2 = c(neo_z,"Raven_IQ_z"),             # NEO + Raven
  model3 = c(neo_z,"Raven_IQ_z","RT_ms_z"),# NEO + Raven + RT
  model4 = all_predictors                        # مدل کامل با تعامل‌ها
)

model_results <- list()
for (mname in names(models_list)) {
  preds <- intersect(models_list[[mname]],names(data_neo))
  formulaY <- as.formula (paste("~",paste(preds,collapse = " + ")))
  cat("\n--- اجرای",mname,"---\n")
  mod_lat <- tryCatch({
    TAM::tam.latreg(like = mod_eirt$like,theta = mod_eirt$theta,Y = mod_eirt$Y,
                    formulaY = formulaY,dataY = data_neo,
                    control = list(maxnodes = 21,verbose = FALSE))
  },error = function (e) { message("خطا در ",mname,": ",e$message); NULL })
  if (!is.null(mod_lat)) {
    model_results[[mname]] <- mod_lat
