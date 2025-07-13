
test_that("plot_dependency_graph creates an HTML file", {
  library(visNetwork)
  library(htmlwidgets)
  library(glue)

  # Mock dependency map
  dep_map <- list(
    main_script = data.frame(Source = c("func_a", "func_b"), Target = c("main_script", "main_script"), stringsAsFactors = FALSE),
    func_a = data.frame(Source = "func_c", Target = "func_a", stringsAsFactors = FALSE),
    func_b = data.frame(Source = character(0), Target = character(0), stringsAsFactors = FALSE),
    func_c = data.frame(Source = character(0), Target = character(0), stringsAsFactors = FALSE)
  )

  # Define output path and name
  output_path <- tempdir()
  output_name <- "test_dependency_graph"
  output_file <- file.path(output_path, paste0(output_name, ".html"))

  # Run the function
  plot_dependency_graph(dep_map, output_path, output_name, main_node = "main_script")

  # Check that the file was created
  expect_true(file.exists(output_file))

  # Clean up
  unlink(output_file)
})
