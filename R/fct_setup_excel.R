#' setup_excel 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
setup_excel <- function(query_input, hauptPfad, input1, input2, input3 = NULL) {
  
  sheet_num <- switch(
    query_input,
    "1" = 2,
    "2" = 3,
    "3" = 4
  )
  
  title_num <- switch(
    query_input,
    "1" = "Grundstückspreise (Median) nach Zonenart für Ihre Auswahl: ",
    "2" = "Grundstückspreise (Median) nach Bebauungsart für Ihre Auswahl: ",
    "3" = "Grundstückspreise (Median) für Ihre Adresseingabe: "
  )
  
  inputs_num <- switch(
    query_input,
    "1" = paste0(input1, ", ", input2, ", ", input3),
    "2" = paste0(input1, ", ", input2, ", ", input3),
    "3" = paste0(input1, " ", input2)
  )
  print(inputs_num)
  
  data <-  paste0(title_num, inputs_num)
      # Titel = ifelse(is.na(Titel), NA, paste0(title_num, inputs_num))
    #   Titel = "ABC"
    # )
  print(data)
  
  selected <- list(
    c(
      "T_1",
      title_num,
      paste0(title_num, inputs_num),
      " ",
      "Quelle: Statistik Stadt Zürich, GWZ"
    )
  ) %>%
    as.data.frame()
  
  definitions <- read_excel(hauptPfad, sheet = sheet_num)
  
  return(list(data, selected, definitions))
  
}
# test <- setup_excel("1", "inst/app/www/Titelblatt.xlsx", "Ganze Stadt", "Preis pro m² Grundstücksfläche", "Ganze Liegenschaften")
