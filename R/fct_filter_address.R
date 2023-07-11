#' get_information_address 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
get_information_address <- function(data, data2, filter_street, filter_number, target_value = NULL){
  # Pull district
  district <- data %>%
    filter(StrasseLang == filter_street & Hnr == filter_number) %>%
    pull(QuarLang)
  
  # Pull zone BZO16
  zoneBZO16 <- data %>%
    filter(StrasseLang == filter_street & Hnr == filter_number) %>%
    pull(ZoneBZO16Lang)
  
  # Pull zone BZO99
  zoneBZO99 <- data %>%
    filter(StrasseLang == filter_street & Hnr == filter_number) %>%
    pull(ZoneBZO99Lang)
  
  # Price serie BZO16
  SerieBZO16 <- data2 %>%
    filter(
      QuarLang == district & ZoneLang == zoneBZO16,
      if (!is.null(target_value)) Typ == target_value else Typ != "",
      Jahr >= 2019
    ) 
  
  # Price serie BZO99
  SerieBZO99 <- data2 %>%
    filter(
      QuarLang == district & ZoneLang == zoneBZO99,
      if (!is.null(target_value)) Typ == target_value else Typ != "",
      Jahr < 2019
    ) 
  
  return(list(
    district = district,
    zoneBZO16 = zoneBZO16,
    zoneBZO99 = zoneBZO99,
    SerieBZO16 = SerieBZO16,
    SerieBZO99 = SerieBZO99
  ))
}
# test <- get_information_address(data_vector[["addresses"]], data_vector[["series"]], "Heerenwiesen", "24", target_value = "Preis")
# test <- get_information_address(data_vector[["addresses"]], data_vector[["series"]], "Heerenwiesen", "24")



#' filter_address 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
filter_address <- function(data, data2, target_value, filter_street, filter_number){

  #Filter data with function
  data_address <- get_information_address(data, data2, target_value, filter_street, filter_number)
  
  # Total series
  if(target_value == "Preis"){
    SerieTotal <- bind_rows(data_address[["SerieBZO16"]], data_address[["SerieBZO99"]]) %>%
      select(-Typ, -QuarCd, -QuarLang, -ZoneSort, -ZoneLang) %>%
      mutate_all(funs(replace(., . == "–", ""))) %>%
      mutate_at(c(
        "FrQmBodenGanzeLieg", "FrQmBodenStwE", "FrQmBodenAlleHA", "FrQmBodenNettoGanzeLieg",
        "FrQmBodenNettoStwE", "FrQmBodenNettoAlleHA", "FrQmWohnflStwE"
      ), as.numeric)
  }else{
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
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
filter_address_download <- function(data, data2, filter_street, filter_number){
  
  filter_download <- get_information_address(data, data2, filter_street, filter_number)
  
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
