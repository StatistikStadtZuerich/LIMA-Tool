#' table_address 
#'
#' @param target_data the filtered dataset that is displayed in the table
#'
#' @description A fct function that renders the correct setting for the reactable() table for the addresses app
#'
#' @return The return value is the styled reactable table that needs a data input
#'
#' @noRd
reactable_address <- function(target_data){
  reactable(target_data,
            theme = reactableTheme(
              borderColor = "#DEDEDE"
            ),
            columns = list(
              Jahr = colDef(name = "Jahr", align = "left"),
              FrQmBodenGanzeLieg = colDef(name = "Ganze Liegen-\nschaften"),
              FrQmBodenStwE = colDef(name = "StwE"),
              FrQmBodenAlleHA = colDef(name = "Alle Verkäufe"),
              FrQmBodenNettoGanzeLieg = colDef(name = "Ganze Liegen-\nschaften"),
              FrQmBodenNettoStwE = colDef(name = "StwE"),
              FrQmBodenNettoAlleHA = colDef(name = "Alle Verkäufe"),
              FrQmWohnflStwE = colDef(name = "")
            ),
            columnGroups = list(
              colGroup(
                name = "Preise pro m² Boden",
                columns = c("FrQmBodenGanzeLieg", "FrQmBodenStwE", "FrQmBodenAlleHA"),
                align = "right",
                headerVAlign = "bottom"
              ),
              colGroup(
                name = "Preise pro m² Boden abzgl. VersW",
                columns = c("FrQmBodenNettoGanzeLieg", "FrQmBodenNettoStwE", "FrQmBodenNettoAlleHA"),
                align = "right",
                headerVAlign = "bottom"
              ),
              colGroup(
                name = "StwE pro m² Wohnungsfläche (alle Zonen)",
                columns = "FrQmWohnflStwE",
                align = "right",
                headerVAlign = "bottom"
              )
            ),
            defaultColDef = colDef(
              align = "right",
              headerVAlign = "bottom",
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
            defaultPageSize = 15,
            rowClass = JS("function(rowInfo) {return rowInfo.selected ? 'selected' : ''}"),
            rowStyle = JS("function(rowInfo) {if (rowInfo.selected) { return { backgroundColor: '#F2F2F2'}}}")
  )
}
