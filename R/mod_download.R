#' download UI Function
#'
#' @param id of the module called in the app
#'
#' @description A shiny Module to call and render the three download options (Excel, CSV, OGD) that are available in every app
#'
#' @noRd 
#'
#' @import icons
#' @import zuericssstyle
#' @importFrom shiny NS tagList 
mod_download_ui <- function(id){
  ### Set up directory for icons
  ssz_icons <- icon_set("inst/app/www/icons/")
  
  ns <- NS(id)
  tagList(

    h3("Daten herunterladen"),
    tags$div(
      id = "downloadWrapperId",
      class = "downloadWrapperDiv",
      sszDownloadButton(ns("csvDownload"),
                        label = "csv",
                        image = img(ssz_icons$download)
      ),
      sszDownloadButton(ns("excelDownload"),
                        label = "xlsx",
                        image = img(ssz_icons$download)
      ),
      sszOgdDownload(
        outputId = ns("ogdDown"),
        label = "OGD",
        href = "https://data.stadt-zuerich.ch/dataset?tags=lima",
        image = img(ssz_icons$link)
      )
      
    )
  )
}
    
#' download Server Functions
#'
#' @param id of the module called in the app
#' @param function_filter function to filter the data for the download
#' @param filename_download filename for the download file
#' @param filter_app app that is selected
#' @param filter_1 input (filter) of the first widget
#' @param filter_2 input (filter) of the second widget
#' @param filter_3 input (filter) of the optional third widget
#'
#' @noRd 
mod_download_server <- function(id, function_filter, filename_download, filter_app, filter_1, filter_2, filter_3 = NULL){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    ### Get Data for Download 
    # App 1
    dataDownload <- reactive({
      
      seriesPriceCount <- function_filter
      seriesPriceCount
 
    })
    
    ### Write Download Table
    ## App 1
    # CSV
    output$csvDownload <- downloadHandler(
      filename = function(name) {
        name <- filename_download
        paste0(name, ".csv")
      },
      content = function(file) {
        write.csv(dataDownload(), file, row.names = FALSE, na = " ", fileEncoding = "UTF-8")
      }
    )
    
    # Excel
    output$excelDownload <- downloadHandler(
      filename = function(name) {
        name <- filename_download
        paste0(name, ".xlsx")
      },
      content = function(file) {
        sszDownloadExcel(dataDownload(), file, filter_app, filter_1, filter_2, filter_3)
      }
    )
 
  })
}
    
## To be copied in the UI
# mod_download_ui("download_1")
    
## To be copied in the server
# mod_download_server("download_1")
