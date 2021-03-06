% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/method-gridSearch.R
\name{findEncodingDim}
\alias{findEncodingDim}
\alias{findEncodingDim,}
\alias{findInjectZscore}
\title{Find the optimal encoding dimension}
\usage{
findEncodingDim(
  ods,
  params = seq(2, min(100, ncol(ods) - 1, nrow(ods) - 1), 2),
  freq = 0.01,
  zScore = 3,
  sdlog = log(1.6),
  lnorm = TRUE,
  inj = "both",
  ...,
  BPPARAM = bpparam()
)

findInjectZscore(
  ods,
  freq = 0.01,
  zScoreParams = c(seq(1.5, 4, 0.5), "lnorm"),
  encDimParams = c(seq(3, 40, 3), seq(45, 70, 5), 100, 130, 160),
  inj = "both",
  ...,
  BPPARAM = bpparam()
)
}
\arguments{
\item{ods}{An OutriderDataSet}

\item{params, encDimParams}{Set of possible q values.}

\item{freq}{Frequency of outlier, defaults to 1E-2}

\item{zScore, zScoreParams}{Set of possible injection Z-score, defaults to 3.}

\item{sdlog}{Standard deviation of the sitribution on the log scale.}

\item{lnorm}{If TRUE, the default, Z-scores are drawn from a log normal 
distribution with a mean of \code{log(zScore)} in log-scale.}

\item{inj}{Injection strategy, by default 'both'.}

\item{...}{Further arguments passed on to the \code{controlForConfounders}
function.}

\item{BPPARAM}{BPPARAM object by default bpparam().}
}
\value{
The optimal encoding dimension
}
\description{
Finds the optimal encoding dimension for a given data set by running a 
grid search based on the provided parameter set.
}
\examples{
ods <- makeExampleOutriderDataSet()
encDimSearchParams <- c(5, 8, 10, 12, 15)
zScoreParams <- c(2, 3, 5, 'lnorm')
implementation <- 'autoencoder'
register(MulticoreParam(4))
\dontshow{
    ods <- ods[1:12,1:12]
    encDimSearchParams <- c(2)
    zScoreParams <- c('lnorm')
    register(SerialParam())
    implementation <- 'pca'
}
ods1 <- findEncodingDim(ods, params=encDimSearchParams, 
        implementation=implementation)
plotEncDimSearch(ods1)

ods2 <- findInjectZscore(ods, zScoreParams=zScoreParams,
        encDimParams=encDimSearchParams, implementation=implementation)
plotEncDimSearch(ods2)

}
