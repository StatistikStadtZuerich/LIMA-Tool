ui <- tagList(
  mod_address_info_ui("test_ID")
)
server <- function(input, output){
  mod_address_info_server("test_ID", data_vector[["addresses"]], data_vector[["series"]], 
                          "Bülachstrasse", "24")
}
shinyApp(ui = ui, server = server)


## To be copied in the UI
# mod_address_info_ui("address_info_1")

## To be copied in the server
# mod_address_info_server("address_info_1")