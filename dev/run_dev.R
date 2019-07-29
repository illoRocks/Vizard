# Set options here
options(golem.app.prod = FALSE) # TRUE = production mode, FALSE = development mode

reload <- function() {
  # Detach all loaded packages and clean your environment
  golem::detach_all_attached()
  # rm(list=ls(all.names = TRUE))

  # Document and reload your package
  golem::document_and_reload()
  
  NULL
}


library(xgboost)
library(tweakr)
library(purrr)
library(ggplot2)
library(gridExtra)

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
# nur parameter, die nicht unique sind

parameter <- parse_arguments(params, auc_scores)

gg <- Vizard::map_params(parameter, use_names = F, .f = function(param_name) {
  
  print(param_name)
  
  plot_metric_point(df = parameter$params,
                    param_name = param_name,
                    score_name = parameter$score_name)
  
})

param_name <- "eta"
plot_metric_point(df = parameter$params, param_name = param_name, score_name = parameter$score_name)

gg$ncol <- 1
gg$padding <- 10
do.call(grid.arrange, gg)


# Run the application
reload()
Vizard::run_app(parameter=parameter)










