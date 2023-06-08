#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  
  # get data with function
  data_vector <- get_data()
  
  mod_area_server(id = "area_zones", 
                  data = data_vector[["zones"]])
  
  
  ### Change Action Query Button when first selected
  ## All Apps
  observe({
    req(input$buttonStart)
    updateActionButton(session, "buttonStart",
                       label = "Erneute Abfrage"
    )
  })
}
