#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import zuericssstyle
#' @noRd
app_ui <- function(request) {
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
          inputId = "query",
          label = NULL,
          choices = c(
            "Abfrage 1: Zeitreihen nach Bauzonen für ganze Stadt und Teilgebiete",
            "Abfrage 2: Zeitreihen für Quartiere und Bauzonen über Adresseingabe"
          ),
          selected = character(0)
        )
      ),
      
      # Conditional Panel which App to choose
      # App 1
      conditionalPanel(
        condition = 'input.query == "Abfrage 1: Zeitreihen nach Bauzonen für ganze Stadt und Teilgebiete"',
        # Show App 1 Code
        mod_area_ui("area_1")
      ),
      # App 2
      conditionalPanel(
        condition = 'input.query == "Abfrage 2: Zeitreihen für Quartiere und Bauzonen über Adresseingabe" ',
        # Show App 2 Code
      )
      # App 3 tbd.
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
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
