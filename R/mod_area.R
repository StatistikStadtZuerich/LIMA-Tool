#' area UI Function
#'
#' @param id id of the module called in the app
#' @param choicesapp choices that are selectable in the input widget
#'
#' @description A shiny Module to render the apps (zones and bebauungsart) with the app-architecture 'zones'
#'
#' @noRd 
mod_area_ui <- function(id, choicesapp){

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
                                  "Preis pro m² Grundstücksfläche, abzgl. Versicherungswert")
      ),
      
      # Group (conditional to price)
      sszRadioButtons(ns("select_group"),
                      "Art",
                      choices = choicesapp[["choices_group"]]
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
      
      # Downloads
      conditionalPanel(
         condition = "input.start_query",
         ns = ns, 
         
         conditionalPanel(
           condition = "input.choose_app == 'Abfrage 1: Zeitreihen nach Bauzonen für ganze Stadt und Teilgebiete'",
           mod_download_ui(ns("download_1"))
         ),
         conditionalPanel(
           condition = "input.choose_app == 'Abfrage 2: Zeitreihen nach Bebauungsart für ganze Stadt und Teilgebiete'",
           mod_download_ui(ns("download_2"))
         )
      )
    ),
    # Main Panel (Results)
    mainPanel(
    conditionalPanel(
      condition = "input.start_query",
      ns = ns,
      
      # Table Title (prices)
      tags$div(
        id = ns("title_id"),
        class = "title_div",
        textOutput(ns("title"))
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
      
      # Modules for App1 & App2
      conditionalPanel(
        # This condition is not in a module, therefore there is no need for a Namespace
        condition = "input.choose_app == 'Abfrage 1: Zeitreihen nach Bauzonen für ganze Stadt und Teilgebiete'",
        mod_area_zones_ui(ns("mod_zones"))
      ),
      conditionalPanel(
        # This condition is not in a module, therefore there is no need for a Namespace
        condition = "input.choose_app == 'Abfrage 2: Zeitreihen nach Bebauungsart für ganze Stadt und Teilgebiete'",
        mod_area_types_ui(ns("mod_types"))
      )
    )
  )
)}

#' area Server Functions
#'
#' @param id id of the module called in the app
#' @param zones dataset zones
#'
#' @noRd 
mod_area_server <- function(id, zones, choice_app){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    stopifnot(!is.reactive(choice_app))
    
    # Captions
    # Title
    # only updated when button is pressed
    output$title <- renderText({
      input$select_price
    }) %>%
      bindEvent(input$select_price)
    
    # Subtitle
    # only updated when button is pressed
    output$subtitle <- renderText({
      input$select_group
    }) %>%
      bindEvent(input$select_group)
    
    # Sub-Subtitle
    # only updated when button is pressed
    output$subSubtitle <- renderText({
      paste0(input$select_area, ", Medianpreise in CHF")
    }) %>%
      bindEvent(input$select_area)
    
    # Call Modules for App 1
    if(choice_app == 1){
      mod_download_server(id = "download_1",
                          filter_function = filter_area_download, 
                          static_parameters = list("zones" = zones),
                          reactive_parameters = list(
                            select_area = reactive(input$select_area),
                            select_price = reactive(input$select_price),
                            select_group = reactive(input$select_group)
                          ),
                          filter_app = 1)
      mod_area_zones_server("mod_zones", zones, 
                            filename_download = filename(), 
                            filter_area = reactive(input$select_area), 
                            filter_price = reactive(input$select_price), 
                            filter_group = reactive(input$select_group))
    } else if(choice_app == 2){
      # Call Modules for App 2
      mod_download_server(id = "download_2",
                          filter_function = filter_area_download,
                          static_parameters = list("zones" = zones),
                          reactive_parameters = list(
                            select_area = reactive(input$select_area),
                            select_price = reactive(input$select_price),
                            select_group = reactive(input$select_group)
                          ),
                          filter_app = 2)
      mod_area_types_server("mod_types", zones, 
                            filename_download = filename(), 
                            filter_area = reactive(input$select_area), 
                            filter_price = reactive(input$select_price), 
                            filter_group = reactive(input$select_group))
    }
  
    
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
