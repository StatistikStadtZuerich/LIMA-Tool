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
mod_address_tables_server <- function(id, data, data2, target_value, filter_street, filter_number){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    stopifnot(!is.reactive(data))
    stopifnot(!is.reactive(data2))
    stopifnot(is.reactive(filter_street))
    stopifnot(is.reactive(filter_number))
    stopifnot(!is.reactive(target_value))
 
    output$results <- renderReactable({
      
      filtered_data <- filter_address(data, data2, target_value, filter_street(), filter_number())
      
      out <- reactable_address(filtered_data)
      out
    })
    
  })
}
    
## To be copied in the UI
# mod_address_tables_ui("address_tables_1")
    
## To be copied in the server
# mod_address_tables_server("address_tables_1")
