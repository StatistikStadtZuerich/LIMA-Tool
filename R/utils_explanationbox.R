#' explanationbox 
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
explanationbox_app1 <- function(){
  tags$div(
    class = "infoDiv",
    h5("Erklärung Zonenarten"),
    hr(),
    p("Z = Zentrumszone"),
    p("K = Kernzone"),
    p("Q = Quartiererhaltungszone"),
    p("W2 = Wohnzone 2"),
    p("W3 = Wohnzone 3"),
    p("W4 = Wohnzone 4"),
    p("W5 = Wohnzone 5")
  )
}
explanationbox_app2 <- function(){
  tags$div(
    id = "defs",
    class = "infoDiv",
    h5("Begriffserklärung"),
    hr(),
    p("StwE = Stockwerkeigentum"),
    p("VersW = Versicherungswert des Gebäudes")
  )
}