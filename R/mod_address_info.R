#' address_info UI Function
#'
#' @param id id of the module called in the app
#'
#' @description A shiny Module to display further reactive information in the app with the address-architecture
#'
#' @noRd 
mod_address_info_ui <- function(id){
  ns <- NS(id)
  tagList(
 
    # Information about selection
    reactableOutput(ns("results_info")),
    
    uiOutput(ns("more_info"))
    
  )
}
    
#' address_info Server Functions
#'
#' @param id id of the module called in the app
#' @param addresses dataset addresses
#' @param series dataset series
#' @param filter_street filter value (street) selected from input widget
#' @param filter_number filter value (number) selected from input widget
#'
#' @noRd 
mod_address_info_server <- function(id, addresses, series, filter_street, filter_number){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    stopifnot(!is.reactive(addresses))
    stopifnot(!is.reactive(series))
    stopifnot(is.reactive(filter_street))
    stopifnot(is.reactive(filter_number))

    
    # Show Output Information Address
    output$results_info <- renderReactable({
      req(data_availability())
      filter_address_info(addresses, filter_street(), filter_number())
    }) %>%
      bindEvent(filter_street(), filter_number())
    
    # Get Information if Data Frame is empty
    data_availability <- reactive({
      req(filter_street(), filter_number())
      
      data_available(addresses, series, filter_street(), filter_number())
    }) %>%
      bindEvent(filter_street(), filter_number())

    # Reactive Info
    info_reactive <- reactive({
      req(data_availability())
      
      availability <- data_availability()
      display_info(availability, addresses, series, filter_street(), filter_number())
        
    }) %>%
      bindEvent(filter_street(), filter_number())

    # Show Info (App 2)
    output$more_info <- renderUI({
      ### Set up directory for icons
      ssz_icons <- icon_set("inst/app/www/icons/")
      
      availability <- data_availability()
      if (availability > 0) {
        tags$div(
          class = "info_div",
          info_reactive()
        )
      } else {
        tags$div(
          class = "info_na_div",
          tags$div(
            class = "info_na_icon",
            img(ssz_icons$`warning`)
          ),
          tags$div(
            class = "info_na_text",
            h6("Achtung"),
            info_reactive()
          )
        )
      }
    })
  })
}
    
## To be copied in the UI
# mod_address_info_ui("address_info_1")
    
## To be copied in the server
# mod_address_info_server("address_info_1")
