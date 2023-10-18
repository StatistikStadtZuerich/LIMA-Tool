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
    reactableOutput(ns("results")),
    
    # # title for BZO99
    # tags$div(
    #   # id = "tableTitle99_id",
    #   class = "tableTitle_div",
    #   textOutput(ns("tableTitle99"))
    # ),
    # 
    # # Table for BZO 99
    # reactableOutput(ns("results99"))
    
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
mod_area_tables_server <- function(id, zones, target_value, trigger, filter_area, filter_price, filter_group, title, BZO){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    stopifnot(!is.reactive(zones))
    stopifnot(is.reactive(trigger))
    stopifnot(is.reactive(filter_area))
    stopifnot(is.reactive(filter_price))
    stopifnot(is.reactive(filter_group))
    stopifnot(!is.reactive(target_value))
    stopifnot(!is.reactive(title))
    stopifnot(!is.reactive(BZO))
    
    # title for table
    output$tableTitle <- renderText({
      tableTitle <- title
      tableTitle
    })
    
    # render table but only when trigger input is updated
    output$results <- renderReactable({
      filtered_data <- filter_area_zone(zones, target_value, filter_area(), filter_price(), filter_group(), BZO)
      out <- reactable_area(filtered_data, 20)
      out
    }) %>%
      bindEvent(trigger())
    
    # # title for table 99
    # output$tableTitle99 <- renderText({
    #   tableTitle99 <- paste0("Nach Zonenart gemäss BZO 1999")
    #   tableTitle99
    # })
    # 
    # # render table 99 but only when the trigger input is updated
    # output$results99 <- renderReactable({
    #   filtered_data <- filter_area_zone(zones, target_value, filter_area(), filter_price(), filter_group(), "BZO99")
    #   out99 <- reactable_area(filtered_data, 15)
    #   out99
    # }) %>%
    #   bindEvent(trigger())
  })
}

## To be copied in the UI
# mod_area_tables_ui("area_tables_1")

## To be copied in the server
# mod_area_tables_server("area_tables_1")
