test_that("plot_dependency_graph creates HTML file", {
  dep_map <- list(a = c("b"), b = character(0))
  tmp_dir <- tempdir()
  out_file <- file.path(tmp_dir, "map.html")

  plot_dependency_graph(dep_map, tmp_dir, "map", root_name = "a")
  expect_true(file.exists(out_file))
})

