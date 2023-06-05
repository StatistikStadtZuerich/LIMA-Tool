#' download UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
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
    conditionalPanel(
      condition = "input.buttonStart",
      h3("Daten herunterladen"),
      tags$div(
        id = "downloadWrapperId",
        class = "downloadWrapperDiv",
        sszDownloadButton("csvDownload",
                          label = "csv",
                          image = img(ssz_icons$download)
        ),
        sszDownloadButton("excelDownload",
                          label = "xlsx",
                          image = img(ssz_icons$download)
        ),
        sszOgdDownload(
          outputId = "ogdDown",
          label = "OGD",
          href = "https://data.stadt-zuerich.ch/dataset?tags=lima",
          image = img(ssz_icons$link)
        )
      )
    )
  )
}
    
#' download Server Functions
#'
#' @noRd 
mod_download_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_download_ui("download_1")
    
## To be copied in the server
# mod_download_server("download_1")
