#' download_name 
#'
#' @description A function to generate the name for the download file
#' 
#' @param label label to indicate the chosen app for the download
#' @param reactive_parameters list of reactive parameters used for filtering, order of 
#' parameters has to conform to order of parameters in filter_function, and name 
#' has to be the same as the name as the input id it represents
#'
#' @return The return value is the name for the download
#'
#' @noRd
create_fn_for_download <- function(label, static_parameters, reactive_parameters) {
  if (label == "Bauzonenordnung_und_Quartier") {
    req(
      reactive_parameters$select_street, 
      reactive_parameters$select_number
      )
    district <- static_parameters$addresses %>%
      filter(StrasseLang == reactive_parameters$select_street() & Hnr == reactive_parameters$select_number()) %>%
      pull(QuarLang)
    name <- list(paste0(district))
  } else {
    req(
      reactive_parameters$select_price,
      reactive_parameters$select_group,
      reactive_parameters$select_area
    )
    price <- gsub(" ", "-", reactive_parameters$select_price(), fixed = TRUE)
    group <- gsub(" ", "-", reactive_parameters$select_group(), fixed = TRUE)
    area <- gsub(" ", "-", reactive_parameters$select_area(), fixed = TRUE)
    name <- list(paste0(price, "_", group, "_", area))
  }
  
  sprintf("Liegenschaftenhandel_nach_%s_%s", label, name)
  
}