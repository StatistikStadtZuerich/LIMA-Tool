test_that("utils to load data", {
  data_vector <- data_load()

  # there names of the dfs in data_vector should be as following:
  expect_named(data_vector, 
               c("zones",
                 "zonesBZO16",
                 "zonesBZO99",
                 "series",
                 "addresses",
                 "types",
                 "seriestypes"))
  
  # there should be no NAs in data_vector
  purrr::map(data_vector, \(x) expect_equal(sum(is.na(x)), 0))
  
  # snapshot of dfs
  purrr::map(data_vector, \(x) expect_snapshot_value(x, style = "json2"))
  
  # check column names
  expect_named(data_vector[[1]], 
               c("Typ",
                 "PreisreiheSort",
                 "PreisreiheLang",
                 "ArtSort",
                 "ArtLang",
                 "GebietSort",
                 "GebietLang",
                 "Jahr",
                 "BZO",
                 "ALLE",
                 "ZE",
                 "KE",
                 "QU",
                 "W2",
                 "W23",
                 "W34",
                 "W45",
                 "W56"))
  
  expect_named(data_vector[[2]], 
               c("Typ",
                 "PreisreiheSort",
                 "PreisreiheLang",
                 "ArtSort",
                 "ArtLang",
                 "GebietSort",
                 "GebietLang",
                 "Jahr",
                 "BZO",
                 "Total",
                 "Z",
                 "K",
                 "Q",
                 "W2",
                 "W3",
                 "W4",
                 "W5",
                 "W6"))
  
  expect_named(data_vector[[3]], 
               c("Typ",
                 "PreisreiheSort",
                 "PreisreiheLang",
                 "ArtSort",
                 "ArtLang",
                 "GebietSort",
                 "GebietLang",
                 "Jahr",
                 "BZO",
                 "Total",
                 "Z",
                 "K",
                 "Q",
                 " ",
                 "W2",
                 "W3",
                 "W4",
                 "W5"))
  
  expect_named(data_vector[[4]], 
               c("Typ",
                 "QuarCd",
                 "QuarLang",
                 "ZoneSort",
                 "ZoneLang",
                 "Jahr",
                 "FrQmBodenGanzeLieg",
                 "FrQmBodenStwE",
                 "FrQmBodenAlleHA",
                 "FrQmBodenNettoGanzeLieg",
                 "FrQmBodenNettoStwE",
                 "FrQmBodenNettoAlleHA"))
  
  expect_named(data_vector[[5]], 
               c("StrasseLang",
                 "Hnr",
                 "QuarCd",
                 "QuarLang",
                 "ZoneBZO16Lang",
                 "ZoneBZO99Lang",
                 "Zones"))
  
  expect_named(data_vector[[6]], 
               c("Typ",
                 "PreisreiheSort",
                 "PreisreiheLang",
                 "ArtSort",
                 "ArtLang",
                 "GebietSort",
                 "GebietLang",
                 "Jahr",
                 "EFH",
                 "MFH",
                 "WHG",
                 "UWH",
                 "NB",
                 "UNB",
                 "IGZ",
                 "UG"))
  
  expect_named(data_vector[[7]], 
               c("Typ",
                 "QuarCd",
                 "QuarLang",
                 "ZoneSort",
                 "ZoneLang",
                 "BebauungSort",
                 "BebauungLang",
                 "Jahr",
                 "FrQmBodenGanzeLieg",
                 "FrQmBodenStwE",
                 "FrQmBodenAlleHA",
                 "FrQmBodenNettoGanzeLieg",
                 "FrQmBodenNettoStwE",
                 "FrQmBodenNettoAlleHA"))
  
  
  # check data type
  purrr::map(data_vector, \(x) expect_s3_class(x, "data.frame"))
  
  
})
