#' data_available
#'
#' @param addresses address dataset
#' @param series series dataset
#' @param filter_address filter value (street + nr) selected from input widget
#'
#' @description A function which checks if the data is available
#'
#' @return The return value is a dummy variable (0 or 1) to indicate whether the data is available
#'
#' @noRd
data_available <- function(addresses, series, filter_address) {
  filtered_addresses <- get_information_address(addresses, series, filter_address, "Preis")

  # Total series
  priceSerieTotal <- bind_rows(filtered_addresses[["SerieBZO16"]], filtered_addresses[["SerieBZO99"]])

  if (nrow(priceSerieTotal) > 0) {
    available <- 1
  } else {
    available <- 0
  }

  return(available)
}
