    if (!requireNamespace("glmnet",quietly = TRUE)) install.packages("glmnet")
    if (!requireNamespace("boot",quietly = TRUE)) install.packages("boot")
    library(glmnet)
    library(boot)
    
    # --- 1.EAP  (mod_eirt) و EAP reliability ---
    eap_base_res <- tryCatch(TAM::tam.EAP(mod_eirt),error = function(e) NULL)
    eap_base_theta <- if (!is.null(eap_base_res)) eap_base_res$theta else tryCatch(mod_eirt$person$EAP,error = function(e) NULL)
    eap_base_se    <- if (!is.null(eap_base_res)) eap_base_res$se else rep(NA,length(eap_base_theta))
    
    eap_reliability <- NA
    if (!is.null(eap_base_theta) && !all(is.na(eap_base_se))) {
      eap_reliability <- 1 - mean(eap_base_se^2,na.rm = TRUE) / var(eap_base_theta,na.rm = TRUE)
    }
    cat("EAP reliability (base IRT):",round(eap_reliability,3),"\n")
    
