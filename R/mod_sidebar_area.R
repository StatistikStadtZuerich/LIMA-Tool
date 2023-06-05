#' sidebar_area UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_sidebar_area_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' sidebar_area Server Functions
#'
#' @noRd 
mod_sidebar_area_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_sidebar_area_ui("sidebar_area_1")
    
## To be copied in the server
# mod_sidebar_area_server("sidebar_area_1")
