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
    ),
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
mod_address_info_server <- function(id, addresses, series, filter_street, filter_number) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Get Information if Data Frame is available or empty
    data_availability <- reactive({
      req(filter_street(), filter_number())

      data_available(addresses, series, filter_street(), filter_number())
    }) |>
      bindEvent(filter_street(), filter_number())

    # Show Output Information Address
    address_info <- reactive({
      req(data_availability())
      addresses |>
        filter(StrasseLang == filter_street() & Hnr == filter_number()) |>
        mutate(Adresse = paste0(StrasseLang, " ", Hnr)) |>
        select(Adresse, QuarLang, Zones)
    })
    output$title <- renderText({
      req(data_availability())
      address_info()$Adresse
    })

    output$quar <- renderText({
      req(data_availability())
      address_info()$QuarLang
    })
    output$zone <- renderText({
      req(data_availability())
      address_info()$Zones
    })

    # Show Infobox if data not available
    output$more_info <- renderUI({
      availability <- data_availability()
      if (availability > 0) {
        NULL
      } else {
        sszInfoBox(
          title = "Hinweis",
          text = paste0(
            "Die gewünschte Adresse liegt nicht in einer Wohn- oder Mischzone (Kernzone, Zentrumszone, Quartiererhaltungszone).",
            "\nWählen Sie eine andere Adresse und machen Sie eine erneute Abfrage."
          ),
          icon = icons_stzh()("info-help-filled")
        )
      }
    })
  })
}

## To be copied in the UI
# mod_address_info_ui("address_info_1")

## To be copied in the server
# mod_address_info_server("address_info_1")
