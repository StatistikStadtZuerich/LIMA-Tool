#' address UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_address_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' address Server Functions
#'
#' @noRd 
mod_address_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_address_ui("address_1")
    
## To be copied in the server
# mod_address_server("address_1")
