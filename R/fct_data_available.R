#' data_available 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
data_available <- function(addresses, series, filter_street, filter_number){
  
  filtered_addresses <- get_information_address(addresses, series, filter_street, filter_number, "Preis")
  
  # Total series
  priceSerieTotal <- bind_rows(filtered_addresses[["SerieBZO16"]], filtered_addresses[["SerieBZO99"]]) %>%
    select(-Typ, -QuarCd, -QuarLang, -ZoneSort, -ZoneLang)
  
  if (nrow(priceSerieTotal) > 0) {
    available <- 1
  } else {
    available <- 0
  }
  
  return(available)
}