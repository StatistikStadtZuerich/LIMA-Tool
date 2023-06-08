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
  # ns2 <- NS(target_value)
  tagList(
    
    # Title for BZO16
    tags$div(
      id = "tableTitle16_id",
      class = "tableTitle_div",
      textOutput(ns("tableTitle16"))
    ),
    
    # Table for BZO 16
    reactableOutput(ns("results16")),
    
    # title for BZO99
    tags$div(
      id = "tableTitle99_id",
      class = "tableTitle_div",
      textOutput(ns("tableTitle99"))
    ),
    
    # Table for BZO 99 
    reactableOutput(ns("results99")),
    
  )
}
    
#' area_tables Server Functions
#'
#' @noRd 
mod_area_tables_server <- function(id, target_value, data){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # Reactive Table Title BZO 16
    tableTitle16Reactive <- eventReactive(input$buttonStart, {
      tableTitle16 <- paste0("Nach Zonenart gemäss BZO 2016")
    })
    output$tableTitle16 <- renderText({
      tableTitle16Reactive()
    })
    
    # call data_filter function to get data for table 16
    Output16 <- eventReactive(input$buttonStart, {
      filtered_data <- filter_area_zone(target_value, data, "BZO16")
      filtered_data
    })
    
    observeEvent(input$buttonStart, {
      output$results16 <- renderReactable({
        out16 <- reactable_area(Output16(), 5)
        out16
      })
      
      # Reactive Table Title BZO 99
      tableTitle99Reactive <- eventReactive(input$buttonStart, {
        tableTitle99 <- paste0("Nach Zonenart gemäss BZO 1999")
      })
      output$tableTitle99 <- renderText({
        tableTitle99Reactive()
      })
      
      # call data_filter function to get data for table 99
      Output99 <- eventReactive(input$buttonStart, {
        filtered_data <- filter_area_zone(target_value, data, "BZO99")
        filtered_data
      })
      
      output$results99 <- renderReactable({
        out99 <- reactable_area(Output99(), 15)
        out99
      })
    })
    
  })
}
    
## To be copied in the UI
# mod_area_tables_ui("area_tables_1")
    
## To be copied in the server
# mod_area_tables_server("area_tables_1")
