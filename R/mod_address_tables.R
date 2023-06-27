#' address_tables UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_address_tables_ui <- function(id){
  ns <- NS(id)
  tagList(
    
    # Table for prices
    reactableOutput(ns("results"))
 
  )
}
    
#' address_tables Server Functions
#'
#' @noRd 
mod_address_tables_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_address_tables_ui("address_tables_1")
    
## To be copied in the server
# mod_address_tables_server("address_tables_1")
