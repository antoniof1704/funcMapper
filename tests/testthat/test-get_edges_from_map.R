
test_that("get_edges_from_map returns correct edge data frame", {
  # Mock dependency map
  dep_map <- list(
    func_a = data.frame(Source = c("func_b", "func_c"), Target = c("func_a", "func_a"), stringsAsFactors = FALSE),
    func_b = data.frame(Source = "func_c", Target = "func_b", stringsAsFactors = FALSE),
    func_c = data.frame(Source = character(0), Target = character(0), stringsAsFactors = FALSE)
  )

  # Run the function
  edges <- get_edges_from_map(dep_map)

  # Expected result
  expected_edges <- data.frame(
    from = c("func_b", "func_c", "func_c"),
    to = c("func_a", "func_a", "func_b"),
    stringsAsFactors = FALSE
  )

  # Check that the result matches expected
  expect_equal(edges[order(edges$from), ], expected_edges[order(expected_edges$from), ])
})
