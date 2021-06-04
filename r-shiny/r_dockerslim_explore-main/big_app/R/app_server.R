#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # load the built-in data sets
  data(hotshot_data)
  
  # List the first level callModules here
  callModule(mod_hotshot_picker_server, "hotshot_picker_ui_1")


}
