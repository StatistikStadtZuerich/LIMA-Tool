ui <- tagList(
  mod_area_tables_ui("PreisID", "Preis")
)
server <- function(input, output){
  mod_address_tables_server("PreisID", data_vector[["addresses"]], data_vector[["series"]], reactive(1), "Preis", reactive("Heerenwiesen"), reactive("24") )
}
shinyApp(ui = ui, server = server)




