library(shinytest2)

# reactable stores a hash ("dataKey") of its data and columns definitions.
# the hash differs between devtools::test() (load_all()) and devtools::check() (installed package) although the table content is identical
# replace has with fixec placeholder before comparing snapshots
fix_reactable_key <- function(lines) {
  sub('"dataKey": "[0-9a-f]+"', '"dataKey": "<hash>"', lines)
}

# Start app in a headless Chrome browser
start_lima_app <- function(name) {
  AppDriver$new(
    app_dir = run_app,
    name = name,
    seed = 123,
    height = 953,
    width = 1619
  )
}

# Query 3: enter address, start the query and wait until the app is idle
query_address <- function(app, address) {
  app$set_inputs(choose_app = "Abfrage 3")
  app$set_inputs(`addresses-address` = address)
  app$click("addresses-start_query")
  app$wait_for_idle()
  invisible(app)
}

# Set a single input whose ID is only known at runtime
set_input <- function(app, input_id, value) {
  args <- list(value)
  names(args) <- input_id
  do.call(app$set_inputs, args)
}

# Query 1 (building zones) and Query 2 (building types):
# select the query, set the filters, start the query and wait until the app is idle
query_area <- function(app, abfrage = c("Abfrage 1", "Abfrage 2"), area = NULL, price = NULL, group = NULL) {
  abfrage <- match.arg(abfrage)
  
  # Both queries use mod_area, called with different module ID in app_server.R
  if (abfrage == "Abfrage 1") {
    module_id <- "area_zones"
  } else if (abfrage == "Abfrage 2") {
    module_id <- "area_types"
  }
  
  # Select Query in radio button
  app$set_inputs(choose_app = abfrage)
  
  # Set only the filters that were passed; NULL keeps the app's default value
  if (!is.null(area)) {
    set_input(app, paste0(module_id, "-select_area"), area)
  }
  if (!is.null(price)) {
    set_input(app, paste0(module_id, "-select_price"), price)
  }
  if (!is.null(group)) {
    set_input(app, paste0(module_id, "-select_group"), group)
  }
  
  # Start query with action button
  app$click(paste0(module_id, "-start_query"))
  app$wait_for_idle()
  invisible(app)
}