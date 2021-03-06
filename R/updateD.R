#'
#' Update D function
#' 
#' @noRd
updateD <- function(ods, control, BPPARAM, verbose){
    D <- D(ods)
    b <- b(ods)
    H <- H(ods)
    k <- t(counts(ods))
    sf <- sizeFactors(ods)
    sMask <- sampleExclusionMask(ods, aeMatrix=TRUE)
    theta <- theta(ods)
    thetaC <- thetaCorrection(ods)
    
    # run fits
    fitls <- bplapply(seq_len(nrow(ods)), singleDFit, D=D, b=b, k=k, sf=sf, H=H,
            theta=theta, mask=sMask, control=control, thetaC=thetaC, 
            BPPARAM=BPPARAM)
    
    # extract infos
    parMat <- vapply(fitls, '[[', double(ncol(D) + 1), 'par')
    mcols(ods)['FitDMessage'] <- vapply(fitls, '[[', 'text', 'message')
    mcols(ods)[,'NumConvergedD'] <- mcols(ods)[,'NumConvergedD'] + grepl(
            "CONVERGENCE: REL_REDUCTION_OF_F .. FACTR.EPSMCH", 
            mcols(ods)[,'FitDMessage'])
    
    if(isTRUE(verbose)){
        print(table(mcols(ods)[,'FitDMessage']))
    }
    
    # update b and D 
    b(ods) <- parMat[1,]
    D(ods) <- t(parMat)[,-1]
    metadata(ods)[['Dfits']] <- fitls
    
    return(ods)
}


singleDFit <- function(i, D, b, k, theta, mask, control, ...){
    pari <- c(b[i], D[i,])
    ki <- k[,i]
    thetai <- theta[i]
    maski <- mask[i,]
    
    fit <- optim(pari, fn=truncLogLiklihoodD, gr=gradientD, 
            k=ki, theta=thetai, exclusionMask=maski, ..., control=control,
            lower=-100, upper=100, method='L-BFGS')

    return(fit)
}

