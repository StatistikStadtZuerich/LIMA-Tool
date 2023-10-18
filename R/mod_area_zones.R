#' area_zones UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_area_zones_ui <- function(id){
  ssz_icons <- icon_set("inst/app/www/icons/")
  
  ns <- NS(id)
  tagList(
    sidebarPanel(
      # Downloads
      conditionalPanel(
        condition = "input.start_query",
        ns = ns,
        mod_download_ui(ns("download_1"))
      )
    ),
    
    # Main Panel (Results)
    mainPanel(
      conditionalPanel(
        # This condition is not in a module, therefore there is no need for a Namespace
        condition = "input.choose_app == 'Abfrage 1: Zeitreihen nach Bauzonen für ganze Stadt und Teilgebiete'",
        
        # Start Query Button is in the module, so the conditionalPanel() needs a ns()
        conditionalPanel(
          condition = "input.start_query",
          ns = ns,
          
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
      )
    )
  )
}
    
#' area_zones Server Functions
#'
#' @noRd 
mod_area_zones_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    
    mod_area_tables_server(id = "Preis_submodul16", 
                           target_app = "Zones",
                           zones = zones, 
                           target_value = "Preis", 
                           trigger = reactive(input$start_query),
                           filter_area = reactive(input$select_area), 
                           filter_price = reactive(input$select_price), 
                           filter_group = reactive(input$select_group),
                           title = paste0("Nach Zonenart gemäss BZO 2016"),
                           BZO = "BZO16")
    mod_area_tables_server(id = "Preis_submodul99", 
                           target_app = "Zones",
                           zones = zones, 
                           target_value = "Preis", 
                           trigger = reactive(input$start_query),
                           filter_area = reactive(input$select_area), 
                           filter_price = reactive(input$select_price), 
                           filter_group = reactive(input$select_group),
                           title = paste0("Nach Zonenart gemäss BZO 1999"),
                           BZO = "BZO99")
    
    observeEvent(input$linkCount, {
      print("toggled")
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
    
    # Output count
    mod_area_tables_server(id = "Zahl_submodul16",
                           zones = zones,
                           target_app = "Zones", 
                           target_value = "Zahl",
                           trigger = reactive(input$start_query),
                           filter_area = reactive(input$select_area), 
                           filter_price = reactive(input$select_price), 
                           filter_group = reactive(input$select_group),
                           title = paste0("Nach Zonenart gemäss BZO 2016"),
                           BZO = "BZO16")
    mod_area_tables_server(id = "Zahl_submodul99",
                           zones = zones,
                           target_app = "Zones", 
                           target_value = "Zahl",
                           trigger = reactive(input$start_query),
                           filter_area = reactive(input$select_area), 
                           filter_price = reactive(input$select_price), 
                           filter_group = reactive(input$select_group),
                           title = paste0("Nach Zonenart gemäss BZO 1999"),
                           BZO = "BZO99")
    
    ## Download
    # Filter data for download name
    filename <- reactive({
      price <- gsub(" ", "-", input$select_price, fixed = TRUE)
      group <- gsub(" ", "-", input$select_group, fixed = TRUE)
      area <- gsub(" ", "-", input$select_area, fixed = TRUE)
      name <- list(paste0("Liegenschaftenhandel_nach_Bauzonenordnung_und_Zonenart_", price, "_", group, "_", area))
    }) %>%
      bindEvent(input$start_query)
    
    mod_download_server(id = "download_1",
                        function_filter = filter_area_download(zones, input$select_area, input$select_price, input$select_group),
                        filename_download = filename(), 
                        filter_app = "Abfrage 1: Zeitreihen nach Bauzonen für ganze Stadt und Teilgebiete", 
                        filter_1 = input$select_area, 
                        filter_2 = input$select_price, 
                        filter_3 = input$select_group)
  })
}
    
## To be copied in the UI
# mod_area_zones_ui("area_zones_1")
    
## To be copied in the server
# mod_area_zones_server("area_zones_1")
