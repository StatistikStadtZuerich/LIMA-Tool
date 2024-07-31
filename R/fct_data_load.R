#' import_data_from_ogd 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
import_data_from_ogd <- function() {
  
  ## URLS
  URLs <- c(
    "https://data.stadt-zuerich.ch/dataset/bau_hae_lima_preise_anzahl_hae_art_gebiet_bzo_jahr_od5141/download/BAU514OD5141.csv",
    "https://data.stadt-zuerich.ch/dataset/bau_hae_lima_preise_anzahl_hae_art_gebiet_bzo_jahr_grpd_od5142/download/BAU514OD5142.csv",
    "https://data.stadt-zuerich.ch/dataset/bau_hae_lima_zuordnung_adr_quartier_bzo16_bzo99_od5143/download/BAU514OD5143.csv",
    "https://data.stadt-zuerich.ch/dataset/bau_hae_lima_preise_anzahl_hae_art_bebauung_jahr_od5144/download/BAU514OD5144.csv",
    "https://data.stadt-zuerich.ch/dataset/bau_hae_lima_preise_anzahl_hae_art_bebauung_jahr_grpd_od5145/download/BAU514OD5145.csv"
  )
  
  # Applying tryCatch
  tryCatch(
    expr = { # Specifying expression
      # By default the data frame is empty
      data <- NULL
      
      ## Download
      dataDownload <- function(link) {
        data <- fread(link, encoding = "UTF-8"
        )
        
        return(data)
      }
      
      # Parallelisation
      data <- future_map(URLs, dataDownload)
      
      return(data)
    },
    error = function(e) { # Specifying error message
      message("Error in Data Load")
      return(NULL)
    },
    warning = function(w) { # Specifying warning message
      message("Warning in Data Load")
    }
  )
}

#' prepare_zones 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
prepare_zones <- function(dat) {
  ## Zones
  zones <- dat[[1]] |> 
    mutate(PreisreiheLang = case_when(PreisreiheSort == 41 ~ "Preis pro m\u00B2 Grundstücksfläche",
                                      PreisreiheSort == 42 ~ "Preis pro m\u00B2 Grundstücksfläche, abzgl. Versicherungswert",
                                      PreisreiheSort == 49 ~ "Stockwerkeigentum pro m\u00B2 Wohnungsfläche")) |> 
    mutate(ArtLang = case_when(
      ArtLang == "Ganze Liegenschaft" ~ "Ganze Liegenschaften",
      TRUE ~ ArtLang))
  
  ## BZO16
  zonesBZO16 <- zones |> 
    filter(BZO == "BZO16") |> 
    rename(
      Total = ALLE,
      Z = ZE,
      K = KE,
      Q = QU,
      W2 = W2,
      W3 = W23,
      W4 = W34,
      W5 = W45,
      W6 = W56
    ) 
  
  ## BZO99
  zonesBZO99 <- zones |> 
    filter(BZO == "BZO99") |> 
    rename(
      Total = ALLE,
      Z = ZE,
      K = KE,
      Q = QU,
      ` ` = W2,
      W2 = W23,
      W3 = W34,
      W4 = W45,
      W5 = W56
    ) 
  
  return(list(
    zones = zones,
    zonesBZO16 = zonesBZO16,
    zonesBZO99 = zonesBZO99
  ))
}

#' prepare_series 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
prepare_series <- function(dat) {
  series <- dat[[2]] 
  
  seriestypes <- dat[[5]]
  
  list(
    series = series,
    seriestypes = seriestypes
  )
}

#' prepare_addresses 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
prepare_data <- function(dat) {
  dat[[3]] |> 
    mutate(Zones = case_when(
      ZoneBZO16Lang == ZoneBZO99Lang ~ paste(ZoneBZO16Lang),
      TRUE ~ paste0(ZoneBZO16Lang, " (bis 2018: ", ZoneBZO99Lang, ")")
    )) |>  
    mutate(ZoneBZO99Lang = case_when(
      ZoneBZO99Lang == "Wohnzone 2" ~ "Wohnzonen 2",
      ZoneBZO99Lang == "Wohnzone 3" ~ "Wohnzonen 3",
      ZoneBZO99Lang == "Wohnzone 4" ~ "Wohnzonen 4",
      ZoneBZO99Lang == "Wohnzone 5" ~ "Wohnzonen 5",
      TRUE ~ ZoneBZO99Lang
    ))
}


#' prepare_types 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
prepare_types <- function(dat) {
  ## Building Type
  dat[[4]] |> 
    mutate(PreisreiheLang = case_when(PreisreiheSort == 41 ~ "Preis pro m\u00B2 Grundstücksfläche",
                                      PreisreiheSort == 42 ~ "Preis pro m\u00B2 Grundstücksfläche, abzgl. Versicherungswert",
                                      PreisreiheSort == 49 ~ "Stockwerkeigentum pro m\u00B2 Wohnungsfläche")) |> 
    mutate(ArtLang = case_when(ArtSort == 31 ~ "Ganze Liegenschaften",
                               ArtSort == 32 ~ "Nur Stockwerkeigentum",
                               ArtSort == 39 ~ "Alle Handänderungen")) 
}

#' mutate_nas 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
mutate_nas <- function(dat, mutate_where) {
  dat |> 
    mutate(across(everything(), \(x) replace(x, x == ".", "–")))  |> 
    mutate(across(mutate_where, \(x) replace(x, x == "", "–")))
}