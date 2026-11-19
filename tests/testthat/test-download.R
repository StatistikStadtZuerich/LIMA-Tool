test_that("filter_address_download returns prices and counts for one address", {
  out <- filter_address_download(
    data_vector[["addresses"]], data_vector[["series"]], "Verenastrasse 16"
  )
  expect_gt(nrow(out), 0)
  expect_setequal(unique(out$Typ), c("Preis", "Zahl"))
  expect_true(all(out$QuarLang == "Wollishofen"))
})

test_that("filter_area_download returns only the selected area, price and group", {
  out <- filter_area_download(
    data_vector[["zones"]],
    filter_area = "Kreis 4",
    filter_price = "Preis pro m² Grundstücksfläche, abzgl. Versicherungswert",
    filter_group = "Nur Stockwerkeigentum"
  )
  expect_gt(nrow(out), 0)
  expect_true(all(out$GebietLang == "Kreis 4"))
  expect_false(any(c("PreisreiheSort", "ArtSort", "GebietSort") %in% names(out)))
})

test_that("sszDownloadExcel writes a readable xlsx file", {
  data <- filter_address_download(
    data_vector[["addresses"]], data_vector[["series"]], "Verenastrasse 16"
  )
  file <- withr::local_tempfile(fileext = ".xlsx")
  
  sszDownloadExcel(data, file, 3, "Verenastrasse 16")
  
  expect_true(file.exists(file))
  expect_gt(length(readxl::excel_sheets(file)), 0)
})
