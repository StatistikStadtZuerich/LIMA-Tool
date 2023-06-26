# devtools::load_all()
choices_app1 <- list(
  choices_area = unique(data_vector[["zones"]]$GebietLang),
  choices_price = unique(data_vector[["zones"]]$PreisreiheLang),
  choices_group = unique(data_vector[["zones"]]$ArtLang)
)
ui <- tagList(
  mod_area_ui("Preis_test", data_vector[["zones"]], choices_app1)
)
server <- function(input, output){
  mod_area_server("Preis_test", data = data_vector[["zones"]])
}
shinyApp(ui = ui, server = server)
