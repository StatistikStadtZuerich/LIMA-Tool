#' sszDownloadExcel
#'
#' @param filteredData the filtered dataset that is displayed in the download
#' @param file filename
#' @param queryinput selected app (the layout differs slightly depending on the app)
#' @param input1 selected input nr. 1 from app
#' @param input2 selected input nr. 2 from app
#' @param input3 selected input nr. 3 from app (optional)
#'
#' @description A utils function to prepare the Excel download file
#'
#' @return The return value is a function that is called in the module to render the Excel download
#' 
#' @noRd
sszDownloadExcel <- function(filteredData, file, queryinput, input1, input2, input3 = NULL) {
  
  # Data Paths
  hauptPfad <- "inst/app/www/Titelblatt.xlsx"
  imagePfad <- "inst/app/www/logo_stzh_stat_sw_pos_1.png"
  
  
  # Manipulate Data for the two queries
  res <- setup_excel(queryinput, hauptPfad, input1, input2, input3)
  data <- res[[1]]
  selected <- res[[2]]
  definitions <- res[[3]]
  
  # Styling
  sty <- createStyle(fgFill = "#ffffff")
  styConcept <- createStyle(
    textDecoration = c("bold"),
    valign = "top",
    wrapText = TRUE
  )
  styDefinition <- createStyle(
    valign = "top",
    wrapText = TRUE
  )
  styTitle <- createStyle(
    fontName = "Arial Black"
  )
  styNumeric <- createStyle(
    halign = "right"
  )
  
  # Create Workbook
  wb <- createWorkbook()
  
  # Add Sheets
  addWorksheet(wb, sheetName = "Inhalt", gridLines = FALSE)
  addWorksheet(wb, sheetName = "Erläuterungen", gridLines = TRUE)
  addWorksheet(wb, sheetName = "T_1", gridLines = TRUE)
  
  # Write Table Sheet 1
  writeData(wb,
            sheet = 1, x = data,
            colNames = FALSE, rowNames = FALSE,
            startCol = 2,
            startRow = 7,
            withFilter = FALSE
  )
  
  # Write Table Sheet 2
  writeData(wb,
            sheet = 2, x = definitions,
            colNames = FALSE, rowNames = FALSE,
            startCol = 1,
            startRow = 1,
            withFilter = FALSE
  )
  
  # Write Table Sheet 3
  writeData(wb,
            sheet = 3, x = selected,
            colNames = FALSE, rowNames = FALSE,
            startCol = 1,
            startRow = 1,
            withFilter = FALSE
  )
  writeData(wb,
            sheet = 3, x = filteredData,
            colNames = TRUE, rowNames = FALSE,
            startCol = 1,
            startRow = 9,
            withFilter = FALSE
  )
  
  # Insert Plot on Sheet 1
  insertImage(wb, imagePfad, sheet = 1, startRow = 2, startCol = 2, width = 1.75, height = 0.35)
  
  # Add Styling
  addStyle(wb, 1, style = sty, row = 1:19, cols = 1:6, gridExpand = TRUE)
  addStyle(wb, 1, style = styTitle, row = 14, cols = 2, gridExpand = TRUE)
  addStyle(wb, 2, style = styConcept, row = 1:20, cols = 1, gridExpand = TRUE)
  addStyle(wb, 2, style = styDefinition, row = 1:20, cols = 2, gridExpand = TRUE)
  addStyle(wb, 3, style = styConcept, row = 9, cols = 1:50, gridExpand = TRUE)
  
  # Numeric values: different columns in the two queries
  if (queryinput == "Abfrage 1: Zeitreihen nach Bauzonen für ganze Stadt und Teilgebiete") {
    addStyle(wb, 3, style = styNumeric, rows = 10:50, cols = 6:15, gridExpand = TRUE)
  } else {
    addStyle(wb, 3, style = styNumeric, rows = 10:50, cols = 4:10, gridExpand = TRUE)
  }
  
  modifyBaseFont(wb, fontSize = 8, fontName = "Arial")
  
  # Set Column Width
  setColWidths(wb, sheet = 1, cols = "A", widths = 1)
  setColWidths(wb, sheet = 1, cols = "B", widths = 4)
  setColWidths(wb, sheet = 1, cols = "D", widths = 40)
  setColWidths(wb, sheet = 1, cols = "5", widths = 8)
  setColWidths(wb, sheet = 2, cols = "A", widths = 40)
  setColWidths(wb, sheet = 2, cols = "B", widths = 65)
  
  # Column widths: different columns in the two queries
  if (queryinput == "Abfrage 1: Zeitreihen nach Bauzonen für ganze Stadt und Teilgebiete") {
    setColWidths(wb, sheet = 3, cols = "C", widths = 30)
    setColWidths(wb, sheet = 3, cols = "D", widths = 20)
  }
  
  # Save Excel
  saveWorkbook(wb, file, overwrite = TRUE) ## save to working directory
}
