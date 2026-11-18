library(shinytest2)

# Query 1
test_that("{shinytest2} Query 1: Default filter (Ganze Stadt) shows both BZO tables", {
  skip_on_cran()
  app <- start_lima_app("abfrage1-standard")
  withr::defer(app$stop())
  
  query_area(app, "Abfrage 1")
  
  expect_equal(
    app$get_value(output = "area_zones-subSubtitle"),
    "Ganze Stadt, Medianpreise in CHF"
  )
  app$expect_values()
})

test_that("{shinytest2} Query 1: Kreis 4, Preis abzgl. Versicherungswert, Stockwerkeigentum", {
  skip_on_cran()
  app <- start_lima_app("abfrage1-kreis4")
  withr::defer(app$stop())
  
  query_area(
    app, "Abfrage 1",
    area = "Kreis 4",
    price = "Preis pro m² Grundstücksfläche, abzgl. Versicherungswert",
    group = "Nur Stockwerkeigentum"
  )
  
  expect_equal(
    app$get_value(output = "area_zones-subSubtitle"),
    "Kreis 4, Medianpreise in CHF"
  )
  
  app$expect_values()
})

# Query 2
test_that("{shinytest2} Query 2: Default filter (Ganze Stadt) shows table", {
  skip_on_cran()
  app <- start_lima_app("abfrage2-standard")
  withr::defer(app$stop())
  
  query_area(app, "Abfrage 2")
  
  app$expect_values()
})

test_that("{shinytest2} Query 2: Quartier Wollishofen, alle Handänderungen, mit Anzahl", {
  skip_on_cran()
  app <- start_lima_app("abfrage2-wollishofen")
  withr::defer(app$stop())
  
  query_area(app, "Abfrage 2", area = "Wollishofen", group = "Alle Handänderungen")
  app$click("area_types-mod_types-linkCount")
  app$wait_for_idle()
  
  app$expect_values()
})

# Query 3
test_that("{shinytest2} Query 3: Address in Wohnzone with BZO-Wechsel shows results", {
  skip_on_cran()
  app <- start_lima_app("abfrage3-wohnzone")
  withr::defer(app$stop())
  
  # Verenastrasse 16: Wollishofen, Wohnzonen 3 (bis 2018: Wohnzone 2)
  query_address(app, "Verenastrasse 16")
  
  expect_true(app$get_value(output = "addresses-show_panel"))
  expect_equal(app$get_value(output = "addresses-address_info-title"), "Verenastrasse 16")
  expect_equal(app$get_value(output = "addresses-address_info-quar"), "Wollishofen")
  
  app$expect_values()
})

test_that("{shinytest2} Query 3: Address in Quartiererhaltungszone shows results", {
  skip_on_cran()
  app <- start_lima_app("abfrage3-quartiererhaltungszone")
  withr::defer(app$stop())
  
  # Langstrasse 192:
  query_address(app, "Langstrasse 192")
  
  expect_true(app$get_value(output = "addresses-show_panel"))
  expect_equal(app$get_value(output = "addresses-address_info-title"), "Langstrasse 192")
  expect_equal(app$get_value(output = "addresses-address_info-quar"), "Gewerbeschule")
  
  app$expect_values()
})

test_that("{shinytest2} Query 3: Address that is not in Wohn-/Mischzone shows Hinweis box", {
  skip_on_cran()
  app <- start_lima_app("abfrage3-industriezone")
  withr::defer(app$stop())
  
  # Aargauerstrasse 1: Industrie- und Gewerbezone, keine Preisdaten
  query_address(app, "Aargauerstrasse 1")
  
  expect_false(app$get_value(output = "addresses-show_panel"))
  expect_match(
    app$get_text("#addresses-more_info"),
    "nicht in einer Wohn- oder Mischzone"
  )
  
  app$expect_values()
})

test_that("{shinytest2} Query 3: invalid address shows Hinweis", {
  skip_on_cran()
  app <- start_lima_app("abfrage3-ungueltig")
  withr::defer(app$stop())
  
  query_address(app, "LilaLangstrasse 98")
  
  expect_false(app$get_value(output = "addresses-show_panel"))
  expect_match(app$get_text("#addresses-more_info"), "existiert nicht")
  
  app$expect_values()
})

test_that("{shinytest2} Query 3: 'Anzahl Handänderungen einblenden' shows table", {
  skip_on_cran()
  app <- start_lima_app("abfrage3-handaenderungen")
  withr::defer(app$stop())
  
  query_address(app, "Verenastrasse 16")
  app$click("addresses-linkCount")
  app$wait_for_idle()
  
  expect_match(app$get_text("#addresses-linkCount"), "verbergen")
  
  app$expect_values()
})

test_that("{shinytest2} Query 3: filter_address_download returns prices and counts for one address", {
  out <- filter_address_download(
    data_vector[["addresses"]], data_vector[["series"]], "Verenastrasse 16"
  )
  expect_gt(nrow(out), 0)
  expect_setequal(unique(out$Typ), c("Preis", "Zahl"))
  expect_true(all(out$QuarLang == "Wollishofen"))
})
