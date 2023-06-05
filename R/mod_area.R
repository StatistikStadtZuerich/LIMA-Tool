#' area UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#'
#' @importFrom shiny NS tagList 
mod_area_ui <- function(id){
  
  choices_area <- unique(data_vector[["zones"]]$GebietLang)
  choices_price <- unique(data_vector[["zones"]]$PreisreiheLang)
  
  ns <- NS(id)
  tagList(
    sidebarPanel(
      # Area
      sszSelectInput(ns("area"),
                     "Gebietsauswahl",
                     choices = choices_area),
      
      # Price
      sszRadioButtons(ns("price"),
                      "Preise",
                      choices = choices_price),
      
      # Group (conditional to price)
      conditionalPanel(
        condition = 'input.price != "Stockwerkeigentum pro m\u00B2 Wohnungsfläche"',
        sszRadioButtons(ns("group"),
                        "Art",
                        choices = c(
                          "Ganze Liegenschaften",
                          "Stockwerkeigentum",
                          "Alle Verkäufe"
                        )
        ),
      ),
      
      # Action Button
      sszActionButton(
        inputId = ns("buttonStart"),
        label = "Abfrage starten"
      ),
      br()
    )
 
  )
}
    
#' area Server Functions
#'
#' @noRd 
mod_area_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_area_ui("area_1")
    
## To be copied in the server
# mod_area_server("area_1")
