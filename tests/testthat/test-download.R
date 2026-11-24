test_that("filter_address_download returns one price and one count per year", {
  out <- filter_address_download(
    data_vector[["addresses"]], data_vector[["series"]], "Verenastrasse 16"
  )
  all_years <- unique(out$Jahr)
  
  # One value per year
  expect_equal(nrow(out), 2 * length(all_years))
  expect_setequal(out$Jahr[out$Typ == "Preis"], all_years)
  expect_setequal(out$Jahr[out$Typ == "Zahl"], all_years)
  
  # Price reactable first, then count reactable
  expect_equal(out$Typ, rep(c("Preis", "Zahl"), each = length(all_years)))
})

test_that("filter_area_download returns one price and one count per year for the selected filters", {
  out <- filter_area_download(
    data_vector[["zones"]],
    filter_area = "Kreis 4",
    filter_price = "Preis pro m² Grundstücksfläche, abzgl. Versicherungswert",
    filter_group = "Nur Stockwerkeigentum"
  )
  all_years <- unique(out$Jahr)
  
  # One value per year
  expect_equal(nrow(out), 2 * length(all_years))
  expect_setequal(out$Jahr[out$Typ == "Preis"], all_years)
  expect_setequal(out$Jahr[out$Typ == "Zahl"], all_years)
  
  # only the selected area, price and group
  expect_true(all(out$GebietLang == "Kreis 4"))
  expect_true(all(out$PreisreiheLang == "Preis pro m² Grundstücksfläche, abzgl. Versicherungswert"))
  expect_true(all(out$ArtLang == "Nur Stockwerkeigentum"))
  
  # BZO 2016 from 2019 on, BZO 1999 before
  expect_equal(out$BZO, ifelse(as.integer(out$Jahr) >= 2019, "BZO16", "BZO99"))
  
  expect_false(any(c("PreisreiheSort", "ArtSort", "GebietSort") %in% names(out)))
})