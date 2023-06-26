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
mod_area_ui <- function(id, data, choicesapp){
  ### Set up directory for icons
  ssz_icons <- icon_set("inst/app/www/icons/")
  
  ns <- NS(id)
  tagList(
    sidebarPanel(
      # Area
      sszSelectInput(ns("select_area"),
                     "Gebietsauswahl",
                     choices = choicesapp[["choices_area"]]),
      
      # Price
      sszRadioButtons(ns("select_price"),
                      "Preise",
                      # choices = choicesapp[["choices_price"]]
                      choices = c("Preis pro m² Grundstücksfläche", 
                                  "Preis pro m² Grundstücksfläche, abzgl. Versicherungswert")),
      
      # Group (conditional to price)
      sszRadioButtons(ns("select_group"),
                      "Art",
                      # choices = choicesapp[["choices_group"]]
                      choices = c(
                        "Ganze Liegenschaften",
                        "Stockwerkeigentum",
                        "Alle Verkäufe"
                      )
      ),
      
      # Action Button
      sszActionButton(
        inputId = ns("start_query"),
        label = "Abfrage starten"
      ),
      br(),
      
      # Downloads
      conditionalPanel(
        condition = "input.start_query",
        ns = ns,
        mod_download_ui(ns("download_1"))
      )
    ),
    # Main Panel (Results)
    mainPanel(
      
      # Table Title (prices)
      tags$div(
        id = ns("title_id"),
        class = "title_div",
        textOutput(ns("title"))
      ),
      conditionalPanel(
        condition = "input.start_query",
        ns = ns,
        hr()
      ),
      
      # Table Subtitle (prices)
      tags$div(
        id = ns("subtitle_id"),
        class = "subtitle_div",
        textOutput(ns("subtitle"))
      ),
      
      # Table Subsubtitle (prices)
      tags$div(
        id = ns("subSubtitle_id"),
        class = "subSubtitle_div",
        textOutput(ns("subSubtitle"))
      ),

      mod_area_tables_ui(ns("Preis_submodul"), "Preis"),

      # Action Link for Hand Changes (counts)
      # golem::activate_js(),
      # shinyjs::useShinyjs(),
      # conditionalPanel(
      #   condition = "input.start_query",
      #   ns = ns,
      #   tags$div(
      #     class = "linkCount",
      #     actionLink("linkCount",
      #                "Anzahl Handänderungen einblenden",
      #                icon = icon("angle-down")
      #     )
      #   )
      # ),
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
        condition = "input.start_query",
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
    titleReactive <- eventReactive(input$start_query, {
      input$select_price
    })
    output$title <- renderText({
      titleReactive()
    })
    
    # Reactive Subtitle
    subtitleReactive <- eventReactive(input$start_query, {
      title <- input$select_group
    })
    output$subtitle <- renderText({
      subtitleReactive()
    })
    
    # Reactive Sub-Subtitle
    subSubtitleReactive <- eventReactive(input$start_query, {
      input$select_area
    })
    output$subSubtitle <- renderText({
      req(subSubtitleReactive())
      paste0(subSubtitleReactive(), ", Medianpreise in CHF")
    })
 
    output16 <- reactive({
      filtered_data <- data16
      filtered_data
    })
    
    # Output price
    mod_area_tables_server("PreisID", data, "Preis", input$select_area, input$select_price, select_group)
    
    # Show Output Counts
    # observeEvent(input$linkCount, {
    #   shinyjs::toggle("countDiv")
    #   
    #   mod_area_tables_server(id, "Zahl", data)
    #   
    #   if (input$linkCount %% 2 == 1) {
    #     txt <- "Anzahl Handänderungen verbergen"
    #     updateActionLink(session, "linkCount", label = txt, icon = icon("angle-up"))
    #     shinyjs::addClass("linkCount", "visitedLink")
    #   } else {
    #     txt <- "Anzahl Handänderungen einblenden"
    #     updateActionLink(session, "linkCount", label = txt, icon = icon("angle-down"))
    #     shinyjs::removeClass("linkCount", "visitedLink")
    #   }
    # })
  
    
    mod_download_server("download_1")
  })
}
    
## To be copied in the UI
# mod_area_ui("area_1")
    
## To be copied in the server
# mod_area_server("area_1")
