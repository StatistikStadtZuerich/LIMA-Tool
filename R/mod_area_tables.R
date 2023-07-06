#' area_tables UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @import reactable
#' @import shiny 
#' @importFrom shiny NS tagList 
mod_area_tables_ui <- function(id, target_value){
  ns <- NS(id)
 
  tagList(
    
    # Title for BZO16
    tags$div(
      # id = ns("tableTitle16_id"),
      class = "tableTitle_div",
      textOutput(ns("tableTitle16"))
    ),
    
    # Table for BZO 16
    reactableOutput(ns("results16")),

    # title for BZO99
    tags$div(
      # id = "tableTitle99_id",
      class = "tableTitle_div",
      textOutput(ns("tableTitle99"))
    ),

    # Table for BZO 99
    reactableOutput(ns("results99"))

  )
}
    
#' area_tables Server Functions
#'
#' @noRd 
mod_area_tables_server <- function(id, data, target_value, trigger, filter_area, filter_price, filter_group){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    stopifnot(!is.reactive(data))
    stopifnot(is.reactive(trigger))
    stopifnot(is.reactive(filter_area))
    stopifnot(is.reactive(filter_price))
    stopifnot(is.reactive(filter_group))
    stopifnot(!is.reactive(target_value))
    
    # call data_filter function to get data for table 19
    output$tableTitle16 <- renderText({
      tableTitle16 <- paste0("Nach Zonenart gemäss BZO 2016")
      tableTitle16
    })

    # call data_filter function to get data for table 16
    # filtered_data16 <- reactive({
    #   filtered_data <- filter_area_zone(data, target_value, filter_area(), filter_price(), filter_group(), "BZO16")
    #   filtered_data
    #   print("Trigger")
    # })
    output$results16 <- renderReactable({
      req(trigger()>0)
      filtered_data <- filter_area_zone(data, target_value, filter_area(), filter_price(), filter_group(), "BZO16")
      
      out16 <- reactable_area(filtered_data, 5)
      out16
    })

      # call data_filter function to get data for table 99
      output$tableTitle99 <- renderText({
        tableTitle99 <- paste0("Nach Zonenart gemäss BZO 1999")
        tableTitle99
      })

      # call data_filter function to get data for table 99
      # filtered_data99 <- reactive({
      #   filtered_data <- filter_area_zone(data, target_value, filter_area(), filter_price(), filter_group(), "BZO99")
      #   filtered_data
      #   print("Trigger")
      # })
      output$results99 <- renderReactable({
        req(trigger())
        
        filtered_data <- filter_area_zone(data, target_value, filter_area(), filter_price(), filter_group(), "BZO99")
        
        out99 <- reactable_area(filtered_data, 15)
        out99
      })
    
    
  })
}
    
## To be copied in the UI
# mod_area_tables_ui("area_tables_1")
    
## To be copied in the server
# mod_area_tables_server("area_tables_1")
