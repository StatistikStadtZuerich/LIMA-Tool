#' address_info UI Function
#'
#' @param id id of the module called in the app
#'
#' @description A shiny Module to display further reactive information in the app with the address-architecture
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList htmlOutput
#' @importFrom tidyr pivot_longer
#' @importFrom knitr kable
#' @importFrom kableExtra kable_styling
#' @import dplyr
mod_address_info_ui <- function(id){
  ns <- NS(id)
  tagList(
 
    # Information about selection
    htmlOutput(ns("results_info")),
    
    uiOutput(ns("more_info"))
    
  )
}
    
#' address_info Server Functions
#'
#' @param id id of the module called in the app
#' @param addresses dataset addresses
#' @param series dataset series
#' @param trigger target value of the app ("Preis" or "Zahl")
#' @param filter_street filter value (street) selected from input widget
#' @param filter_number filter value (number) selected from input widget
#'
#' @noRd 
mod_address_info_server <- function(id, addresses, series, trigger, filter_street, filter_number){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    stopifnot(!is.reactive(addresses))
    stopifnot(!is.reactive(series))
    stopifnot(is.reactive(trigger))
    stopifnot(is.reactive(filter_street))
    stopifnot(is.reactive(filter_number))

    
    # Show Output Information Address
    dataInfo <- eventReactive(trigger(), {
      filtered_data <- addresses %>%
        filter(StrasseLang == filter_street() & Hnr == filter_number()) %>%
        mutate(Adresse = paste0(StrasseLang, " ", Hnr)) %>%
        select(Adresse, QuarLang, Zones) %>%
        mutate(pivot = 1) %>%
        pivot_longer(!pivot) %>%
        mutate(name = case_when(
          name == "Adresse" ~ "Die Adresse",
          name == "QuarLang" ~ "liegt im Quartier",
          name == "Zones" ~ "in folgender Zone"
        )) %>%
        select(-pivot)
      filtered_data
    })
    output$results_info <- renderText({
      dataInfo() %>%
        kable("html",
              align = "lr",
              col.names = NULL
        ) %>%
        kable_styling(bootstrap_options = c("condensed"))
    })
    
    # Get Information if Data Frame is empty
    dataAvailable <- eventReactive(trigger(), {
      
      filtered_addresses <- get_information_address(addresses, series, filter_street(), filter_number(), "Preis")

      # Total series
      priceSerieTotal <- bind_rows(filtered_addresses[["SerieBZO16"]], filtered_addresses[["SerieBZO99"]]) %>%
        select(-Typ, -QuarCd, -QuarLang, -ZoneSort, -ZoneLang)

      if (nrow(priceSerieTotal) > 0) {
        available <- 1
      } else {
        avaiable <- 0
      }
    })

    # Reactive Info
    infoReactive <- eventReactive(trigger(), {

      availability <- dataAvailable()
      if (availability > 0) {
        filtered_addresses <- get_information_address(addresses, series, filter_street(), filter_number(), "Preis")

        zones <- paste0(filtered_addresses[["zoneBZO16"]], " (bis 2018: ", filtered_addresses[["zoneBZO99"]], ")")
        infoTitle <- paste0("Medianpreise und Handänderungen im Quartier ", filtered_addresses[["district"]], ", in der ", zones)
      } else {
        infoTitle <- paste0("Die gewünschte Adresse liegt nicht in einer Wohn- oder Mischzone (Kernzone, Zentrumszone, Quartiererhaltungszone).\nWählen Sie eine andere Adresse und machen Sie eine erneute Abfrage.")
      }
    })

    # Show Info (App 2)
    output$more_info <- renderUI({
      ### Set up directory for icons
      ssz_icons <- icon_set("inst/app/www/icons/")
      
      availability <- dataAvailable()
      if (availability > 0) {
        tags$div(
          class = "info_div",
          infoReactive()
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
            infoReactive()
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
