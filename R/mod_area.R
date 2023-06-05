#' area UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @import shinyjs useShinyjs
#' @import reactable
#' @import shiny
#' @import icons
#' @import zuericssstyle
#' @importFrom shiny NS tagList 
mod_area_ui <- function(id){
  ### Set up directory for icons
  ssz_icons <- icon_set("inst/app/www/icons/")
  
  ### Set unique choices
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
      br(),
      
      # Downloads
      mod_download_ui("download_1")
    ),
    # Main Panel (Results)
    mainPanel(
      
      # Table Title (prices)
      tags$div(
        id = "title_id",
        class = "title_div",
        textOutput("title")
      ),
      conditionalPanel(
        condition = "input.buttonStart",
        hr()
      ),
      
      # Table Subtitle (prices)
      tags$div(
        id = "subtitle_id",
        class = "subtitle_div",
        textOutput("subtitle")
      ),
      
      # Table Subsubtitle (prices)
      tags$div(
        id = "subSubtitle_id",
        class = "subSubtitle_div",
        textOutput("subSubtitle")
      ),
      
      # Title for BZO16 (prices)
      tags$div(
        id = "tableTitle16_id",
        class = "tableTitle_div",
        textOutput("tableTitle16")
      ),
      
      # Table for BZO 16 (prices)
      reactableOutput("resultsPrice16"),
      
      # title for BZO99 (prices)
      tags$div(
        id = "tableTitle99_id",
        class = "tableTitle_div",
        textOutput("tableTitle99")
      ),
      
      # Table for BZO 99 (prices)
      reactableOutput("resultsPrice99"),
      
      # Action Link for Hand Changes (counts)
      useShinyjs(),
      conditionalPanel(
        condition = "input.buttonStart",
        tags$div(
          class = "linkCount",
          actionLink("linkCount",
                     "Anzahl Handänderungen einblenden",
                     icon = icon("angle-down")
          )
        )
      ),
      
      
      # Hidden Titles and Tables for Hand Changes
      shinyjs::hidden(
        div(
          id = "countDiv",
          
          # Title for BZO16 (counts)
          tags$div(
            id = "tableTitleTwo16_id",
            class = "tableTitle_div",
            textOutput("tableTitleTwo16")
          ),
          
          # Table for BZO16 (counts)
          reactableOutput("resultsCount16"),
          
          # Title for BZO99 (counts)
          tags$div(
            id = "tableTitleTwo99_id",
            class = "tableTitle_div",
            textOutput("tableTitleTwo99")
          ),
          
          # Table for BZO99 (counts)
          reactableOutput("resultsCount99")
        )
      ),
      conditionalPanel(
        condition = "input.buttonStart",
        tags$div(
          class = "infoDiv",
          h5("Erklärung Zonenarten"),
          hr(),
          p("Z = Zentrumszone"),
          p("K = Kernzone"),
          p("Q = Quartiererhaltungszone"),
          p("W2 = Wohnzone 2"),
          p("W3 = Wohnzone 3"),
          p("W4 = Wohnzone 4"),
          p("W5 = Wohnzone 5")
        )
      )
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
