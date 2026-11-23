#' reactable_area
#'
#' @description A function that renders the correct setting for the reactable() table for the area app
#'
#' @param target_data the filtered dataset that is displayed in the table
#' @param pagesize is 5 for BZO16 and 15 for BZO99
#'
#' @return The return value is the styled reactable table that needs a data input
#'
#' @noRd
reactable_area <- function(target_data, pagesize) {
  reactable(target_data,
    class = "table-striped",
    columns = list(
      Jahr = colDef(name = "Jahr", align = "left", sticky = "left", minWidth = 65)
    ),
    defaultColDef = colDef(
      align = "right",
      minWidth = 100,
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
    defaultPageSize = pagesize
  )
}
#' reactable_area_types
#'
#' @description A function that renders the correct setting for the reactable() table for the area types app
#'
#' @param target_data the filtered dataset that is displayed in the table
#' @param pagesize is 5 for BZO16 and 15 for BZO99
#'
#' @return The return value is the styled reactable table that needs a data input
#'
#' @noRd
reactable_area_types <- function(target_data, pagesize) {
  reactable(target_data,
    class = "table-striped",
    theme = reactableTheme(
      borderColor = "#DEDEDE"
    ),
    columns = list(
      Jahr = colDef(name = "Jahr", align = "left", sticky = "left", minWidth = 65),
      EFH = colDef(name = "EFH"),
      MFH = colDef(name = "MFH"),
      WHG = colDef(name = "WGR"),
      UWH = colDef(name = "UWH"),
      NB = colDef(name = "NUB"),
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
        name = "Industrie\u2011\nund Gewerbe\u2011\nzone",
        columns = "IGZ",
        align = "left",
        headerVAlign = "bottom"
      ),
      colGroup(
        name = "Übriges Gebiet",
        columns = "UG",
        align = "left",
        headerVAlign = "bottom"
      )
    ),
    defaultColDef = colDef(
      align = "right",
      minWidth = 100,
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
    defaultPageSize = pagesize
  )
}
