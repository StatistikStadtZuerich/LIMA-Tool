ui <- tagList(
  mod_area_tables_ui("PreisID", "Preis")
)
server <- function(input, output){
  mod_area_tables_server("PreisID", data_vector[["zones"]], "Preis", reactive(1), reactive("Rathaus"), reactive("Preis pro m² Grundstücksfläche"), reactive("Stockwerkeigentum"))
}
shinyApp(ui = ui, server = server)
