#' data_load
#'
#' @description Function to read the three open government datasets on which the app is based
#'
#' @details The sources of the datasets are https://data.stadt-zuerich.ch/dataset/bau_hae_lima_preise_anzahl_hae_art_gebiet_bzo_jahr_grpd_od5142, 
#' https://data.stadt-zuerich.ch/dataset/bau_hae_lima_preise_anzahl_hae_art_gebiet_bzo_jahr_grpd_od5142, https://data.stadt-zuerich.ch/dataset/bau_hae_lima_zuordnung_adr_quartier_bzo16_bzo99_od5143, https://data.stadt-zuerich.ch/dataset/bau_hae_lima_preise_anzahl_hae_art_bebauung_jahr_od5144 and https://data.stadt-zuerich.ch/dataset/bau_hae_lima_preise_anzahl_hae_art_bebauung_jahr_grpd_od5145.
#' 
#' @return a named list of tibbles with zones, series, and addresses
#' @noRd
data_load <- function() {
  
  data <- get_data()
  
  if (!is.null(data)) {
    ### Data Transformation
    
    zone_list <- map(prepare_zones(data), \(x) mutate_nas(x, everything()))

    vars <- c("FrQmBodenGanzeLieg", "FrQmBodenStwE", "FrQmBodenAlleHA")
    serie_list <- map(prepare_series(data), \(x) mutate_nas(x, vars))

    addresses <- prepare_data(data)
    
    types <- mutate_nas(prepare_types(data), everything())
    

    return(list(
      zones = zone_list[[1]],
      zonesBZO16 = zone_list[[2]],
      zonesBZO99 = zone_list[[3]],
      series = serie_list[[1]],
      addresses = addresses,
      types = types,
      seriestypes = serie_list[[2]]
      ))

  }
}


data_vector <- data_load()
