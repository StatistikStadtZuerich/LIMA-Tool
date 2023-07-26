#' toggle UI Function
#'
#' @param id filter value (street) selected from input widget
#'
#' @description A shiny Module for the toggle to have the option to show more information on click
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
#' @param id filter value (street) selected from input widget
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
