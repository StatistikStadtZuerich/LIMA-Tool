#' area_types UI Function
#'
#' @param id id of the module called in the app
#'
#' @description A shiny Module to render the App specific code for App 2. This Module is then called in the Module mod_area.R.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_area_types_ui <- function(id){
  
  ns <- NS(id)
  tagList(
    
    mod_area_tables_ui(ns("Preis_submodul"), "Preis"),
      
    # Action Link for Hand Changes (counts)
    tags$div(
      class = "linkCount",
      actionLink(ns("linkCount"),
                 "Anzahl Handänderungen einblenden",
                 icon = icon("angle-down")
      ),
      
      # Hidden Titles and Tables for Hand Changes
      conditionalPanel(
        condition = "input.linkCount % 2 == 1",
        ns = ns,
        mod_area_tables_ui(ns("Zahl_submodul"), "Zahl")
      )
    ),
    
    explanationbox_app2()

  )
}
    
#' area_types Server Functions
#'
#' @param id id of the module called in the app
#' @param zones dataset zones
#' @param filename_download filename is generated from inputs in upper module
#' @param trigger reactive trigger input to render the output
#' @param filter_area filter value (area) selected from input widget
#' @param filter_price filter value (price) selected from input widget
#' @param filter_group filter value (group) selected from input widget 
#'
#' @noRd 
mod_area_types_server <- function(id, zones, filename_download,  trigger, filter_area, filter_price, filter_group){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    stopifnot(is.reactive(trigger))
    stopifnot(is.reactive(filter_area))
    stopifnot(is.reactive(filter_price))
    stopifnot(is.reactive(filter_group))
    
    # Call Table Modules for Prices in App 2
    mod_area_tables_server(id = "Preis_submodul",
                           target_app = "Types",
                           zones = zones,
                           target_value = "Preis",
                           trigger = reactive(trigger()),
                           filter_area = reactive(filter_area()), 
                           filter_price = reactive(filter_price()), 
                           filter_group = reactive(filter_group()),
                           title = paste0("Nach Bebauungsart"),
                           BZO = "BZO99")
    
    # Toggle for Showing Counts in App 2  
    observeEvent(input$linkCount, {
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
    
    # Call Table Modules for Counts in App 2
    mod_area_tables_server(id = "Zahl_submodul",
                           zones = zones,
                           target_app = "Types",
                           target_value = "Zahl",
                           trigger = reactive(trigger()),
                           filter_area = reactive(filter_area()), 
                           filter_price = reactive(filter_price()), 
                           filter_group = reactive(filter_group()),
                           title = paste0("Nach Bebauungsart"))
    
    
  })
}
    
## To be copied in the UI
# mod_area_types_ui("area_types_1")
    
## To be copied in the server
# mod_area_types_server("area_types_1")
