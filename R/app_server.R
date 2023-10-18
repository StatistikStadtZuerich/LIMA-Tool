#' The application server-side
#'
#' @param input 
#' @param output 
#' @param session 
#'
#' @noRd
app_server <- function(input, output, session) {
  # get data with function
  data_vector <- get_data()
  
  # Your application server logic
  if(is.null(data_vector)){
    # if data is null then there is nothing displayed in the server
  } else {
    mod_area_server(id = "area_zones", 
                    zones = data_vector[["zones"]])
    
    mod_area_server(id = "area_types", 
                    zones = data_vector[["types"]])
    
    mod_address_server("addresses",
                       addresses = data_vector[["addresses"]],
                       series = data_vector[["series"]])
  }
}
