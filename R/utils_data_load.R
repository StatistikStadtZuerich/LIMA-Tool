#' import_data_from_ogd
#'
#' @description Function to read the five open government datasets on which the app is based
#'
#' @return  a list of 5 dataframes, in the order of the BAU514 OGD outputs
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
        data <- fread(link, encoding = "UTF-8", showProgress = FALSE)

        return(data)
      }

      # Parallelisation
      data <- map(URLs, dataDownload)

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
#' @param df_od5141 data.frame, read from OD5141 OGD
#'
#' @description A function that prepares and filters the data sources by OGD
#'
#' @return a named list of tibbles with zones, zonesBZO16, and zonesBZO99
#'
#' @noRd
prepare_zones <- function(df_od5141) {
  ## Zones
  zones <- df_od5141 |>
    mutate(PreisreiheLang = case_when(
      PreisreiheSort == 41 ~ "Preis pro m\u00B2 Grundstücksfläche",
      PreisreiheSort == 42 ~ "Preis pro m\u00B2 Grundstücksfläche, abzgl. Versicherungswert",
      PreisreiheSort == 49 ~ "Stockwerkeigentum pro m\u00B2 Wohnungsfläche"
    )) |>
    mutate(ArtLang = case_when(
      ArtLang == "Ganze Liegenschaft" ~ "Ganze Liegenschaften",
      TRUE ~ ArtLang
    ))

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
#' @param df_od5142 data.frame, read from OD5142 OGD
#' @param df_od5145 data.frame, read from OD5145 OGD
#'
#' @description A function that prepares and filters the data sources by series
#'
#' @return a named list of tibbles with series, and seriestypes
#'
#' @noRd
prepare_series <- function(df_od5142, df_od5145) {
  series <- df_od5142

  seriestypes <- df_od5145

  list(
    series = series,
    seriestypes = seriestypes
  )
}

#' prepare_addresses
#'
#' @param df_address_ogd dataframe, csv read from BAU515 OD5143
#'
#' @description A function to prepare the address dataset
#'
#' @return a dataframe with some mutations
#'
#' @noRd
prepare_data <- function(df_address_ogd) {
  df_address_ogd |>
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
    )) |>
    # create combined column of Strasse and Nummer, order by numeric part of number
    mutate(
      Hnr_numeric = as.numeric(str_remove_all(Hnr, "\\D")),
      Adresse = paste(StrasseLang, Hnr, sep = " ")
    ) |>
    arrange(StrasseLang, Hnr_numeric, Hnr)
}


#' prepare_types
#' @param df_od5144 data.frame, read from OGD CSV OD5144
#'
#' @description A function that prepares and filters the data sources by OGD
#'
#' @return return the prepared types data
#'
#' @noRd
prepare_types <- function(df_od5144) {
  ## Building Type
  df_od5144 |>
    mutate(PreisreiheLang = case_when(
      PreisreiheSort == 41 ~ "Preis pro m\u00B2 Grundstücksfläche",
      PreisreiheSort == 42 ~ "Preis pro m\u00B2 Grundstücksfläche, abzgl. Versicherungswert",
      PreisreiheSort == 49 ~ "Stockwerkeigentum pro m\u00B2 Wohnungsfläche"
    )) |>
    mutate(ArtLang = case_when(
      ArtSort == 31 ~ "Ganze Liegenschaften",
      ArtSort == 32 ~ "Nur Stockwerkeigentum",
      ArtSort == 39 ~ "Alle Handänderungen"
    ))
}
