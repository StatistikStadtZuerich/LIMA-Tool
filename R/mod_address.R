#' address UI Function
#'
#' @param id id of the module called in the app
#' @param choicesapp choices that are selectable in the input widget
#'
#' @description A shiny Module to render the app (address) with the app-architecture 'address'
#'
#' @noRd
mod_address_ui <- function(id, choicesapp) {
  ns <- NS(id)
  tagList(
    # Select input for address
    sszAutocompleteInput(
      ns("address"),
      "Geben Sie eine Adresse ein",
      choicesapp$choices_address,
      create = TRUE
    ),

    # Action Button
    conditionalPanel(
      condition = "input.start_query == 0",
      ns = ns,
      sszActionButton(
        inputId = ns("start_query"),
        label = "Abfrage starten"
      )
    ),
    br(),

    # Results (only show if available)
    conditionalPanel(
      condition = "input.start_query && output.show_panel",
      ns = ns,
      tags$div(
        class = "button-div",
        mod_download_ui(ns("download_3"))
      ),
      br(),
      mod_address_info_ui(ns("address_info")),
      br(),
      mod_address_tables_ui(ns("Preis_submodul")),

      # Action Link for Hand Changes (counts)
      tags$div(
        class = "linkCount",
        actionLink(ns("linkCount"),
          "Anzahl Handänderungen einblenden",
          icon = icons_stzh()("angle-down")
        ),

        # Hidden Titles and Tables for Hand Changes
        conditionalPanel(
          condition = "input.linkCount % 2 == 1",
          ns = ns,
          mod_address_tables_ui(ns("Zahl_submodul"))
        ),
        explanationbox_app3()
      )
    ),
    # Infobox if no results available
    uiOutput(ns("more_info"))
  )
}

#' address Server Functions
#'
#' @param id id of the module called in the app
#' @param addresses dataset addresses
#' @param series dataset series
#'
#' @noRd
mod_address_server <- function(id, addresses, series) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # filter address dataset according to input
    addresses_filtered <- reactive({
      # only evaluate after action button has been clicked
      req(input$start_query)
      addresses |>
        filter(Adresse == input$address)
    })

    # check if the address was valid/we have data available for this address
    zones_ready <- reactive({
      # make sure we return false if no button pressed yet / wrong address
      if (!isTruthy(input$start_query) | (nrow(addresses_filtered()) == 0)) {
        return(FALSE)
      }
      zone_available(addresses_filtered(), series)
    })

    # Expose to conditionalPanel
    output$show_panel <- zones_ready
    outputOptions(output, "show_panel", suspendWhenHidden = FALSE)

    # render Infobox as required
    observe({
      req(input$start_query, addresses_filtered())

      data_ready <- zones_ready()

      if (nrow(addresses_filtered()) == 0) {
        # address does not exist
        output$more_info <- renderUI({
          sszInfoBox(
            title = "Hinweis",
            text = paste0(
              "Die gewünschte Adresse existiert nicht.",
              "\nWählen Sie eine andere Adresse und machen Sie eine erneute Abfrage."
            ),
            icon = icons_stzh()("info-help-filled")
          )
        })
      } else {
        # address exists
        if (data_ready == 1) {
          # data available
          output$more_info <- renderUI({
            NULL
          })
        } else if ((data_ready == 0)) {
          # zone data not availabledata_readydata_readydata_ready
          output$more_info <- renderUI({
            sszInfoBox(
              title = "Hinweis",
              text = paste0(
                "Die gewünschte Adresse liegt nicht in einer Wohn- oder Mischzone (Kernzone, Zentrumszone, Quartiererhaltungszone).",
                "\nWählen Sie eine andere Adresse und machen Sie eine erneute Abfrage."
              ),
              icon = icons_stzh()("info-help-filled")
            )
          })
        }
      }
    })

    mod_address_info_server(
      id = "address_info",
      selected_address = addresses_filtered,
      series = series
    )

    mod_address_tables_server(
      id = "Preis_submodul",
      selected_address = addresses_filtered,
      series = series,
      target_value = "Preis",
      data_available = zones_ready
    )

    observe({
      if (input$linkCount %% 2 == 1) {
        txt <- "Anzahl Handänderungen verbergen"
        updateActionLink(session, "linkCount", label = txt, icon = icons_stzh()("angle-up"))
        shinyjs::addClass("linkCount", "visitedLink")
      } else {
        txt <- "Anzahl Handänderungen einblenden"
        updateActionLink(session, "linkCount", label = txt, icon = icons_stzh()("angle-down"))
        shinyjs::removeClass("linkCount", "visitedLink")
      }
    }) |>
      bindEvent(input$linkCount)

    mod_address_tables_server(
      id = "Zahl_submodul",
      selected_address = addresses_filtered,
      series = series,
      target_value = "Zahl",
      data_available = zones_ready
    )

    mod_download_server(
      id = "download_3",
      filter_function = filter_address_download,
      static_parameters = list(
        "addresses" = addresses,
        "series" = series
      ),
      reactive_parameters = list(
        filter_address = reactive(input$address)
      ),
      filter_app = 3
    )
  })
}

## To be copied in the UI
# mod_address_ui("address_1")

## To be copied in the server
# mod_address_server("address_1")
