#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @noRd
app_ui <- function(request) {
  
  # data is loaded upon loading of the package of this app in utils_load_data
  
  if (!exists("data_vector") || is.null(data_vector)) {
    tagList(
      fluidPage(
        h1("Fehler"),
        p("Aufgrund momentaner Wartungsarbeiten ist die Applikation zur Zeit nicht verfügbar.")
      )
    )
  } else {
    ## Set unique choices
    choices_app12 <- list(
      choices_area = unique(data_vector[["zones"]]$GebietLang),
      choices_price = unique(data_vector[["zones"]]$PreisreiheLang),
      choices_group = unique(data_vector[["zones"]]$ArtLang)
    )
    choices_app3 <- list(
      choices_street = unique(data_vector[["addresses"]]$StrasseLang),
      choices_streetnr = c("", sort(unique(data_vector[["addresses"]]$Hnr)))
    )
    
    tagList(
      # Leave this function for adding external resources
      golem_add_external_resources(),
      # Your application UI logic
      fluidPage(
        
        # App Selection
        tags$div(
          class = "queryDiv",
          h1("Wählen Sie eine Abfrage"),
          hr(),
          sszRadioButtons(
            inputId = "choose_app", # these choices are also used in the module mod_area.R
            label = NULL,
            choices = c(
              "Abfrage 1: Zeitreihen nach Bauzonen für ganze Stadt und Teilgebiete" = "Abfrage 1",
              "Abfrage 2: Zeitreihen nach Bebauungsart für ganze Stadt und Teilgebiete" = "Abfrage 2",
              "Abfrage 3: Zeitreihen für Quartiere und Bauzonen über Adresseingabe" = "Abfrage 3"
            ),
            selected = character(0)
          )
        ),
        
        # Conditional Panel which App to choose
        # App 1
        conditionalPanel(
          condition = 'input.choose_app == "Abfrage 1"',
          # Show App 1 Code
          mod_area_ui(id = "area_zones",
                      choicesapp = choices_app12)
        ),
        # App 2
        conditionalPanel(
          condition = 'input.choose_app == "Abfrage 2" ',
          # Show App 2 Code
          mod_area_ui(id = "area_types",
                      choicesapp = choices_app12)
        ),
        # App 3
        conditionalPanel(
          condition = 'input.choose_app == "Abfrage 3" ',
          # Show App 3 Code
          mod_address_ui(id = "addresses",
                         choicesapp = choices_app3)
        )
      )
    )
  }
  
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @noRd
golem_add_external_resources <- function() {
  
  shinyjs::useShinyjs(debug = TRUE)
  
  add_resource_path(
    "www",
    app_sys("app/www")
  )
  
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "lima-golem"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
