# Module UI
  
#' @title   mod_plot_param_ui and mod_plot_param_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_plot_param
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_plot_param_ui <- function(id){
  ns <- NS(id)
  tagList(
    h2("Metrics"),
    plotOutput(ns("metrics"))
  )
}
    
# Module Server
    
#' @rdname mod_plot_param
#' @export
#' @keywords internal
#' @import ggplot2 gridExtra
#' 
mod_plot_param_server <- function(input, output, session){
  ns <- session$ns
  print(golem::get_golem_options("parameters"))
  output$metrics <- renderPlot({
    parameter <- golem::get_golem_options("parameters")
    print(parameter)
    gg <- map_params(parameter, function(param_name) {
      plot_metric_point(df = parameter$params,
                        param_name = param_name,
                        score_name = parameter$score_name)
      
    }, use_names = F)
    
    
    gg$ncol <- 1
    do.call(grid.arrange, gg)
  })
}
    
## To be copied in the UI
# mod_plot_param_ui("plot_param_ui_1")
    
## To be copied in the server
# callModule(mod_plot_param_server, "plot_param_ui_1")
 
