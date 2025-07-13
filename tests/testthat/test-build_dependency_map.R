
library(testthat)
library(functiondepends)

test_that("build_dependency_map correctly maps function dependencies using functiondepends", {
  # Define mock functions in the global environment
  func_c <- function() {}
  func_b <- function() { func_c() }
  func_a <- function() { func_b(); func_c() }

  # Assign them to the global environment
  assign("func_a", func_a, envir = .GlobalEnv)
  assign("func_b", func_b, envir = .GlobalEnv)
  assign("func_c", func_c, envir = .GlobalEnv)

  # Run the function
  dep_map <- build_dependency_map("func_a")

  # Check that the result is a list and contains expected function names
  expect_type(dep_map, "list")
  expect_true(all(c("func_a", "func_b", "func_c") %in% names(dep_map)))

  # Clean up
  rm(func_a, func_b, func_c, envir = .GlobalEnv)
})
