ui <- tagList(
  mod_area_tables_ui("PreisID")
)
server <- function(input, output){
  mod_address_tables_server("PreisID", data_vector[["addresses"]], data_vector[["series"]], "Preis", reactive("1"), reactive("Heerenwiesen"), reactive("24"))
}
shinyApp(ui = ui, server = server)
