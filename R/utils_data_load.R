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
    
    zone <- prepare_zones(data)
    zones <- mutate_nas(zone[[1]], everything())
    zonesBZO16 <- mutate_nas(zone[[2]], everything())
    zonesBZO99 <- mutate_nas(zone[[3]], everything())

    serie <- prepare_series(data) 
    vars <- c("FrQmBodenGanzeLieg", "FrQmBodenStwE", "FrQmBodenAlleHA")
    series <- mutate_nas(serie[[1]], vars)
    seriestypes <- mutate_nas(serie[[2]], vars)

    addresses <- prepare_data(data)
    
    types <- mutate_nas(prepare_types(data), everything())
    

    return(list(
      zones = zones,
      zonesBZO16 = zonesBZO16,
      zonesBZO99 = zonesBZO99,
      series = series,
      addresses = addresses,
      types = types,
      seriestypes = seriestypes
      ))

  }
}


data_vector <- data_load()
