# Install and load required packages
    if (!requireNamespace("glmnet",quietly = TRUE)) install.packages("glmnet")
    if (!requireNamespace("boot",quietly = TRUE)) install.packages("boot")
    library(glmnet)
    library(boot)
    
   # Extract EAP estimates and compute EAP reliability
    eap_base_res <- tryCatch(TAM::tam.EAP(mod_eirt),error = function(e) NULL)
    eap_base_theta <- if (!is.null(eap_base_res)) eap_base_res$theta else tryCatch(mod_eirt$person$EAP,error = function(e) NULL)
    eap_base_se    <- if (!is.null(eap_base_res)) eap_base_res$se else rep(NA,length(eap_base_theta))
    
    eap_reliability <- NA
    if (!is.null(eap_base_theta) && !all(is.na(eap_base_se))) {
      eap_reliability <- 1 - mean(eap_base_se^2,na.rm = TRUE) / var(eap_base_theta,na.rm = TRUE)
    }
    cat("EAP reliability (base IRT):",round(eap_reliability,3),"\n")
    
  # Prepare regression dataset (complete cases only)
    preds <- intersect(all_predictors,names(data_neo))  # از متغیرهایی که واقعا در data_neo هست استفاده می‌کنیم
    df_base <- cbind(theta_eap = eap_base_theta,data_neo[,preds,drop = FALSE])
    df_base <- df_base[complete.cases(df_base),]
    cat("N after complete.cases:",nrow(df_base),"\n")
    
  # Fit linear regression on baseline theta (valid reference R²)
    fit_base <- lm(theta_eap ~ .,data = df_base)
    sbase <- summary(fit_base)
    cat("R2 (theta from base IRT):",round(sbase$r.squared,3)," Adj.R2:",round(sbase$adj.r.squared,3),"\n")
    cat("Coefficients:\n"); print(sbase$coefficients)
    
   # Compare R² using theta estimated from the Model 4 latent regression (typically overestimated)
    if ("model4" %in% names(model_results) && !is.null(model_results$model4)) {
      theta_lat4 <- tryCatch(model_results$model4$person$EAP,error = function(e) NULL)
      if (!is.null(theta_lat4)) {
        df_lat4 <- cbind(theta_eap = theta_lat4,data_neo[,preds,drop = FALSE])
        df_lat4 <- df_lat4[complete.cases(df_lat4),]
        fit_lat4 <- lm(theta_eap ~ .,data = df_lat4)
        slat4 <- summary(fit_lat4)
        cat("R2 (theta from tam.latreg model4):",round(slat4$r.squared,3)," Adj.R2:",round(slat4$adj.r.squared,3),"\n")
      }
    }
    
    # Perform 5-fold cross-validation for the linear regression model
    cv_r2_lm <- function(data,formula,K = 5,seed = 123) {
      set.seed(seed)
      n <- nrow(data)
      folds <- sample(rep(1:K,length.out = n))
      preds <- rep(NA,n)
      for (k in 1:K) {
        train <- data[folds != k,,drop = FALSE]
        test  <- data[folds == k,,drop = FALSE]
        fit   <- lm(formula,data = train)
        preds[folds == k] <- predict(fit,newdata = test)
      }
      r2  <- cor(data[[as.character(formula[[2]])]],preds,use = "complete.obs")^2
      rmse <- sqrt(mean((data[[as.character(formula[[2]])]] - preds)^2,na.rm = TRUE))
      list(r2 = r2,rmse = rmse,preds = preds)
    }
    form <- as.formula(paste("theta_eap ~",paste(colnames(df_base)[-1],collapse = " + ")))
    cvres <- cv_r2_lm(df_base,form,K = 5,seed = 42)
    cat("CV R2 (5-fold,lm on base theta):",round(cvres$r2,3)," RMSE:",round(cvres$rmse,3),"\n")
    
   # Perform 5-fold cross-validation using LASSO (glmnet) for comparison
    cv_r2_glmnet <- function(data,yname,K = 5,seed = 123) {
      set.seed(seed)
      n <- nrow(data)
      folds <- sample(rep(1:K,length.out = n))
      preds <- rep(NA,n)
      for (k in 1:K) {
        train <- data[folds != k,,drop = FALSE]
        test  <- data[folds == k,,drop = FALSE]
        ytr <- train[[yname]]
        Xtr <- model.matrix(as.formula(paste(yname,"~ .")),train)[,-1,drop = FALSE]
        Xte <- model.matrix(as.formula(paste(yname,"~ .")),test)[,-1,drop = FALSE]
      # Align predictor matrix columns
        miss <- setdiff(colnames(Xtr),colnames(Xte))
        if (length(miss) > 0) Xte <- cbind(Xte,matrix(0,nrow = nrow(Xte),ncol = length(miss),dimnames = list(NULL,miss)))
        Xte <- Xte[,colnames(Xtr),drop = FALSE]
        cvm <- cv.glmnet(Xtr,ytr,alpha = 1)
        pred <- predict(cvm,s = "lambda.min",newx = Xte)
        preds[folds == k] <- as.numeric(pred)
      }
      r2 <- cor(data[[yname]],preds,use = "complete.obs")^2
      list(r2 = r2,preds = preds)
    }
    glmnet_res <- cv_r2_glmnet(df_base,"theta_eap",K = 5,seed = 42)
    cat("CV R2 (LASSO):",round(glmnet_res$r2,3),"\n")
