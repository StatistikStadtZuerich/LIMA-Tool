test_that("utils to load data", {
  data_vector <- data_load()
  
  # there should be no NAs in data_vector
  expect_true(sum(is.na(data_vector[[1]]$AnzVZA)) == 0)
  expect_true(sum(is.na(data_vector[[2]]$AnzVZA)) == 0)
  
  expect_snapshot_value(prepare_data(data_vector[[1]], data_vector[[2]]), style = "json2")
  
  # check column names
  expect_named(prepare_data(data_vector[[1]], data_vector[[2]]), 
               c("Jahr",
                 "RaumSort",
                 "RaumLang" ,
                 "BrancheSort",
                 "BrancheCd",
                 "BrancheLang",
                 "RechtsformSort",
                 "RechtsformLang",
                 "BetriebsgrSort",
                 "BetriebsgrLang",
                 "Arbeitsstaetten", 
                 "AnzBesch",
                 "AnzBeschW",
                 "AnzBeschM", 
                 "AnzVZA" , 
                 "AnzVZAW",
                 "AnzVZAM"))
  
  
  # check data type
  expect_s3_class(
    prepare_data(data_vector[[1]], data_vector[[2]]),
    "data.frame"
  )
})
