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
mod_download_server <- function(id, data_1, data_2 = NULL, filter_app, filter_1, filter_2, filter_3 = NULL){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    ### Get Data for Download 
    # App 1
    dataDownload <- reactive({
     
      if (filter_app == "Abfrage 1: Zeitreihen nach Bauzonen für ganze Stadt und Teilgebiete") {
        filtered <- data_1 %>%
          filter(
            GebietLang == filter_1,
            PreisreiheLang == filter_2,
            ArtLang == filter_3
          ) %>%
          select(Typ, GebietLang, PreisreiheLang, ArtLang, BZO, Jahr, ALLE, ZE, KE, QU, W2, W23, W34, W45, W56)
        filtered
      } else if (filter_app == "Abfrage 2: Zeitreihen nach Bebauungsart für ganze Stadt und Teilgebiete"){
        
      } else{
        # Pull district
        district <- data_1 %>%
          filter(StrasseLang == filter_1 & Hnr == filter_2) %>%
          pull(QuarLang)
        
        # Pull zone BZO16
        zoneBZO16 <- data_1 %>%
          filter(StrasseLang == filter_1 & Hnr == filter_2) %>%
          pull(ZoneBZO16Lang)
        
        # Pull zone BZO99
        zoneBZO99 <- data_1 %>%
          filter(StrasseLang == filter_1 & Hnr == filter_2) %>%
          pull(ZoneBZO99Lang)
        
        # Serie BZO16
        serieBZO16 <- data_2 %>%
          filter(
            QuarLang == district & ZoneLang == zoneBZO16,
            Jahr >= 2019
          )
        
        # Serie BZO99
        serieBZO99 <- data_2 %>%
          filter(
            QuarLang == district & ZoneLang == zoneBZO99,
            Jahr < 2019
          )
        
        # Total series
        seriesPriceCount <- bind_rows(serieBZO16, serieBZO99) %>%
          select(-QuarCd, -ZoneSort, -ZoneLang) %>%
          arrange(
            factor(Typ, levels = c(
              "Preis",
              "Zahl"
            )),
            desc(Jahr)
          )
        seriesPriceCount
      }
 
    })
    
    # App 2
    dataDownloadTwo <- eventReactive(input$buttonStartTwo, {
      
     
    })
    
    ### Write Download Table
    ## App 1
    # CSV
    output$csvDownload <- downloadHandler(
      filename = function(app) {
        app <- filter_app
        if (app == "Abfrage 1: Zeitreihen nach Bauzonen für ganze Stadt und Teilgebiete") {
          price <- gsub(" ", "-", filter_2, fixed = TRUE)
          group <- gsub(" ", "-", filter_3, fixed = TRUE)
          area <- gsub(" ", "-", filter_1, fixed = TRUE)
          paste0("Liegenschaftenhandel_nach_Bauzonenordnung_und_Zonenart_", price, "_", group, "_", area, ".csv")
        } else if (app == "Abfrage 2: Zeitreihen nach Bebauungsart für ganze Stadt und Teilgebiete"){
          
        } else {
          district <- data_1 %>%
            filter(StrasseLang == filter_1 & Hnr == filter_2) %>%
            pull(QuarLang)
          paste0("Liegenschaftenhandel_nach_Bauzonenordnung_und_Quartier_", district, ".csv")
        }
      },
      content = function(file) {
        write.csv(dataDownload(), file, row.names = FALSE, na = " ")
      }
    )
    
    # Excel
    output$excelDownload <- downloadHandler(
      filename = function(app) {
        app <- filter_app
        if (app == "Abfrage 1: Zeitreihen nach Bauzonen für ganze Stadt und Teilgebiete") {
          price <- gsub(" ", "-", filter_2, fixed = TRUE)
          group <- gsub(" ", "-", filter_3, fixed = TRUE)
          area <- gsub(" ", "-", filter_1, fixed = TRUE)
          paste0("Liegenschaftenhandel_nach_Bauzonenordnung_und_Zonenart_", price, "_", group, "_", area, ".xlsx")
        } else if (app == "Abfrage 2: Zeitreihen nach Bebauungsart für ganze Stadt und Teilgebiete"){
          
        } else {
          district <- data_1 %>%
            filter(StrasseLang == filter_1 & Hnr == filter_2) %>%
            pull(QuarLang)
          paste0("Liegenschaftenhandel_nach_Bauzonenordnung_und_Quartier_", district, ".xlsx")
        }
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
