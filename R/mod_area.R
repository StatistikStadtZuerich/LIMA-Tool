#' area UI Function
#'
#' @param id id of the module called in the app
#' @param choicesapp choices that are selectable in the input widget
#'
#' @description A shiny Module to render the apps (zones and bebauungsart) with the app-architecture 'zones'
#'
#' @noRd 
mod_area_ui <- function(id, choicesapp, test){
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
                                  "Preis pro m² Grundstücksfläche, abzgl. Versicherungswert")
                      ),
      
      # Group (conditional to price)
      sszRadioButtons(ns("select_group"),
                      "Art",
                      choices = choicesapp[["choices_group"]]
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
      
      # Mainpanel for App 1
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
            #     mod_area_tables_ui(ns("Zahl_submodul16"), "Zahl"),
            #     mod_area_tables_ui(ns("Zahl_submodul99"), "Zahl")
            #   )
            #   ),

              explanationbox_app1()
              
          )
        ),
      
      # Mainpanel for App 2
      conditionalPanel(
        # This condition is not in a module, therefore there is no need for a Namespace
        condition = "input.choose_app == 'Abfrage 2: Zeitreihen nach Bebauungsart für ganze Stadt und Teilgebiete'",
        
        # Start Query Button is in the module, so the conditionalPanel() needs a ns()
        conditionalPanel(
          condition = "input.start_query",
            ns = ns,
            
            mod_area_tables_ui(ns("Preis_submodul"), "Preis"),
            
            # Action Link for Hand Changes (counts)
              tags$div(
                class = "linkCount",
                actionLink(ns("linkCount"),
                           "Anzahl Handänderungen einblenden",
                           icon = icon("angle-down")
                ),
                # conditionalPanel(
                #   condition = "input.linkCount  %% 2 == 1",
                #   ns = ns,
                  mod_area_tables_ui(ns("Zahl_submodul"), "Zahl")
                # )
              
                # shinyjs::hidden(
                #   div(
                #     id = ns("countDiv"),
                #     
                #     mod_area_tables_ui(ns("Zahl_submodul"), "Zahl")
                #   )
                # )
                 ),
    
                # Hidden Titles and Tables for Hand Changes
                
            
            explanationbox_app2()
        )
        
      )
    )  
  )
 
  
}
    
#' area Server Functions
#'
#' @param id id of the module called in the app
#' @param zones dataset zones
#'
#' @noRd 
mod_area_server <- function(id, zones){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # Captions
    # Title
    # only updated when button is pressed
    output$title <- renderText({
      input$select_price
    }) %>%
      bindEvent(input$start_query)
    
    # Subtitle
    # only updated when button is pressed
    output$subtitle <- renderText({
      input$select_group
    }) %>%
      bindEvent(input$start_query)
    
    # Sub-Subtitle
    # only updated when button is pressed
    output$subSubtitle <- renderText({
      paste0(input$select_area, ", Medianpreise in CHF")
    }) %>%
      bindEvent(input$start_query)
 
    
    ## App 1
    # Output price
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
    mod_area_tables_server(id = "Preis_submodul", 
                           target_app = "Types",
                           zones = zones, 
                           target_value = "Preis", 
                           trigger = reactive(input$start_query),
                           filter_area = reactive(input$select_area), 
                           filter_price = reactive(input$select_price), 
                           filter_group = reactive(input$select_group),
                           title = paste0("Nach Bebauungsart"),
                           BZO = "BZO99")
    
    # Show Output Counts
    observeEvent(input$linkCount, {
      # shinyjs::toggle("countDiv")
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

    # # Output count
    # mod_area_tables_server(id = "Zahl_submodul16",
    #                        zones = zones,
    #                        target_value = "Zahl",
    #                        filter_area = input$select_area,
    #                        filter_price = input$select_price,
    #                        filter_group = input$select_group)
    # mod_area_tables_server(id = "Zahl_submodul99",
    #                        zones = zones,
    #                        target_value = "Zahl",
    #                        filter_area = input$select_area,
    #                        filter_price = input$select_price,
    #                        filter_group = input$select_group)
    mod_area_tables_server(id = "Zahl_submodul",
                           zones = zones,
                           target_app = "Types", 
                           target_value = "Zahl",
                           trigger = reactive(input$start_query), 
                           filter_area = reactive(input$select_area),
                           filter_price = reactive(input$select_price),
                           filter_group = reactive(input$select_group),
                           title = paste0("Nach Bebauungsart"),
                           BZO = "BZO99")
    
    ## App 2
    
    
    
    
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
