ui <- tagList(
  mod_area_tables_ui("Preis", "target")
)
server <- function(input, output){
  mod_area_tables_server("Preis", "target", data = data_vector[["zones"]])
}
shinyApp(ui = ui, server = server)
