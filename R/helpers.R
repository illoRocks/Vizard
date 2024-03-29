#' @import purrr
#' @import dplyr
#'
NULL

#' Parse Parameters
#'
#' Parse Parameters and prepare them for futher computation
#'
#' @param params Parameters for previous modell training
#' @param score Score wich depand on params (same order)
#'
#' @return List of Variables
#' 
#'
#' @export
parse_arguments <- function(params, score) {
  if (inherits(params, "list")) {
    params <- bind_rows(params)
  }
  param_names <- colnames(params)
  column_n <- map_int(params, n_distinct)
  params$score <- score
  metric_name <- deparse(substitute(score))

  list(
    params = params, # must be dataframe or tibble
    column_n = column_n, # must be named vector
    param_names = param_names, # must be vector
    score_name = metric_name # must be character
  )
}

#' Map Paramters
#'
#' Wrapper around map. Itterate over Parameters
#'
#' @param params list generated by parse_arguments.
#' @param .f A function.
#' @param ... Additional arguments passed on to the mapped function.
#'
#' @return A vector the same length as parameters.
#'
#' @export
map_params <- function(params, .f, ..., use_names = T) {
  if (!inherits(params, "list")) {
    # TODO: Check more ctriterias
    golem::message_dev(params)
    stop("`parameter` must be generated by `parse_arguments()`!")
  }

  cols_with_variance <- params$param_names[params$column_n > 1]
  maped <- map(cols_with_variance, .f, ...)
  if (use_names) {
    names(maped) <- cols_with_variance
  }
  maped
}


#' Visualize metric scores
#'
#'
#' @param df Dataframe with parameters and score.
#' @param param_name Name of parameter
#' @param score_name Name of score.
#'
#' @return ggplot element
#'
#' @export
plot_metric_point <- function(df, param_name, score_name) {
  ggplot(df, aes_string(x = param_name, y = "score")) +
    geom_point() +
    labs(y = score_name,
         x=NULL,
         title = param_name) +
    theme(plot.title = element_text(size=22, hjust = .5),
          axis.title.y = element_text(size=15))
}







