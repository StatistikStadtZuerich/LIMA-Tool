#' area_zones UI Function
#'
#' @param id id of the module called in the appdevtool
#'
#' @description A shiny Module to render the App specific code for App 1. This Module is then called in the Module mod_area.R.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_area_zones_ui <- function(id){
  
  ns <- NS(id)
  tagList(

    mod_area_tables_ui(ns("Preis_submodul16"), "Preis"),
    mod_area_tables_ui(ns("Preis_submodul99"), "Preis"),
      
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
        mod_area_tables_ui(ns("Zahl_submodul16"), "Zahl"),
        mod_area_tables_ui(ns("Zahl_submodul99"), "Zahl")
      )
      ),
      
      explanationbox_app1()
      
    )
}
    
#' area_zones Server Functions
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
mod_area_zones_server <- function(id, zones, filename_download, filter_area, filter_price, filter_group){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # Call Table Modules for Prices in App 1
    mod_area_tables_server(id = "Preis_submodul16", 
                           target_app = "Zones",
                           zones = zones, 
                           target_value = "Preis", 
                           table_function = reactable_area,
                           filter_area = reactive(filter_area()), 
                           filter_price = reactive(filter_price()), 
                           filter_group = reactive(filter_group()),
                           title = paste0("Nach Zonenart gemäss BZO 2016"),
                           BZO = "BZO16")
    mod_area_tables_server(id = "Preis_submodul99", 
                           target_app = "Zones",
                           zones = zones, 
                           target_value = "Preis", 
                           table_function = reactable_area,
                           filter_area = reactive(filter_area()), 
                           filter_price = reactive(filter_price()), 
                           filter_group = reactive(filter_group()),
                           title = paste0("Nach Zonenart gemäss BZO 1999"),
                           BZO = "BZO99")
    
    # Toggle for Showing Counts in App 1  
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
    
    # Call Table Modules for Counts in App 1
    mod_area_tables_server(id = "Zahl_submodul16",
                           zones = zones,
                           target_app = "Zones", 
                           target_value = "Zahl",
                           table_function = reactable_area,
                           filter_area = reactive(filter_area()), 
                           filter_price = reactive(filter_price()), 
                           filter_group = reactive(filter_group()),
                           title = paste0("Nach Zonenart gemäss BZO 2016"),
                           BZO = "BZO16")
    mod_area_tables_server(id = "Zahl_submodul99",
                           zones = zones,
                           target_app = "Zones", 
                           target_value = "Zahl",
                           table_function = reactable_area,
                           filter_area = reactive(filter_area()), 
                           filter_price = reactive(filter_price()), 
                           filter_group = reactive(filter_group()),
                           title = paste0("Nach Zonenart gemäss BZO 1999"),
                           BZO = "BZO99")

  })
}
    
## To be copied in the UI
# mod_area_zones_ui("area_zones_1")
    
## To be copied in the server
# mod_area_zones_server("area_zones_1")
