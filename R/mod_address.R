#' address UI Function
#'
#' @param id id of the module called in the app
#' @param choicesapp choices that are selectable in the input widget
#'
#' @description A shiny Module to render the app (address) with the app-architecture 'address'
#'
#' @noRd 
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
        choicesapp[["choices_street"]],
        max_options = 500
      ),

      # Number input
      sszSelectInput(
        ns("select_number"),
        "Wählen Sie eine Hausnummer aus",
        choices = choicesapp[["choices_streetnr"]],
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
      conditionalPanel(
        condition = "input.select_street && input.select_number && input.start_query",
        ns = ns,
        mod_address_info_ui(ns("address_info")),
        br(),
        mod_address_tables_ui(ns("Preis_submodul")),
        
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
            mod_area_tables_ui(ns("Zahl_submodul"))
          ),
          
          explanationbox_app3()
        )
      )
    )
  )
}
    
#' address Server Functions
#'
#' @param id id of the module called in the app
#' @param addresses dataset addresses
#' @param series dataset series
#'
#' @noRd 
mod_address_server <- function(id, addresses, series){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # Filter Hnr to the according address
    # Sort for House Number in Drop Down
    observe({
      updateSelectInput(
        session, "select_number",
        choices = addresses %>%
          filter(StrasseLang == input$select_street) %>%
          pull(Hnr) %>%
          mixedsort()
      )
      print(input$select_street)
    })
    
    mod_address_info_server(id = "address_info", 
                            addresses = addresses, 
                            series = series, 
                            trigger = reactive(input$start_query),
                            filter_street = reactive(input$select_street), 
                            filter_number = reactive(input$select_number))
    
    mod_address_tables_server(id = "Preis_submodul", 
                              addresses = addresses, 
                              series = series,
                              target_value = "Preis", 
                              trigger = reactive(input$start_query),
                              filter_street = reactive(input$select_street), 
                              filter_number = reactive(input$select_number))
    
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
    
    mod_address_tables_server(id = "Zahl_submodul", 
                              addresses = addresses, 
                              series = series,
                              target_value = "Zahl", 
                              trigger = reactive(input$start_query),
                              filter_street = reactive(input$select_street), 
                              filter_number = reactive(input$select_number))
    
    # Filter data for download name
    filename <- reactive({
      district <- addresses %>%
        filter(StrasseLang == input$select_street & Hnr == input$select_number) %>%
        pull(QuarLang)
       
      name <- list(paste0("Liegenschaftenhandel_nach_Bauzonenordnung_und_Quartier_", district))
    }) %>%
      bindEvent(input$start_query)
    
    mod_download_server(id = "download_3", 
                        function_filter = filter_address_download(addresses, series, input$select_street, input$select_number),
                        filename_download = filename(),
                        filter_app = "Abfrage 3: Zeitreihen für Quartiere und Bauzonen über Adresseingabe", 
                        filter_1 = input$select_street, 
                        filter_2 = input$select_number,
                        filter_3 = NULL)
    
    
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
# mod_address_ui("address_1")
    
## To be copied in the server
# mod_address_server("address_1")
