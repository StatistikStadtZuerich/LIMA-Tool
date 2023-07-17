#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # get data with function
  data_vector <- get_data()
  
  # Your application server logic
  if(is.null(data_vector)){
    # if data is null then there is nothing displayed in the server
  } else {
    mod_area_server(id = "area_zones", 
                    data = data_vector[["zones"]])
    
    mod_address_server("addresses",
                       data = data_vector[["addresses"]],
                       data2 = data_vector[["series"]])
  }
}
