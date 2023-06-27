#' address UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @import shinyjs
#' @import reactable
#' @import shiny
#' @import icons
#' @import zuericssstyle
#' @importFrom dqshiny autocomplete_input
#' @importFrom shiny NS tagList 
#' @importFrom gtools mixedsort
mod_address_ui <- function(id, choicesapp){
  ### Set up directory for icons
  ssz_icons <- icon_set("inst/app/www/icons/")
  
  ns <- NS(id)
  tagList(
 
    sidebarPanel(
      
      # Street input
      sszAutocompleteInput(
        ns("select_street"),
        "Geben Sie eine Strasse ein",
        choicesapp[["choices_street"]]
        # choices = unique(data_vector[["addresses"]]$StrasseLang)
      ),

      # Number input
      sszSelectInput(
        ns("select_number"),
        "Wählen Sie eine Hausnummer aus",
        choices = choicesapp[["choices_streetnr"]],
        # choices = c("", sort(unique(data_vector[["addresses"]]$Hnr))),
        selected = NULL
      ),
      
      # Action Button
      sszActionButton(
        inputId = ns("start_query"),
        label = "Abfrage starten"
      ),
      br(),
      
      # Downloads
      conditionalPanel(
        condition = "input.select_street && input.select_number && input.start_query",
        ns = ns,
        mod_download_ui(ns("download_3"))
      )
    ),
        
    # Main Panel (results)
    mainPanel(
      br(),
      
      # Info Table
      htmlOutput(ns("results_info")),
      uiOutput(ns("more_info")),
      br(),
      
      # Table for prices
      reactableOutput(ns("Preis_submodul")),
      
      # # Action Link for Hand Changes (counts)
      # useShinyjs(),
      # conditionalPanel(
      #   condition = "input.buttonStartTwo",
      #   tags$div(
      #     id = "linkCountTwoId",
      #     class = "linkCountTwoDiv",
      #     uiOutput("linken")
      #   )
      # ),
      # 
      # # Hidden Table for Hand Changes
      # shinyjs::hidden(
      #   div(
      #     id = "countDivTwo",
      #     reactableOutput("resultsCountSeries")
      #   )
      # ),
      
      
      conditionalPanel(
        condition = "input.select_street && input.select_number && input.start_query",
        ns = ns,
        explanationbox_app2()
      )
    )
  )
}
    
#' address Server Functions
#'
#' @noRd 
mod_address_server <- function(id, data){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # Show Output Info (App 2)
    # Sort for House Number in Drop Down
    observe({
      updateSelectInput(
        session, "select_number",
        choices = data %>%
          filter(StrasseLang == input$select_street) %>%
          pull(Hnr) %>%
          mixedsort()
      )
    })
 
  })
}
    
## To be copied in the UI
# mod_address_ui("address_1")
    
## To be copied in the server
# mod_address_server("address_1")
