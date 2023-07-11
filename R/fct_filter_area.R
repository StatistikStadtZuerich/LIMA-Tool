#' filter_area_zone 
#'
#' @description A fct function
#' @param target_value Preis or Zahl
#' @param data zonesBZO16 or zonesBZO99
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
filter_area_zone <- function(data, target_value, filter_area, filter_price, filter_group, BZO_year){
  
  filtered <- data %>%
    filter(
      Typ == target_value,
      GebietLang == filter_area,
      PreisreiheLang == filter_price,
      ArtLang == filter_group,
      BZO == BZO_year
    ) 
  
  if (unique(filtered$BZO) == "BZO16") {
    filtered <- filtered %>%
      select(Jahr, ALLE, ZE, KE, QU, W2, W23, W34, W45, W56) %>% 
      rename(Total = ALLE,
             Z = ZE,
             K = KE,
             Q = QU,
             W3 = W23,
             W4 = W34,
             W5 = W45,
             W6 = W56)
  } else {
    filtered <- filtered %>%
      select(Jahr, ALLE, ZE, KE, QU, W2, W23, W34, W45, W56) %>% 
      rename(Total = ALLE,
             Z = ZE,
             K = KE,
             Q = QU,
             ` ` = W2,
             W2 = W23,
             W3 = W34,
             W4 = W45,
             W5 = W56)
  }
  if (target_value == "Preis") {
    if(max(filtered$Jahr) > 2018){
      filtered <- filtered %>%
        suppressWarnings(mutate_at(vars(-Jahr), as.numeric))
    } else {
      filtered <- filtered %>%
        suppressWarnings(mutate_at(vars(-Jahr, -` `), as.numeric))
    }
  } else {
    filtered <- filtered %>%
      mutate_all(., ~ replace(., is.na(.), " "))
  }
  return(filtered)
}
# test <- filter_area_zone(data_vector[["zones"]], "Preis", "Rathaus", "Preis pro m² Grundstücksfläche", "Ganze Liegenschaften", "BZO16")
# data_zones <- data_vector[["zones"]]

#' filter_area_download 
#'
#' @description A fct function
#' @param data zones
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
filter_area_download <- function(data, filter_area, filter_price, filter_group){
  filtered <- data %>%
    filter(
      GebietLang == filter_area,
      PreisreiheLang == filter_price,
      ArtLang == filter_group
    ) %>%
    select(Typ, GebietLang, PreisreiheLang, ArtLang, BZO, Jahr, ALLE, ZE, KE, QU, W2, W23, W34, W45, W56)
  return(filtered)
}
