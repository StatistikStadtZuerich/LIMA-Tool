#' explanationbox 
#'
#' @description A utils function to display the explanation box of the according app
#'
#' @return The return value is a div that is called and rendered in the according app
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
    class = "infoDiv",
    h5("eeeee"),
    hr(),
    p("eeeee"),
    p("eeeee"),
    p("eeeee"),
    p("eeeee"),
    p("eeeee"),
    p("eeeee")
  )
}
explanationbox_app3 <- function(){
  tags$div(
    id = "defs",
    class = "infoDiv",
    h5("Begriffserklärung"),
    hr(),
    p("StwE = Stockwerkeigentum"),
    p("VersW = Versicherungswert des Gebäudes")
  )
}