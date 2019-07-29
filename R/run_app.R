#' Run the Shiny Application
#' 
#' @param parameters Parameter list
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(parameters = NULL) {
  with_golem_options(
    app = shinyApp(ui = app_ui, server = app_server), 
    golem_opts = list(parameters=parameters)
  )
}


