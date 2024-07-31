#' filter_area_zone 
#'
#' @description A function that filters the dataset 'zones' according to the given inputs of the area, price and group
#'
#' @param target_app the value has to be either "Zones" or "Types"
#' @param zones dataset zones
#' @param target_value the value has to be either "Preis" or "Zahl"
#' @param filter_area filters the area with the given input in the app
#' @param filter_price filters the price with the given input in the app
#' @param filter_group filters the group with the given input in the app
#' @param BZO_year the value has to be either "BZO16" or "BZO99"
#'
#' @return The return value is the data for the table that is displayed in the area app
#'
#' @noRd
filter_area_zone <- function(target_app, zones, target_value, filter_area, filter_price, filter_group, BZO_year){
  
  if (target_app == "Zones"){
    filtered <- zones %>%
      filter(
        Typ == target_value,
        GebietLang == filter_area,
        PreisreiheLang == filter_price,
        ArtLang == filter_group,
        BZO == BZO_year
      ) %>%
      select(BZO, Jahr, ALLE, ZE, KE, QU, W2, W23, W34, W45, W56) %>% 
      rename(Total = ALLE,
             Z = ZE,
             K = KE,
             Q = QU)
    
    if (unique(filtered$BZO) == "BZO16") {
      filtered <- filtered  %>% 
        rename(W3 = W23,
               W4 = W34,
               W5 = W45,
               W6 = W56) %>% 
        select(-BZO)
    } else {
      filtered <- filtered  %>% 
        rename(` ` = W2,
               W2 = W23,
               W3 = W34,
               W4 = W45,
               W5 = W56) %>% 
        select(-BZO)
    }
    if (target_value == "Preis") {
      filtered <- filtered %>%
        mutate(across(c(everything(), -Jahr), as.numeric))
    } else {
      filtered <- filtered %>% 
        mutate_all(., ~ replace(., is.na(.), " "))
    }
  } else {
    filtered <- zones %>%
      filter(
        Typ == target_value,
        GebietLang == filter_area,
        PreisreiheLang == filter_price,
        ArtLang == filter_group,
      ) %>% 
      select(Jahr, EFH, MFH, WHG, UWH, NB, UNB, IGZ, UG)
    if (target_value == "Preis") {
      filtered <- filtered %>%
        mutate(across(c(everything(), -Jahr), as.numeric))
    } else {
      filtered <- filtered %>% 
        mutate_all(., ~ replace(., is.na(.), " "))
    }
  }
}
# data_types <- data_vector[["types"]]
# test <- filter_area_zone("Zones", data_vector[["zones"]], "Zahl", "Rathaus", "Preis pro m² Grundstücksfläche", "Ganze Liegenschaften", "BZO16")
# test2 <- filter_area_zone("Types", data_vector[["types"]], "Zahl", "Rathaus", "Preis pro m² Grundstücksfläche", "Ganze Liegenschaften")


#' filter_area_download 
#'
#' @description A fct function
#'
#' @param zones dataset zones
#' @param filter_area filters the area with the given input in the app
#' @param filter_price filters the price with the given input in the app
#' @param filter_group filters the group with the given input in the app
#'
#' @return The return value is the data for the download table that is displayed in the area app
#'
#' @noRd
filter_area_download <- function(zones, filter_area, filter_price, filter_group){
  zones %>%
    filter(
      GebietLang == filter_area,
      PreisreiheLang == filter_price,
      ArtLang == filter_group
    ) %>%
    select(-PreisreiheSort, -ArtSort, -GebietSort)
}

