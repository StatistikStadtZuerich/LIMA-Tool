#' toggle UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_toggle_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' toggle Server Functions
#'
#' @noRd 
mod_toggle_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_toggle_ui("toggle_1")
    
## To be copied in the server
# mod_toggle_server("toggle_1")
