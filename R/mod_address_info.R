#' address_info UI Function
#'
#' @param id id of the module called in the app
#'
#' @description A shiny Module to display further reactive information in the app with the address-architecture
#'
#' @noRd
mod_address_info_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # Information about selection
    card(
      # height = "auto",
      card_header(h3(textOutput(ns("title")))),
      card_body(
        tags$ul(
          class = "dashed-list",
          HTML(paste("Quartier:", "<span class='bold-text'>", textOutput(ns("quar")), "</span>")),
        ),
        tags$ul(
          class = "dashed-list",
          HTML(paste("Zone:", "<span class='bold-text'>", textOutput(ns("zone")), "</span>")),
        )
      )
    )
  )
}

#' address_info Server Functions
#'
#' @param id id of the module called in the app
#' @param selected_address dataset addresses, already filtered according to selection
#' @param series dataset series
#'
#' @noRd
mod_address_info_server <- function(id, selected_address, series) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$title <- renderText({
      selected_address()$Adresse
    })

    output$quar <- renderText({
      selected_address()$QuarLang
    })
    output$zone <- renderText({
      selected_address()$Zones
    })
  })
}

## To be copied in the UI
# mod_address_info_ui("address_info_1")

## To be copied in the server
# mod_address_info_server("address_info_1")
