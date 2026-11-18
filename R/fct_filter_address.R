#' get_information_address
#'
#' @param selected_address dataset addresses filtered according to input
#' @param series series dataset
#' @param target_value  the value has to be either "Preis" or "Zahl", if target_value is NULL then both "Preis" and "Zahl" are filtered
#'
#' @description A function that filters the datasets 'series' and 'zones' according to the given inputs of the street and house number
#'
#' @return The return value is a list containing the district, the zones16 & 99, and the price/count of the ownership transfers
#'
#' @noRd
get_information_address <- function(selected_address, series, target_value = NULL) {
  # Pull district
  district <- selected_address |>
    pull(QuarLang)

  # Pull zone BZO16
  zoneBZO16 <- selected_address |>
    pull(ZoneBZO16Lang)

  # Pull zone BZO99
  zoneBZO99 <- selected_address |>
    pull(ZoneBZO99Lang)

  SerieBZO16 <- series |>
    filter(
      if (length(district) > 0) QuarLang == district else TRUE,
      if (!is.null(target_value)) Typ == target_value else Typ != "",
      Jahr >= 2019,
      if (length(zoneBZO16) > 0) ZoneLang == zoneBZO16 else TRUE
    )
  SerieBZO99 <- series |>
    filter(
      if (length(district) > 0) QuarLang == district else TRUE,
      if (!is.null(target_value)) Typ == target_value else Typ != "",
      Jahr < 2019,
      if (length(zoneBZO99) > 0) ZoneLang == zoneBZO99 else TRUE
    )

  return(list(
    district = district,
    zoneBZO16 = zoneBZO16,
    zoneBZO99 = zoneBZO99,
    SerieBZO16 = SerieBZO16,
    SerieBZO99 = SerieBZO99
  ))
}


#' filter_address_data
#'
#' @param selected_address dataset addresses filtered according to input
#' @param series series dataset
#' @param target_value  the value has to be either "Preis" or "Zahl"
#'
#' @description A function that uses the function get_information_address() to filter the data and then prepares the data for the table output
#'
#' @return The return value is the data for the table that is displayed in the addresses app
#'
#' @noRd
filter_address_data <- function(selected_address, series, target_value) {
  # Filter data with function
  data_address <- get_information_address(selected_address, series, target_value)

  # Total series
  if (target_value == "Preis") {
    SerieTotal <- bind_rows(data_address[["SerieBZO16"]], data_address[["SerieBZO99"]]) |>
      select(-Typ, -QuarCd, -QuarLang, -ZoneSort, -ZoneLang) |>
      mutate(across(everything(), \(x) replace(x, x == "–", ""))) |>
      mutate(across(
        c(
          "FrQmBodenGanzeLieg", "FrQmBodenStwE", "FrQmBodenAlleHA", "FrQmBodenNettoGanzeLieg",
          "FrQmBodenNettoStwE", "FrQmBodenNettoAlleHA"
        ),
        as.numeric
      ))
  } else {
    SerieTotal <- bind_rows(data_address[["SerieBZO16"]], data_address[["SerieBZO99"]]) |>
      select(-Typ, -QuarCd, -QuarLang, -ZoneSort, -ZoneLang) |>
      mutate(across(everything(), \(x) replace(x, x == "", "–")))
  }

  if (nrow(SerieTotal) > 0) {
    DistZone <- SerieTotal
    DistZone
  } else {
    DistZone <- NULL
  }
}
# test <- filter_address(data_vector[["addresses"]], data_vector[["series"]], "Preis", "Heerenwiesen 24")


#' filter_address_download
#'
#' @param addresses address dataset
#' @param series series dataset
#' @param filter_address filter value (street + nr) selected from input widget
#'
#' @description A function that uses the function get_information_address() to filter the data and then prepares the data for the download output
#'
#' @return The return value is the data for the download table that is displayed in the addresses app
#'
#' @noRd
filter_address_download <- function(addresses, series, filter_address) {
  # Filter the address dataset to the selected address first
  selected_address <- addresses |> 
    filter(Adresse == filter_address)
  
  # target_value = NULL returns both prices ("Preis") and counts ("Zahl")
  filter_download <- get_information_address(selected_address, series)

  # Total series
  bind_rows(filter_download[["SerieBZO16"]], filter_download[["SerieBZO99"]]) |>
    select(-QuarCd, -ZoneSort, -ZoneLang) |>
    arrange(
      factor(Typ, levels = c("Preis", "Zahl")),
      desc(Jahr)
    )
}
