
test_that("funcMapper errors with non-existent script path", {

  library(visNetwork)
  library(htmlwidgets)
  library(glue)
  library(functiondepends)

  expect_error(funcMapper("nonexistent.R", "map", tempdir()),
               "cannot open the connection")
})

test_that("funcMapper wraps script into a function", {
  temp_script <- tempfile(fileext = ".R")
  writeLines("myfunc <- function(x) x + 1", temp_script)


  expect_silent(suppressMessages(suppressWarnings(
    funcMapper(temp_script, "testmap", tempdir())
  )))

})

test_that("funcMapper creates an HTML output", {
  temp_script <- tempfile(fileext = ".R")
  writeLines("myfunc <- function(x) x + 1", temp_script)

  output_dir <- tempdir()
  funcMapper(temp_script, "testmap", output_dir)

  expect_true(file.exists(file.path(output_dir, "testmap.html")))
})

test_that("Temporary file is deleted when cleanup is TRUE", {
  temp_script <- tempfile(fileext = ".R")
  writeLines("myfunc <- function(x) x + 1", temp_script)


  expect_silent(suppressMessages(suppressWarnings(
    funcMapper(temp_script, "testmap", tempdir(), cleanup_temp_file = TRUE)
  )))

})
