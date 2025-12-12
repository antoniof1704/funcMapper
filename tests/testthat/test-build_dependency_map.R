
library(testthat)
library(functiondepends)

test_that("build_dependency_map handles simple dependencies", {
  env <- new.env()
  env$a <- function() b()
  env$b <- function() c()
  env$c <- function() NULL

  dep_map <- build_dependency_map("a", env)
  expect_true(is.list(dep_map))
  expect_equal(names(dep_map), c("a", "b", "c"))
  expect_equal(dep_map[["a"]], "b")
  expect_equal(dep_map[["b"]], "c")
})

test_that("build_dependency_map handles missing function", {
  env <- new.env()
  env$a <- function() missing_fn()
  dep_map <- build_dependency_map("a", env)
  expect_equal(dep_map[["a"]], "missing_fn")
})
