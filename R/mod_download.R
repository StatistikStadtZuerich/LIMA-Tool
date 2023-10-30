#' download UI Function
#'
#' @param id of the module called in the app
#'
#' @description A shiny Module to call and render the three download options (Excel, CSV, OGD) that are available in every app
#'
#' @noRd 
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
mod_download_server <- function(id, filter_function, static_parameters, reactive_parameters, filter_app){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # check input types
    stopifnot(is.function(filter_function))
    purrr::map(static_parameters, \(x) stopifnot(!is.reactive(x)))
    purrr::map(reactive_parameters, \(x) stopifnot(is.reactive(x)))
    
    ### Get Data for Download 
    # App 1
    dataDownload <- reactive({
      purrr::map(reactive_parameters,
                 req)
      
      seriesPriceCount <- filter_function(unlist(static_parameters),
                                          unlist(reactive_parameters))
      seriesPriceCount
 
    })
    
    # create appropriate filename
      if (filter_app == 1) {
        fn_for_download <- reactive({
          price <- gsub(" ", "-", reactive_parameters$select_price, fixed = TRUE)
          group <- gsub(" ", "-", reactive_parameters$select_group, fixed = TRUE)
          area <- gsub(" ", "-", reactive_parameters$select_area, fixed = TRUE)
          name <- list(paste0(price, "_", group, "_", area))
          
          list(paste0("Liegenschaftenhandel_nach_Bauzonenordnung_und_Zonenart_", name))
        })
      } else if (filter_app == 2) {
        fn_for_download <- reactive({
          price <- gsub(" ", "-", reactive_parameters$select_price, fixed = TRUE)
          group <- gsub(" ", "-", reactive_parameters$select_group, fixed = TRUE)
          area <- gsub(" ", "-", reactive_parameters$select_area, fixed = TRUE)
          name <- list(paste0(price, "_", group, "_", area))
        
        list(paste0("Liegenschaftenhandel_nach_Bebauungsart_", name))
        })
      } else if (filter_app == 3) {
        fn_for_download <- reactive({
          req(reactive_parameters$select_street, reactive_parameters$select_number)
          district <- static_parameters$addresses %>%
            filter(StrasseLang == reactive_parameters$select_street() & Hnr == reactive_parameters$select_number()) %>%
            pull(QuarLang)
          
          list(paste0("Liegenschaftenhandel_nach_Bauzonenordnung_und_Quartier_", district))
          })
        
      } else warning("no appropriate app chosen")
    
    ### Write Download Table
    ## App 1
    # CSV
    output$csvDownload <- downloadHandler(
      filename = function() {
        name <- fn_for_download()
        paste0(name, ".csv")
      },
      content = function(file) {
        write.csv(head(iris), #dataDownload(), 
                  file, row.names = FALSE, na = " ", fileEncoding = "UTF-8")
      }
    )
    
    # Excel
    output$excelDownload <- downloadHandler(
      filename = function() {
        name <- fn_for_download
        paste0(name, ".xlsx")
      },
      content = function(file) {
        #todo has das anpassen
        sszDownloadExcel(head(iris), #dataDownload(), 
                         file, filter_app, filter_1, filter_2, filter_3)
      }
    )
 
  })
}
    
## To be copied in the UI
# mod_download_ui("download_1")
    
## To be copied in the server
# mod_download_server("download_1")
