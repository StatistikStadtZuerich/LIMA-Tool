#' filter_area_zone 
#'
#' @description A fct function
#' @param output_value Preis or Zahl
#' @param data zonesBZO16 or zonesBZO99
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
filter_area_zone <- function(output_value, data){
  
  filtered <- data %>%
    filter(
      Typ == output_value,
      GebietLang == input$area,
      PreisreiheLang == input$price,
      ArtLang == input$group
    ) 
  
  if (unique(filtered$BZO) == "BZO16") {
    filtered <- filtered %>%
      select(Jahr, Total, Z, K, Q, W2, W3, W4, W5, W6) 
  } else {
    filtered <- filtered %>%
      select(Jahr, Total, Z, K, Q, ` `, W2, W3, W4, W5) 
  }
  if (output_value == "Preis") {
    if(max(filtered$Jahr) > 2018){
      filtered <- filtered %>%
        mutate_at(vars(-Jahr), as.numeric)
    } else {
      filtered <- filtered %>%
        mutate_at(vars(-Jahr, -` `), as.numeric)
    }
  } else {
    filtered <- filtered %>%
      mutate_all(., ~ replace(., is.na(.), " "))
  }
  return(filtered)
}
