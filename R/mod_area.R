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
      # conditionalPanel(
      #   condition = "input.start_query",
      #   ns = ns,
      #   hr()
      # ),
      
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
      
      conditionalPanel(
        condition = "input.start_query",
        ns = ns,
        mod_area_tables_ui(ns("Preis_submodul"), "Preis")
      ),

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
      #     mod_area_tables_ui(ns("Zahl_submodul"), "Zahl")
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
 
    
    # Output price
    mod_area_tables_server(id = "Preis_submodul", 
                           data = data, 
                           target_value = "Preis", 
                           trigger = reactive(input$start_query),
                           filter_area = reactive(input$select_area), 
                           filter_price = reactive(input$select_price), 
                           filter_group = reactive(input$select_group))
    
    
    
    
    # Show Output Counts
    # observeEvent(input$linkCount, {
    #   shinyjs::toggle("countDiv")
    # 
    # # Output count
    # mod_area_tables_server(id = "Zahl_submodul",
    #                        data = data,
    #                        target_value = "Zahl",
    #                        filter_area = input$select_area,
    #                        filter_price = input$select_price,
    #                        filter_group = input$select_group)
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
    
    
    # Filter data for download name
    filename <- eventReactive(input$start_query, {
      price <- gsub(" ", "-", input$select_price, fixed = TRUE)
      group <- gsub(" ", "-", input$select_group, fixed = TRUE)
      area <- gsub(" ", "-", input$select_area, fixed = TRUE)
      name <- list(paste0("Liegenschaftenhandel_nach_Bauzonenordnung_und_Zonenart_", price, "_", group, "_", area))
      name
      return(name)
    })
   
    mod_download_server(id = "download_1",
                        function_filter = filter_area_download(data, input$select_area, input$select_price, input$select_group),
                        filename_download = filename(), 
                        filter_app = "Abfrage 1: Zeitreihen nach Bauzonen für ganze Stadt und Teilgebiete", 
                        trigger = input$start_query,
                        filter_1 = input$select_area, 
                        filter_2 = input$select_price, 
                        filter_3 = input$select_group)
    
    ### Change Action Query Button when first selected
    ## All Apps
    observe({
      req(input$start_query)
      updateActionButton(session, "start_query",
                         label = "Erneute Abfrage"
      )
    })
  })
}
    
## To be copied in the UI
# mod_area_ui("area_1")
    
## To be copied in the server
# mod_area_server("area_1")
