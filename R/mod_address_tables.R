#' address_tables UI Function
#'
#' @param id id of the module called in the app
#'
#' @description A shiny Module to render the titles and tables of the apps with the address-architecture
#'
#' @noRd 
mod_address_tables_ui <- function(id){
  ns <- NS(id)
  tagList(
    
    # Table for prices
    shinycssloaders::withSpinner(
      reactableOutput(ns("results")),
      type = 7,
      color = "#0F05A0"
    )
    
 
  )
}
    
#' address_tables Server Functions
#'
#' @param id id of the module called in the app
#' @param addresses dataset addresses
#' @param series dataset series
#' @param target_value target value of the app ("Preis" or "Zahl")
#' @param filter_street filter value (street) selected from input widget
#' @param filter_number filter value (number) selected from input widget
#'
#' @noRd 
mod_address_tables_server <- function(id, addresses, series, target_value, filter_street, filter_number){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
  
    # Check if data is available for the zone
    data_availability <- reactive({
      req(filter_street(), filter_number())
      
      data_available(addresses, series, filter_street(), filter_number())
    }) |> 
      bindEvent(filter_street(), filter_number())
    
    # Table if data is available for zone
    output$results <- renderReactable({
      
      availability <- data_availability()
      if (availability > 0) {
        filtered_data <- filter_address(addresses, series, target_value, filter_street(), filter_number())
        
        out <- reactable_address(filtered_data)
        out
      } else {
        NULL
      }
    }) |> 
      bindEvent(filter_street(), filter_number())
  })
}
    
## To be copied in the UI
# mod_address_tables_ui("address_tables_1")
    
## To be copied in the server
# mod_address_tables_server("address_tables_1")
