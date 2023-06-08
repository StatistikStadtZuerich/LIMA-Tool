#' area UI Function
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
#' @importFrom shiny NS tagList
library(shinyjs) 
mod_area_ui <- function(id, data){
  ### Set up directory for icons
  ssz_icons <- icon_set("inst/app/www/icons/")
  
  ### Set unique choices
  choices_area <- unique(data$GebietLang)
  choices_price <- unique(data$PreisreiheLang)
  
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
                      # choices = choices_price
                      choices = c("Preis pro m² Grundstücksfläche", 
                                  "Preis pro m² Grundstücksfläche, abzgl. Versicherungswert")),
      
      # Group (conditional to price)
      sszRadioButtons(ns("group"),
                      "Art",
                      choices = c(
                        "Ganze Liegenschaften",
                        "Stockwerkeigentum",
                        "Alle Verkäufe"
                      )
      ),
      
      # Action Button
      sszActionButton(
        inputId = ns("buttonStart"),
        label = "Abfrage starten"
      ),
      br(),
      
      # Downloads
      conditionalPanel(
        condition = "input.buttonStart",
        ns = ns,
        mod_download_ui("download_1")
      )
    ),
    # Main Panel (Results)
    mainPanel(
      
      # Table Title (prices)
      tags$div(
        id = "title_id",
        class = "title_div",
        textOutput(ns("title"))
      ),
      conditionalPanel(
        condition = "input.buttonStart",
        ns = ns,
        hr()
      ),
      
      # Table Subtitle (prices)
      tags$div(
        id = "subtitle_id",
        class = "subtitle_div",
        textOutput(ns("subtitle"))
      ),
      
      # Table Subsubtitle (prices)
      tags$div(
        id = "subSubtitle_id",
        class = "subSubtitle_div",
        textOutput(ns("subSubtitle"))
      ),

      mod_area_tables_ui(id, "price"),

      # Action Link for Hand Changes (counts)
      shinyjs::useShinyjs(),
      conditionalPanel(
        condition = "input.buttonStart",
        ns = ns,
        tags$div(
          class = "linkCount",
          actionLink("linkCount",
                     "Anzahl Handänderungen einblenden",
                     icon = icon("angle-down")
          )
        )
      ),
      # 
      # # Hidden Titles and Tables for Hand Changes
      # shinyjs::hidden(
      #   div(
      #     id = "countDiv",
      #     
      #     mod_area_tables_ui(id, "count")
      #   )
      #   ),
      
      conditionalPanel(
        condition = "input.buttonStart",
        ns = ns,
        explanationbox_app1()
      )
    )  
  )
 
  
}
    
#' area Server Functions
#'
#' @noRd 
mod_area_server <- function(id, data){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # Captions
    # Reactive Title
    titleReactive <- eventReactive(input$buttonStart, {
      input$price
    })
    output$title <- renderText({
      titleReactive()
    })
    
    # Reactive Subtitle
    subtitleReactive <- eventReactive(input$buttonStart, {
      if (input$price == "Stockwerkeigentum pro m\u00B2 Wohnungsfläche") {
        title <- NULL
      } else {
        title <- input$group
      }
    })
    output$subtitle <- renderText({
      subtitleReactive()
    })
    
    # Reactive Sub-Subtitle
    subSubtitleReactive <- eventReactive(input$buttonStart, {
      subSubtitle <- paste0(input$area, ", Medianpreise in CHF")
    })
    output$subSubtitle <- renderText({
      subSubtitleReactive()
    })
 
    # Output price
    mod_area_tables_server(id, "Preis", data)
    
    # Show Output Counts
    observeEvent(input$linkCount, {
      shinyjs::toggle("countDiv")
      
      mod_area_tables_server(id, "Zahl", data)
      
      if (input$linkCount %% 2 == 1) {
        txt <- "Anzahl Handänderungen verbergen"
        updateActionLink(session, "linkCount", label = txt, icon = icon("angle-up"))
        shinyjs::addClass("linkCount", "visitedLink")
      } else {
        txt <- "Anzahl Handänderungen einblenden"
        updateActionLink(session, "linkCount", label = txt, icon = icon("angle-down"))
        shinyjs::removeClass("linkCount", "visitedLink")
      }
    })
  
    
    mod_download_server("download_1")
  })
}
    
## To be copied in the UI
# mod_area_ui("area_1")
    
## To be copied in the server
# mod_area_server("area_1")
