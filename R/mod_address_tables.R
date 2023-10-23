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
#' @param trigger reactive trigger input to render the output
#' @param target_value target value of the app ("Preis" or "Zahl")
#' @param filter_street filter value (street) selected from input widget
#' @param filter_number filter value (number) selected from input widget
#'
#' @noRd 
mod_address_tables_server <- function(id, addresses, series, trigger, target_value, filter_street, filter_number){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    stopifnot(!is.reactive(addresses))
    stopifnot(!is.reactive(series))
    stopifnot(is.reactive(trigger))
    stopifnot(is.reactive(filter_street))
    stopifnot(is.reactive(filter_number))
    stopifnot(!is.reactive(target_value))
  
    # Check if data is available for the zone
    dataAvailable <- reactive({
      
      filtered_addresses <- get_information_address(addresses, series, filter_street(), filter_number(), "Preis")
      
      SerieTotal <- bind_rows(filtered_addresses[["SerieBZO16"]], filtered_addresses[["SerieBZO99"]]) %>%
        select(-Typ, -QuarCd, -QuarLang, -ZoneSort, -ZoneLang)
      
      available <- 0
      
      if (nrow(SerieTotal) > 0) {
        available <- 1
      } else {
        available <- 0
      }
      
      print(available)
    }) %>%
      bindEvent(trigger())
    
    # Table if data is available for zone
    output$results <- renderReactable({
      filtered_data <- filter_address(addresses, series, target_value, filter_street(), filter_number())
      
      availability <- dataAvailable()
      if (availability > 0) {
        out <- reactable_address(filtered_data)
        out
      } else {
        NULL
      }
    }) %>%
      bindEvent(trigger())
  })
}
    
## To be copied in the UI
# mod_address_tables_ui("address_tables_1")
    
## To be copied in the server
# mod_address_tables_server("address_tables_1")
