#' reactable_area 
#'
#' @description A fct function that renders the correct setting for the reactable() table for the area app
#' 
#' @param target_data the filtered dataset that is displayed in the table
#' @param pagesize is 5 for BZO16 and 15 for BZO99
#'
#' @return The return value is the styled reactable table that needs a data input
#'
#' @noRd
reactable_area <- function(target_data, pagesize){
  reactable(target_data,
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
                } else if (!is.na(value)) {
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
#' reactable_area_types 
#'
#' @description A fct function that renders the correct setting for the reactable() table for the area types app
#' 
#' @param target_data the filtered dataset that is displayed in the table
#' @param pagesize is 5 for BZO16 and 15 for BZO99
#'
#' @return The return value is the styled reactable table that needs a data input
#'
#' @noRd
reactable_area_types <- function(target_data, pagesize){
  reactable(target_data,
            theme = reactableTheme(
              borderColor = "#DEDEDE"
            ),
            columns = list(
              Jahr = colDef(name = "Jahr", align = "left"),
              EFH = colDef(name = "EFH"),
              MFH = colDef(name = "MFH"),
              WHG = colDef(name = "WGR"),
              UWH = colDef(name = "UWH"),
              NB = colDef(name = "NB"),
              UNB = colDef(name = "UNB"),
              IGZ = colDef(name = ""),
              UG = colDef(name = "")
            ),
            columnGroups = list(
              colGroup(
                name = "Wohn- und Mischzone",
                columns = c("EFH", "MFH", "WHG", "UWH", "NB", "UNB"),
                align = "left",
                headerVAlign = "bottom"
              ),
              colGroup(
                name = "Indu-\nstrie und Ge-\nwerbe Zone",
                columns = "IGZ",
                align = "left",
                headerVAlign = "bottom"
              ),
              colGroup(
                name = "Übrige Zonen",
                columns = "UG",
                align = "left",
                headerVAlign = "bottom"
              )
            ),
            defaultColDef = colDef(
              align = "right",
              minWidth = 50,
              cell = function(value) {
                # Format only numeric columns with thousands separators
                if (!is.numeric(value)) {
                  return(value)
                } else if (!is.na(value)) {
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