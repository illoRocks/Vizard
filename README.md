
<!-- README.md is generated from README.Rmd. Please edit that file -->
Vizard
======

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental) <!-- badges: end -->

The goal of Vizard is to ...

Installation
------------

You can install the released version of Vizard from [CRAN](https://CRAN.R-project.org) with:

``` r
remotes::install_github("illoRocks/Vizard")
```

Example
-------

This is a basic example which shows you how to solve a common problem:

``` r
library(xgboost)
library(tweakr)
library(purrr)
library(Vizard)

# load data ---------------------------------------------------------------
data(agaricus.train, package = "xgboost")
data(agaricus.test, package = "xgboost")

# choose params -----------------------------------------------------------
params <- paramize(
  list(
    eta.dbl = c(.01, .4),
    max_depth.int = c(1, 3),
    silent = 1, nthread = 2,
    objective = "binary:logistic", eval_metric = "auc"
  ),
  search_len = 10,
  search_method = "random"
)

params <- pmap(params, list)

# train-function ----------------------------------------------------------

train_xgb <- function(param, dtrain, dtest, ...) {
  watchlist <- list(train = dtrain, eval = dtest)
  xgb.train(param, dtrain, nrounds = 3, watchlist, ...)
}

# scores per param set ----------------------------------------------------
dtrain <- xgb.DMatrix(agaricus.train$data, label = agaricus.train$label)
dtest <- xgb.DMatrix(agaricus.test$data, label = agaricus.test$label)

models <- map(params, train_xgb, dtrain = dtrain, dtest = dtest, early_stopping_rounds = 20)
auc_scores <- map_dbl(models, "best_score")

# visulize scores ---------------------------------------------------------
parameter <- parse_arguments(params, auc_scores)
run_app(parameters = parameter)
```
