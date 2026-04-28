#' address_tables UI Function
#'
#' @param id id of the module called in the app
#'
#' @description A shiny Module to render the titles and tables of the apps with the address-architecture
#'
#' @noRd
mod_address_tables_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # title for table
    h2(textOutput(ns("title_table"))),
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
#' @param filter_address filter value (street + nr) selected from input widget
#'
#' @noRd
mod_address_tables_server <- function(id, addresses, series, target_value, filter_address) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Check if data is available for the zone
    data_availability <- reactive({
      req(filter_address())

      data_available(addresses, series, filter_address())
    }) |>
      bindEvent(filter_address())

    # render title if data is available
    output$title_table <- renderText({
      availability <- data_availability()
      if (availability > 0) {
        filtered_addresses <- get_information_address(addresses, series, filter_address(), "Preis")

        paste0(
          "Medianpreise und Handänderungen im Quartier ", filtered_addresses[["district"]],
          ", in der ", filtered_addresses[["zoneBZO16"]], " (bis 2018: ",
          filtered_addresses[["zoneBZO99"]], ")"
        )
      } else {
        NULL
      }
    })

    # Table if data is available for zone
    output$results <- renderReactable({
      availability <- data_availability()
      if (availability > 0) {
        filtered_data <- filter_address_data(addresses, series, target_value, filter_address())

        out <- reactable_address(filtered_data)
        out
      } else {
        NULL
      }
    }) |>
      bindEvent(filter_address())
  })
}

## To be copied in the UI
# mod_address_tables_ui("address_tables_1")

## To be copied in the server
# mod_address_tables_server("address_tables_1")
