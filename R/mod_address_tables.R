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
mod_address_tables_server <- function(id, data, data2, trigger, target_value, filter_street, filter_number){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    stopifnot(!is.reactive(data))
    stopifnot(!is.reactive(data2))
    stopifnot(is.reactive(trigger))
    stopifnot(is.reactive(filter_street))
    stopifnot(is.reactive(filter_number))
    stopifnot(!is.reactive(target_value))
  
    # Check if data is available for the zone
    dataAvailable <- reactive({
      
      filtered_addresses <- get_information_address(data, data2, "Preis", filter_street(), filter_number())
      
      SerieTotal <- bind_rows(filtered_addresses[["SerieBZO16"]], filtered_addresses[["SerieBZO99"]]) %>%
        select(-Typ, -QuarCd, -QuarLang, -ZoneSort, -ZoneLang)
      
      if (nrow(SerieTotal) > 0) {
        available <- 1
      } else {
        avaiable <- 0
      }
    })
    
    # Table if data is available for zone
    outputData <- eventReactive(trigger(), {
      filtered_data <- filter_address(data, data2, target_value, filter_street(), filter_number())
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
