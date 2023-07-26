#' address_tables UI Function
#'
#' @param id id of the module called in the app
#'
#' @description A shiny Module to render the titles and tables of the apps with the address-architecture
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
    dataAvailable <- eventReactive(trigger(), {
      
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
    })
    
    # Table if data is available for zone
    outputData <- eventReactive(trigger(), {
      # print(filter_street())
      
      filtered_data <- filter_address(addresses, series, target_value, filter_street(), filter_number())
    })
    
    output$results <- renderReactable({
      
      availability <- dataAvailable()
      if (availability > 0) {
        out <- reactable_address(outputData())
        out
      } else {
        NULL
      }
    })
  })
}
    
## To be copied in the UI
# mod_address_tables_ui("address_tables_1")
    
## To be copied in the server
# mod_address_tables_server("address_tables_1")
