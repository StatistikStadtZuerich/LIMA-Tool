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
#' @param selected_address dataset addresses filtered according to input
#' @param series dataset series
#' @param target_value target value of the app ("Preis" or "Zahl")
#'
#' @noRd
mod_address_tables_server <- function(id, selected_address, series, target_value, data_available) {
  moduleServer(id, function(input, output, session) {
    stopifnot(is.reactive(selected_address), is.reactive(data_available))
    stopifnot(!is.reactive(series), !is.reactive(target_value))
    ns <- session$ns

    # render title if data is available
    output$title_table <- renderText({
      req(nrow(selected_address()) > 0, data_available())
      filtered_addresses <- get_information_address(selected_address(), series, "Preis")

      paste0(
        "Medianpreise und Handänderungen im Quartier ", filtered_addresses[["district"]],
        ", in der ", filtered_addresses[["zoneBZO16"]], " (bis 2018: ",
        filtered_addresses[["zoneBZO99"]], ")"
      )
    })

    # Table if data is available for zone
    output$results <- renderReactable({
      req(nrow(selected_address()) > 0, data_available())
      filtered_data <- filter_address_data(selected_address(), series, target_value)
      reactable_address(filtered_data)
    })
  })
}

## To be copied in the UI
# mod_address_tables_ui("address_tables_1")

## To be copied in the server
# mod_address_tables_server("address_tables_1")
