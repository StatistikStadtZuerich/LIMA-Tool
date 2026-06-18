#' zone_available
#'
#' @param selected_address address dataset filtered according to input
#' @param series series dataset
#'
#' @description A function which checks if the zone data is available
#'
#' @return The return value is a dummy variable (0 or 1) to indicate whether the data is available
#'
#' @noRd
zone_available <- function(selected_address, series) {
  filtered_addresses <- get_information_address(selected_address, series, "Preis")

  # Total series
  priceSerieTotal <- bind_rows(filtered_addresses[["SerieBZO16"]], filtered_addresses[["SerieBZO99"]])

  if (nrow(priceSerieTotal) > 0) {
    available <- TRUE
  } else {
    available <- FALSE
  }

  return(available)
}
