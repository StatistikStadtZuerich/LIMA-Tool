#' explanationbox UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_explanationbox_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' explanationbox Server Functions
#'
#' @noRd 
mod_explanationbox_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_explanationbox_ui("explanationbox_1")
    
## To be copied in the server
# mod_explanationbox_server("explanationbox_1")
