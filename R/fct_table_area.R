#' reactable_area 
#'
#' @description A fct function to create the tables for the area apps
#' 
#' @param target_value Preis or Zahl
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
reactable_area <- function(target_value, pagesize){
  reactable(target_value,
            theme = reactableTheme(
              borderColor = "#DEDEDE"
            ),
            columns = list(
              Jahr = colDef(name = "Jahr", align = "left")
            ),
            defaultColDef = colDef(
              align = "right",
              minWidth = 50,
              cell = function(value) {
                # Format only numeric columns with thousands separators
                if (!is.numeric(value)) {
                  return(value)
                }
                if (!is.na(value)) {
                  format(value, big.mark = "\ua0")
                } else {
                  "–"
                }
              }
            ),
            outlined = TRUE,
            highlight = TRUE,
            defaultPageSize = pagesize,
            rowClass = JS("function(rowInfo) {return rowInfo.selected ? 'selected' : ''}"),
            rowStyle = JS("function(rowInfo) {if (rowInfo.selected) { return { backgroundColor: '#F2F2F2'}}}"))
}