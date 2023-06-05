#' sidebar_address UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_sidebar_address_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' sidebar_address Server Functions
#'
#' @noRd 
mod_sidebar_address_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_sidebar_address_ui("sidebar_address_1")
    
## To be copied in the server
# mod_sidebar_address_server("sidebar_address_1")
