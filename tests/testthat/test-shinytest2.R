# Query 1
test_that("{shinytest2} Query 1: Default filter (Ganze Stadt) shows both BZO tables", {
  skip_on_cran()
  app <- start_lima_app("abfrage1-standard")
  withr::defer(app$stop())
  
  query_area(app, "Abfrage 1")
  
  expect_equal(
    app$get_value(output = "area_zones-subtitle"),
    "Ganze Stadt, Ganze Liegenschaften"
  )
  expect_match(
    app$get_value(output = "area_zones-mod_zones-Preis_submodul16-tableTitle"),
    "BZO 2016"
  )
  expect_match(
    app$get_value(output = "area_zones-mod_zones-Preis_submodul99-tableTitle"),
    "BZO 1999"
  )
  app$expect_values(transform = fix_reactable_key)
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
    app$get_value(output = "area_zones-title"),
    "Preis pro m² Grundstücksfläche, abzgl. Versicherungswert"
  )
  expect_equal(
    app$get_value(output = "area_zones-subtitle"),
    "Kreis 4, Nur Stockwerkeigentum"
  )
  
  app$expect_values(transform = fix_reactable_key)
})

# Query 2
test_that("{shinytest2} Query 2: Default filter (Ganze Stadt) shows table", {
  skip_on_cran()
  app <- start_lima_app("abfrage2-standard")
  withr::defer(app$stop())
  
  query_area(app, "Abfrage 2")
  
  app$expect_values(transform = fix_reactable_key)
})

test_that("{shinytest2} Query 2: Quartier Wollishofen, alle Handänderungen, mit Anzahl", {
  skip_on_cran()
  app <- start_lima_app("abfrage2-wollishofen")
  withr::defer(app$stop())
  
  query_area(app, "Abfrage 2", area = "Wollishofen", group = "Alle Handänderungen")
  app$click("area_types-mod_types-linkCount")
  app$wait_for_idle()
  
  app$expect_values(transform = fix_reactable_key)
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
  
  app$expect_values(transform = fix_reactable_key)
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
  
  app$expect_values(transform = fix_reactable_key)
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
  
  app$expect_values(transform = fix_reactable_key)
})

test_that("{shinytest2} Query 3: invalid address shows Hinweis", {
  skip_on_cran()
  app <- start_lima_app("abfrage3-ungueltig")
  withr::defer(app$stop())
  
  query_address(app, "LilaLangstrasse 98")
  
  expect_false(app$get_value(output = "addresses-show_panel"))
  expect_match(app$get_text("#addresses-more_info"), "existiert nicht")
  
  app$expect_values(transform = fix_reactable_key)
})

test_that("{shinytest2} Query 3: 'Anzahl Handänderungen einblenden' shows table", {
  skip_on_cran()
  app <- start_lima_app("abfrage3-handaenderungen")
  withr::defer(app$stop())
  
  query_address(app, "Verenastrasse 16")
  app$click("addresses-linkCount")
  app$wait_for_idle()
  
  expect_match(app$get_text("#addresses-linkCount"), "verbergen")
  
  app$expect_values(transform = fix_reactable_key)
})

test_that("{shinytest2} Query 3: CSV and XLSX downloads deliver a file", {
  skip_on_cran()
  app <- start_lima_app("abfrage3-download")
  withr::defer(app$stop())
  
  query_address(app, "Verenastrasse 16")
  
  csv <- app$get_download("addresses-download_3-csvDownload")
  withr::defer(unlink(csv))
  expect_true(file.exists(csv))
  expect_gt(file.size(csv), 0)
  expect_match(basename(csv), "Wollishofen.*\\.csv$")
  
  xlsx <- app$get_download("addresses-download_3-excelDownload")
  withr::defer(unlink(xlsx))
  expect_true(file.exists(xlsx))
  expect_gt(file.size(xlsx), 0)
})