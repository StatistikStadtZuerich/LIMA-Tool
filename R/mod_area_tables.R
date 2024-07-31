#' area_tables UI Function
#'
#' @param id id of the module called in the app
#' @param target_value target value of the app ("Preis" or "Zahl")
#'
#' @description A shiny Module to render the titles and tables of the apps with the area-architecture
#'
#' @noRd 
mod_area_tables_ui <- function(id, target_value){
  ns <- NS(id)
  
  tagList(
    
    # Title for results
    tags$div(
      # id = ns("tableTitle16_id"),
      class = "tableTitle_div",
      textOutput(ns("tableTitle"))
    ),
    
    # Table for results
    shinycssloaders::withSpinner(
      reactableOutput(ns("results")),
      type = 7,
      color = "#0F05A0"
    )
  )
}

#' area_tables Server Functions
#'
#' @param id id of the module called in the app
#' @param zones dataset zones
#' @param target_value target value of the app ("Preis" or "Zahl")
#' @param trigger reactive trigger input to render the output
#' @param filter_area filter value (area) selected from input widget
#' @param filter_price filter value (price) selected from input widget
#' @param filter_group filter value (group) selected from input widget
#'
#' @noRd 
mod_area_tables_server <- function(id, target_app, zones, target_value, table_function, filter_area, filter_price, filter_group, title, BZO = NULL){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # title for table
    output$tableTitle <- renderText({
      title
    })
    
    # render table but only when trigger input is updated
    output$results <- renderReactable({
      filtered_data <- filter_area_zone(target_app, zones, target_value, filter_area(), filter_price(), filter_group(), BZO)
      out <- table_function(filtered_data, 25)
      out
    }) %>%
      bindEvent(filter_area(), filter_price(), filter_group())
    
  })
}

## To be copied in the UI
# mod_area_tables_ui("area_tables_1")

## To be copied in the server
# mod_area_tables_server("area_tables_1")
