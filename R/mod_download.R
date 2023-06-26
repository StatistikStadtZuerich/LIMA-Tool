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
mod_download_server <- function(id, data, filter_app, filter_area, filter_price, filter_group){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    ### Get Data for Download 
    # App 1
    dataDownload <- reactive({
      
      filtered <- data %>%
        filter(
          GebietLang == filter_area,
          PreisreiheLang == filter_price,
          ArtLang == filter_group
        ) %>%
        select(Typ, GebietLang, PreisreiheLang, ArtLang, BZO, Jahr, ALLE, ZE, KE, QU, W2, W23, W34, W45, W56)
      filtered
 
    })
    
    # App 2
    dataDownloadTwo <- eventReactive(input$buttonStartTwo, {
      
     
    })
    
    ### Write Download Table
    ## App 1
    # CSV
    output$csvDownload <- downloadHandler(
      filename = function(price) {
        price <- filter_price
        if (price == "Stockwerkeigentum pro m\u00B2 Wohnungsfläche") {
          price <- gsub(" ", "-", filter_price, fixed = TRUE)
          area <- gsub(" ", "-", filter_area, fixed = TRUE)
          paste0("Liegenschaftenhandel_nach_Bauzonenordnung_und_Zonenart_", price, "_", area, ".csv")
        } else {
          price <- gsub(" ", "-", filter_price, fixed = TRUE)
          group <- gsub(" ", "-", filter_group, fixed = TRUE)
          area <- gsub(" ", "-", filter_area, fixed = TRUE)
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
        price <- filter_price
        if (price == "Stockwerkeigentum pro m\u00B2 Wohnungsfläche") {
          price <- gsub(" ", "-", filter_price, fixed = TRUE)
          area <- gsub(" ", "-", filter_area, fixed = TRUE)
          paste0("Liegenschaftenhandel_nach_Bauzonenordnung_und_Zonenart_", price, "_", area, ".xlsx")
        } else {
          price <- gsub(" ", "-", filter_price, fixed = TRUE)
          group <- gsub(" ", "-", filter_group, fixed = TRUE)
          area <- gsub(" ", "-", filter_area, fixed = TRUE)
          paste0("Liegenschaftenhandel_nach_Bauzonenordnung_und_Zonenart_", price, "_", group, "_", area, ".xlsx")
        }
      },
      content = function(file) {
        sszDownloadExcel(dataDownload(), file, filter_app, filter_area, filter_price, filter_group)
      }
    )
 
  })
}
    
## To be copied in the UI
# mod_download_ui("download_1")
    
## To be copied in the server
# mod_download_server("download_1")
