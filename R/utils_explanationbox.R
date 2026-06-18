#' explanationbox
#'
#' @description A utils function to display the explanation box of the according app
#'
#' @return The return value is a div that is called and rendered in the according app
#'
#' @noRd
explanationbox_app1 <- function() {
  items <- c(
    paste0("<span class='bold-text'>Z</span>: Zentrumszone"),
    paste0("<span class='bold-text'>K</span>: Kernzone"),
    paste0("<span class='bold-text'>Q</span>: Quartiererhaltungszone"),
    paste0("<span class='bold-text'>W2</span>: Wohnzone 2"),
    paste0("<span class='bold-text'>W3</span>: Wohnzone 3"),
    paste0("<span class='bold-text'>W4</span>: Wohnzone 4"),
    paste0("<span class='bold-text'>W5</span>: Wohnzone 5")
  )
  sszContextBox(
    title = "Erklärung Zonenarten",
    text = HTML(paste(items, collapse = "<br>"))
  )
}
explanationbox_app2 <- function() {
  items <- c(
    paste0("<span class='bold-text'>EFH</span>: Einfamilienhäuser"),
    paste0("<span class='bold-text'>MFH</span>: Mehrfamilienhäuser"),
    paste0("<span class='bold-text'>WGR</span>: Wohnhäuser mit Geschäftsräumen"),
    paste0("<span class='bold-text'>UWH</span>: Übrige Wohnhäuser"),
    paste0("<span class='bold-text'>NUB</span>: Nutzbauten in Wohn- und Mischzonen"),
    paste0("<span class='bold-text'>UNB</span>: Unbebaut in Wohn- und Mischzonen")
  )

  sszContextBox(
    title = "Erklärung Bebauungsarten",
    text = HTML(paste(items, collapse = "<br>"))
  )
}
explanationbox_app3 <- function() {
  items <- c(
    paste0("<span class='bold-text'>StwE</span>: Stockwerkeigentum"),
    paste0("<span class='bold-text'>VersW</span>: Versicherungswert des Gebäudes")
  )

  sszContextBox(
    title = "Begriffserklärung",
    text = HTML(paste(items, collapse = "<br>"))
  )
}
