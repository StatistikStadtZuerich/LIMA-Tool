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
        max_options = 500,
        value = "Napfgasse"
      ),
      
      # Number input
      sszSelectInput(
        ns("select_number"),
        "Wählen Sie eine Hausnummer aus",
        choices = NULL,
        selected = 1
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
        mod_download_ui(ns("download_3"))
      )
    ),
    
    # Main Panel (results)
    mainPanel(
      br(),
      
      # Info Table
      conditionalPanel(
        condition = "input.start_query",
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
      freezeReactiveValue(input, "select_number")
      updateSelectInput(
        session, "select_number",
        choices = addresses |> 
          filter(StrasseLang == input$select_street) |> 
          pull(Hnr) |> 
          mixedsort()
      )
    }) |>  
      bindEvent(input$select_street)
    
    mod_address_info_server(id = "address_info", 
                            addresses = addresses, 
                            series = series,
                            filter_street = reactive(input$select_street), 
                            filter_number = reactive(input$select_number))
    
    mod_address_tables_server(id = "Preis_submodul", 
                              addresses = addresses, 
                              series = series,
                              target_value = "Preis", 
                              filter_street = reactive(input$select_street), 
                              filter_number = reactive(input$select_number))
    
    observe({
      if (input$linkCount %% 2 == 1) {
        txt <- "Anzahl Handänderungen verbergen"
        updateActionLink(session, "linkCount", label = txt, icon = icon("angle-up"))
        shinyjs::addClass("linkCount", "visitedLink")
      } else {
        txt <- "Anzahl Handänderungen einblenden"
        updateActionLink(session, "linkCount", label = txt, icon = icon("angle-down"))
        shinyjs::removeClass("linkCount", "visitedLink")
      }
    }) |> 
      bindEvent(input$linkCount)
    
    mod_address_tables_server(id = "Zahl_submodul", 
                              addresses = addresses, 
                              series = series,
                              target_value = "Zahl", 
                              filter_street = reactive(input$select_street), 
                              filter_number = reactive(input$select_number))
    
    mod_download_server(id = "download_3", 
                        filter_function = filter_address_download,
                        static_parameters = list("addresses" = addresses, 
                                                 "series" = series),
                        reactive_parameters = list(
                          select_street = reactive(input$select_street),
                          select_number = reactive(input$select_number)
                        ),
                        filter_app = 3
    )
  })
}

## To be copied in the UI
# mod_address_ui("address_1")

## To be copied in the server
# mod_address_server("address_1")
