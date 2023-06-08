#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  
  
  
  
  ### Change Action Query Button when first selected
  ## All Apps
  observe({
    req(input$buttonStart)
    updateActionButton(session, "buttonStart",
                       label = "Erneute Abfrage"
    )
  })
}
