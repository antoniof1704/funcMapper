
library(testthat)
library(functiondepends)

test_that("build_dependency_map correctly maps function dependencies using functiondepends", {
  
  # Create a temporary environment
  temp_env <- new.env()

  # Define mock functions in the temporary environment
  temp_env$func_c <- function() {}
  temp_env$func_b <- function() { func_c() }
  temp_env$func_a <- function() { func_b(); func_c() }

  # Assign them to the global environment
  assign("func_a", temp_env$func_a, envir = temp_env)
  assign("func_b", temp_env$func_b, envir = temp_env)
  assign("func_c", temp_env$func_c, envir = temp_env)

  # Run the function
  dep_map <- build_dependency_map("func_a", env = temp_env)

  # Check that the result is a list and contains expected function names
  expect_type(dep_map, "list")
  expect_true(all(c("func_a", "func_b", "func_c") %in% names(dep_map)))

})
