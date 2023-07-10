#' filter_address 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
get_information_address <- function(data, data2, filter_street, filter_number){
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
  priceSerieBZO16 <- data2 %>%
    filter(
      QuarLang == district & ZoneLang == zoneBZO16,
      Typ == "Preis",
      Jahr >= 2019
    )
  
  # Price serie BZO99
  priceSerieBZO99 <- data2 %>%
    filter(
      QuarLang == district & ZoneLang == zoneBZO99,
      Typ == "Preis",
      Jahr < 2019
    )
  
  return(list(
    district = district,
    zoneBZO16 = zoneBZO16,
    zoneBZO99 = zoneBZO99,
    priceSerieBZO16 = priceSerieBZO16,
    priceSerieBZO99 = priceSerieBZO99
  ))
}
# test <- get_information_address(data_vector[["addresses"]], data_vector[["series"]], "Heerenwiesen", "24")

filter_address <- function(data, data2, select_street, select_number){
  
  # # Pull district
  # district <- addresses %>%
  #   filter(StrasseLang == select_street & Hnr == select_number) %>%
  #   pull(QuarLang)
  # 
  # # Pull zone BZO16
  # zoneBZO16 <- addresses %>%
  #   filter(StrasseLang == select_street & Hnr == select_number) %>%
  #   pull(ZoneBZO16Lang)
  # 
  # # Pull zone BZO99
  # zoneBZO99 <- addresses %>%
  #   filter(StrasseLang == select_street & Hnr == select_number) %>%
  #   pull(ZoneBZO99Lang)
  # 
  # # Price serie BZO16
  # priceSerieBZO16 <- series %>%
  #   filter(
  #     QuarLang == district & ZoneLang == zoneBZO16,
  #     Typ == "Preis",
  #     Jahr >= 2019
  #   )
  # 
  # # Price serie BZO99
  # priceSerieBZO99 <- series %>%
  #   filter(
  #     QuarLang == district & ZoneLang == zoneBZO99,
  #     Typ == "Preis",
  #     Jahr < 2019
  #   )
  
  # Total series
  priceSerieTotal <- bind_rows(priceSerieBZO16, priceSerieBZO99) %>%
    select(-Typ, -QuarCd, -QuarLang, -ZoneSort, -ZoneLang) %>%
    mutate_all(funs(replace(., . == "–", ""))) %>%
    mutate_at(c(
      "FrQmBodenGanzeLieg", "FrQmBodenStwE", "FrQmBodenAlleHA", "FrQmBodenNettoGanzeLieg",
      "FrQmBodenNettoStwE", "FrQmBodenNettoAlleHA", "FrQmWohnflStwE"
    ), as.numeric)
  
  if (nrow(priceSerieTotal) > 0) {
    priceDistZone <- priceSerieTotal
    priceDistZone
  } else {
    priceDistZone <- NULL
  }
}