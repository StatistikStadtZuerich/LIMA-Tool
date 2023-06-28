#' address_info UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
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
    htmlOutput(ns("results_info"))
    
    # uiOutput(ns("more_info"))
    
  )
}
    
#' address_info Server Functions
#'
#' @noRd 
mod_address_info_server <- function(id, data, data2, filter_street, filter_number){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
    # Get Information of Address
    infosReactive <- reactive({
      req(filter_street)
      req(filter_number)
      
      infosFiltered <- data %>%
        filter(StrasseLang == filter_street & Hnr == filter_number) %>%
        mutate(Adresse = paste0(StrasseLang, " ", Hnr)) %>%
        select(Adresse, QuarLang, Zones) %>%
        mutate(pivot = 1) %>%
        pivot_longer(!pivot) %>%
        mutate(name = case_when(
          name == "Adresse" ~ "Die Adresse",
          name == "QuarLang" ~ "liegt im Quartier",
          name == "Zones" ~ "in folgender Zone"
        )) %>%
        select(-pivot) %>%
        kable("html",
              align = "lr",
              col.names = NULL
        ) %>%
        kable_styling(bootstrap_options = c("condensed"))
      infosFiltered
    })
    
    # Show Output Information Address
    output$results_info <- renderText({
      outInfos <- infosReactive()
      outInfos
    })
    
    # # Get Information if Data Frame is empty
    # dataAvailable <- reactive({
    #   req(filter_street)
    #   req(filter_number)
    #   # Pull district
    #   district <- data %>%
    #     filter(StrasseLang == filter_street & Hnr == filter_number) %>%
    #     pull(QuarLang)
    #   
    #   # Pull zone BZO16
    #   zoneBZO16 <- data %>%
    #     filter(StrasseLang == filter_street & Hnr == filter_number) %>%
    #     pull(ZoneBZO16Lang)
    #   
    #   # Pull zone BZO99
    #   zoneBZO99 <- data %>%
    #     filter(StrasseLang == filter_street & Hnr == filter_number) %>%
    #     pull(ZoneBZO99Lang)
    #   
    #   # Price serie BZO16
    #   priceSerieBZO16 <- data2 %>%
    #     filter(
    #       QuarLang == district & ZoneLang == zoneBZO16,
    #       Typ == "Preis",
    #       Jahr >= 2019
    #     )
    #   
    #   # Price serie BZO99
    #   priceSerieBZO99 <- data2 %>%
    #     filter(
    #       QuarLang == district & ZoneLang == zoneBZO99,
    #       Typ == "Preis",
    #       Jahr < 2019
    #     )
    #   
    #   # Total series
    #   priceSerieTotal <- bind_rows(priceSerieBZO16, priceSerieBZO99) %>%
    #     select(-Typ, -QuarCd, -QuarLang, -ZoneSort, -ZoneLang)
    #   
    #   if (nrow(priceSerieTotal) > 0) {
    #     available <- 1
    #   } else {
    #     avaiable <- 0
    #   }
    # })
    # 
    # # Reactive Info
    # infoReactive <- reactive({
    #   req(filter_street)
    #   req(filter_number)
    #   
    #   availability <- dataAvailable()
    #   if (availability > 0) {
    #     district <- data %>%
    #       filter(StrasseLang == filter_street & Hnr == filter_number) %>%
    #       pull(QuarLang)
    #     zoneBZO16 <- data %>%
    #       filter(StrasseLang == filter_street & Hnr == filter_number) %>%
    #       pull(ZoneBZO16Lang)
    #     zoneBZO99 <- data %>%
    #       filter(StrasseLang == filter_street & Hnr == filter_number) %>%
    #       pull(ZoneBZO99Lang)
    #     zones <- paste0(zoneBZO16, " (bis 2018: ", zoneBZO99, ")")
    #     infoTitle <- paste0("Medianpreise und Handänderungen im Quartier ", district, ", in der ", zones)
    #   } else {
    #     infoTitle <- paste0("Die gewünschte Adresse liegt nicht in einer Wohn- oder Mischzone (Kernzone, Zentrumszone, Quartiererhaltungszone).\nWählen Sie eine andere Adresse und machen Sie eine erneute Abfrage.")
    #   }
    # })
    # 
    # # Show Info (App 2)
    # output$more_info <- renderUI({
    #   availability <- dataAvailable()
    #   if (availability > 0) {
    #     tags$div(
    #       class = "info_div",
    #       infoReactive()
    #     )
    #   } else {
    #     tags$div(
    #       class = "info_na_div",
    #       tags$div(
    #         class = "info_na_icon",
    #         img(ssz_icons$`warning`)
    #       ),
    #       tags$div(
    #         class = "info_na_text",
    #         h6("Achtung"),
    #         infoReactive()
    #       )
    #     )
    #   }
    # })
    # 
    
    
    
  })
}
    
## To be copied in the UI
# mod_address_info_ui("address_info_1")
    
## To be copied in the server
# mod_address_info_server("address_info_1")
