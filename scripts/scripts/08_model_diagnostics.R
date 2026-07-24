  fit <- fit_base
    cooks <- cooks.distance(fit)
    influential <- which(cooks > (4 / (nrow (df_base) - length(coef(fit)))))
    cat("Influential obs (Cook's):",if(length(influential)>0) paste(influential,collapse = ",") else "None","\n")
    
    cat("LogLik:",mod_lat$logLik," | AIC:",mod_lat$AIC," | BIC:",mod_lat$BIC,"\n")
    # استخراج theta برای VIF
    theta_eap_model <- mod_lat$person$EAP
    df_lm <- cbind(theta_eap = theta_eap_model,data_neo[,preds,drop = FALSE])
    df_lm <- df_lm[complete.cases(df_lm),]
    lm_check <- lm(theta_eap ~ .,data = df_lm)
    cat("VIF:\n")
    print(car::vif(lm_check))
    cat("\nSummary coefficients:\n")
    print(summary(lm_check)$coefficients)
  }
}

