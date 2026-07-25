# Fit the Explanatory Item Response Theory (EIRT) model
mod_eirt <- TAM::tam.mml(resp = resp_mat,irtmodel = "EPCM",Q = Q_matrix,
                         control = list(conv = 0.001,snodes = 500,maxiter = 500,verbose = TRUE))

theta_wle <- tryCatch({ TAM::tam.wle(mod_eirt)$theta },error = function(e) { NULL })
theta_eap <- tryCatch({ TAM::tam.EAP(mod_eirt)$theta },error = function(e) { NULL })
