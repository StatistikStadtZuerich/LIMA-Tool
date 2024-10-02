test_that("utils to load data", {
  data_vector <- data_load()
  
  # there should be 7 dfs in data_vector
  expect_true(length(data_vector) == 7)
  
  # there should be no NAs in data_vector
  expect_true(sum(is.na(data_vector[[1]]$Typ)) == 0)
  expect_true(sum(is.na(data_vector[[2]]$Typ)) == 0)
  expect_true(sum(is.na(data_vector[[3]]$Typ)) == 0)
  expect_true(sum(is.na(data_vector[[4]]$Typ)) == 0)
  expect_true(sum(is.na(data_vector[[5]]$StrasseLang)) == 0)
  expect_true(sum(is.na(data_vector[[6]]$Typ)) == 0)
  expect_true(sum(is.na(data_vector[[7]]$Typ)) == 0)
  
  expect_snapshot_value(data_vector[[1]], style = "json2")
  
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
  
  
  # check data type
  expect_s3_class(
    data_vector[[1]],
    "data.frame"
  )
  
  
})
