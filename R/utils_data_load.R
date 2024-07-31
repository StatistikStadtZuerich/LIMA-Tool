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
  
  data <- import_data_from_ogd()
  
  if (!is.null(data)) {
    ### Data Transformation
    
    zones_list <- map(prepare_zones(data), \(x) mutate_nas(x, everything()))

    na_vars <- c("FrQmBodenGanzeLieg", "FrQmBodenStwE", "FrQmBodenAlleHA")
    series_list <- map(prepare_series(data), \(x) mutate_nas(x, na_vars))

    addresses <- prepare_data(data)
    
    types <- mutate_nas(prepare_types(data), everything())
    
    list(
      zones = zones_list[[1]],
      zonesBZO16 = zones_list[[2]],
      zonesBZO99 = zones_list[[3]],
      series = series_list[[1]],
      addresses = addresses,
      types = types,
      seriestypes = series_list[[2]]
      )
  }
}


data_vector <- data_load()
