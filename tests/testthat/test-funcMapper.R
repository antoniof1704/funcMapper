
test_that("funcMapper sources script and returns dep_map", {
  tmp_script <- tempfile(fileext = ".R")
  writeLines(c("main <- function() helper()", "helper <- function() NULL"), tmp_script)

  tmp_dir <- tempdir()
  dep_map <- funcMapper(tmp_script, "map", tmp_dir, func_name = "main")
  expect_true("main" %in% names(dep_map))
  expect_true(file.exists(file.path(tmp_dir, "map.html")))
})
