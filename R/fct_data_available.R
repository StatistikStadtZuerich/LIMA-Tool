#' data_available 
#'
#' @param addresses address dataset
#' @param series series dataset
#' @param filter_street filters the street with the given input in the app 
#' @param filter_number filters the number with the given input in the app 
#'
#' @description A fct function which checks if the data is available
#'
#' @return The return value is a dummy variable if the data is available
#'
#' @noRd
data_available <- function(addresses, series, filter_street, filter_number){
  
  filtered_addresses <- get_information_address(addresses, series, filter_street, filter_number, "Preis")
  
  # Total series
  priceSerieTotal <- bind_rows(filtered_addresses[["SerieBZO16"]], filtered_addresses[["SerieBZO99"]]) |> 
    select(-Typ, -QuarCd, -QuarLang, -ZoneSort, -ZoneLang)
  
  if (nrow(priceSerieTotal) > 0) {
    available <- 1
  } else {
    available <- 0
  }
  
  return(available)
}