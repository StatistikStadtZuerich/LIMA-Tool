#' address UI Function
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
#' @importFrom dqshiny autocomplete_input
#' @importFrom shiny NS tagList 
#' @importFrom gtools mixedsort
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
        mod_address_info_ui(ns("address_info"))
      ),
      br(),
      
      conditionalPanel(
        condition = "input.select_street && input.select_number && input.start_query",
        ns = ns,
        mod_address_tables_ui(ns("Preis_submodul"))
      ),
      
      # # Action Link for Hand Changes (counts)
      # useShinyjs(),
      # conditionalPanel(
      #   condition = "input.buttonStartTwo",
      #   tags$div(
      #     id = "linkCountTwoId",
      #     class = "linkCountTwoDiv",
      #     uiOutput("linken")
      #   )
      # ),
      # 
      # # Hidden Table for Hand Changes
      # shinyjs::hidden(
      #   div(
      #     id = "countDivTwo",
      #     mod_address_tables_ui("Zahl_submodul")
      #   )
      # ),
      
      
      conditionalPanel(
        condition = "input.select_street && input.select_number && input.start_query",
        ns = ns,
        explanationbox_app2()
      )
    )
  )
}
    
#' address Server Functions
#'
#' @noRd 
mod_address_server <- function(id, data, data2){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # Filter Hnr to the according address
    # Sort for House Number in Drop Down
    observe({
      updateSelectInput(
        session, "select_number",
        choices = data %>%
          filter(StrasseLang == input$select_street) %>%
          pull(Hnr) %>%
          mixedsort()
      )
      print(input$select_street)
    })
    
    mod_address_info_server(id = "address_info", 
                            data = data, 
                            data2 = data2, 
                            trigger = reactive(input$start_query),
                            filter_street = reactive(input$select_street), 
                            filter_number = reactive(input$select_number))
    
    mod_address_tables_server(id = "Preis_submodul", 
                              data = data, 
                              data2 = data2,
                              target_value = "Preis", 
                              trigger = reactive(input$start_query),
                              filter_street = reactive(input$select_street), 
                              filter_number = reactive(input$select_number))
    
    # Filter data for download name
    filename <- eventReactive(input$start_query, {
      district <- data %>%
        filter(StrasseLang == input$select_street & Hnr == input$select_number) %>%
        pull(QuarLang)
       
      name <- list(paste0("Liegenschaftenhandel_nach_Bauzonenordnung_und_Quartier_", district))
      name
      print(name)
    })
    
    mod_download_server(id = "download_3", 
                        function_filter = filter_address_download(data, data2, input$select_street, input$select_number),
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
