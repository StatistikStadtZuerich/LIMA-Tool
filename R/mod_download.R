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
#' @noRd 
mod_download_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    ### Write Download Table
    ## App 1
    # CSV
    output$csvDownload <- downloadHandler(
      filename = function(price) {
        price <- input$select_price
        if (price == "Stockwerkeigentum pro m\u00B2 Wohnungsfläche") {
          price <- gsub(" ", "-", input$select_price, fixed = TRUE)
          area <- gsub(" ", "-", input$select_area, fixed = TRUE)
          paste0("Liegenschaftenhandel_nach_Bauzonenordnung_und_Zonenart_", price, "_", area, ".csv")
        } else {
          price <- gsub(" ", "-", input$select_rice, fixed = TRUE)
          group <- gsub(" ", "-", input$select_group, fixed = TRUE)
          area <- gsub(" ", "-", input$select_area, fixed = TRUE)
          paste0("Liegenschaftenhandel_nach_Bauzonenordnung_und_Zonenart_", price, "_", group, "_", area, ".csv")
        }
      },
      content = function(file) {
        write.csv(dataDownload(), file, row.names = FALSE, na = " ")
      }
    )
    
    # Excel
    output$excelDownload <- downloadHandler(
      filename = function(price) {
        price <- input$select_price
        if (price == "Stockwerkeigentum pro m\u00B2 Wohnungsfläche") {
          price <- gsub(" ", "-", input$select_price, fixed = TRUE)
          area <- gsub(" ", "-", input$select_area, fixed = TRUE)
          paste0("Liegenschaftenhandel_nach_Bauzonenordnung_und_Zonenart_", price, "_", area, ".xlsx")
        } else {
          price <- gsub(" ", "-", input$select_price, fixed = TRUE)
          group <- gsub(" ", "-", input$select_group, fixed = TRUE)
          area <- gsub(" ", "-", input$select_area, fixed = TRUE)
          paste0("Liegenschaftenhandel_nach_Bauzonenordnung_und_Zonenart_", price, "_", group, "_", area, ".xlsx")
        }
      },
      content = function(file) {
        sszDownloadExcel(dataDownload(), file, input$choose_app, input$select_area, input$select_price, input$select_group)
      }
    )
 
  })
}
    
## To be copied in the UI
# mod_download_ui("download_1")
    
## To be copied in the server
# mod_download_server("download_1")
