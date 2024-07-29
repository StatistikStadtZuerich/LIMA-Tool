#' get_information_address 
#'
#' @param addresses address dataset
#' @param series series dataset
#' @param filter_street filters the street with the given input in the app 
#' @param filter_number filters the number with the given input in the app 
#' @param target_value  the value has to be either "Preis" or "Zahl", if target_value is NULL then both "Preis" and "Zahl" are filtered
#'
#' @description A function that filters the datasets 'series' and 'zones' according to the given inputs of the street and house number
#'
#' @return The return value is a list containing the district, the zones16 & 99, and the price/count of the ownership transfers
#'
#' @noRd
get_information_address <- function(addresses, series, filter_street, filter_number, target_value = NULL){
  # filter addresses so it is filtered only once
  filtered_addresses <- addresses %>%
    filter(StrasseLang == filter_street,
           Hnr == filter_number)
  
  # Pull district
  district <- filtered_addresses %>%
    pull(QuarLang)
  
  # Pull zone BZO16
  zoneBZO16 <- filtered_addresses %>%
    pull(ZoneBZO16Lang)
  
  # Pull zone BZO99
  zoneBZO99 <- filtered_addresses %>%
    pull(ZoneBZO99Lang)
  
  priceSerieBZO16  <- series %>%
    filter(
      QuarLang == district,
      if (!is.null(target_value)) Typ == target_value else Typ != "",
      Jahr >= 2019
    ) 
  priceSerieBZO99  <- series %>%
    filter(
      QuarLang == district,
      if (!is.null(target_value)) Typ == target_value else Typ != "",
      Jahr < 2019
    )
  
  # Price serie BZO16
  SerieBZO16 <- priceSerieBZO16 %>%
    filter(ZoneLang == zoneBZO16) 
  
  # Price serie BZO99
  SerieBZO99 <- priceSerieBZO99 %>%
    filter(ZoneLang == zoneBZO99) 
  
  return(list(
    district = district,
    zoneBZO16 = zoneBZO16,
    zoneBZO99 = zoneBZO99,
    SerieBZO16 = SerieBZO16,
    SerieBZO99 = SerieBZO99
  ))
}
# test <- get_information_address(data_vector[["addresses"]], data_vector[["series"]], "Heerenwiesen", "24", target_value = "Preis")
# data_address <- get_information_address(data_vector[["addresses"]], data_vector[["series"]], "Heerenwiesen", "24")



#' filter_address 
#'
#' @param addresses address dataset
#' @param series series dataset
#' @param target_value  the value has to be either "Preis" or "Zahl"
#' @param filter_street filters the street with the given input in the app 
#' @param filter_number filters the number with the given input in the app 
#'
#' @description A function that uses the function get_information_address() to filter the data and then prepares the data for the table output
#'
#' @return The return value is the data for the table that is displayed in the addresses app
#'
#' @noRd
filter_address <- function(addresses, series, target_value, filter_street, filter_number){

  #Filter data with function
  data_address <- get_information_address(addresses, series, filter_street, filter_number, target_value)
  
  # Total series
  if (target_value == "Preis") {
    SerieTotal <- bind_rows(data_address[["SerieBZO16"]], data_address[["SerieBZO99"]]) %>%
      select(-Typ, -QuarCd, -QuarLang, -ZoneSort, -ZoneLang) %>%
      mutate(across(everything(), \(x) replace(x, x == "–", ""))) %>%
      mutate(across(c(
        "FrQmBodenGanzeLieg", "FrQmBodenStwE", "FrQmBodenAlleHA", "FrQmBodenNettoGanzeLieg",
        "FrQmBodenNettoStwE", "FrQmBodenNettoAlleHA"
      ), 
      as.numeric))
  } else {
    SerieTotal <- bind_rows(data_address[["SerieBZO16"]], data_address[["SerieBZO99"]]) %>%
      select(-Typ, -QuarCd, -QuarLang, -ZoneSort, -ZoneLang)
  }
  
  
  if (nrow(SerieTotal) > 0) {
    DistZone <- SerieTotal
    DistZone
  } else {
    DistZone <- NULL
  }
}
# test <- filter_address(data_vector[["addresses"]], data_vector[["series"]], "Preis", "Heerenwiesen", "24")


#' filter_address_download 
#'
#' @param addresses address dataset
#' @param series series dataset
#' @param filter_street filters the street with the given input in the app 
#' @param filter_number filters the number with the given input in the app
#'
#' @description A function that uses the function get_information_address() to filter the data and then prepares the data for the download output
#'
#' @return The return value is the data for the download table that is displayed in the addresses app
#'
#' @noRd
filter_address_download <- function(addresses, series, filter_street, filter_number){
  
  filter_download <- get_information_address(addresses, series, filter_street, filter_number)
  
  # Total series
  seriesPriceCount <- bind_rows(filter_download[["SerieBZO16"]], filter_download[["SerieBZO99"]]) %>%
    select(-QuarCd, -ZoneSort, -ZoneLang) %>%
    arrange(
      factor(Typ, levels = c(
        "Preis",
        "Zahl"
      )),
      desc(Jahr)
    )
  return(seriesPriceCount)
}
# test <- filter_address_download(data_vector[["addresses"]], data_vector[["series"]], "Heerenwiesen", "24")


#' filter_address_info 
#'
#' @param addresses address dataset
#' @param filter_street filters the street with the given input in the app 
#' @param filter_number filters the number with the given input in the app
#'
#' @description A function that filter the address, quarter and zone for the given address
#'
#' @return The return value is the data for the download table that is displayed in the addresses app
#'
#' @noRd
filter_address_info <- function(addresses, filter_street, filter_number){
  filtered_data <- addresses %>%
    filter(StrasseLang == filter_street & Hnr == filter_number) %>%
    mutate(Adresse = paste0(StrasseLang, " ", Hnr)) %>%
    select(Adresse, QuarLang, Zones) %>%
    pivot_longer(everything()) %>%
    mutate(name = case_when(
      name == "Adresse" ~ "Die Adresse",
      name == "QuarLang" ~ "liegt im Quartier",
      name == "Zones" ~ "in folgender Zone"
    )) %>%
    kable("html",
          align = "lr",
          col.names = NULL
    ) %>%
    kable_styling(bootstrap_options = c("condensed"))
  
  return(filtered_data)
}


#' display_info 
#'
#' @param data_available indicates if there is available data
#' @param addresses address dataset
#' @param series series dataset
#' @param filter_street filters the street with the given input in the app 
#' @param filter_number filters the number with the given input in the app
#'
#' @description A function that uses the function get_information_address() to filter the data and then prepares the data for the title of the table in the app output
#'
#' @return The return value is the data for the download table that is displayed in the addresses app
#'
#' @noRd
display_info <- function(data_available, addresses, series, filter_street, filter_number){
  if (data_available > 0) {
    filtered_addresses <- get_information_address(addresses, series, filter_street, filter_number, "Preis")
    
    zones <- paste0(filtered_addresses[["zoneBZO16"]], " (bis 2018: ", filtered_addresses[["zoneBZO99"]], ")")
    infoTitle <- paste0("Medianpreise und Handänderungen im Quartier ", filtered_addresses[["district"]], ", in der ", zones)
  } else {
    infoTitle <- paste0("Die gewünschte Adresse liegt nicht in einer Wohn- oder Mischzone (Kernzone, Zentrumszone, Quartiererhaltungszone).\nWählen Sie eine andere Adresse und machen Sie eine erneute Abfrage.")
  }
}