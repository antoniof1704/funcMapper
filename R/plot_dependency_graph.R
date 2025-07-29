#' Brief: Plot dependencies map from dep_map and save HTML file
#'
#' Description: This function plots the dep_map from build_dependency_map(), by first passing it through get_edges_from_map()
#' to convert it from a list of data frames to a unified edge list, which is then used in a visNetwork plot. This is then
#' saved to the output path with the output name (both defined in funcMapper) as an HTML file.
#'
#' Author: Antonio Fratamico
#' Date: 10/07/2025
#'
#'
#' @importFrom glue glue
#' @importFrom magrittr %>%
#' @importFrom visNetwork visNetwork visEdges visOptions visLayout visHierarchicalLayout
#' @importFrom htmlwidgets saveWidget
#' @param dep_map A named list of data frames, where each data frame contains the dependencies of a user-defined function.
#' @param output_path path to save function map to (defined in funcMapper)
#' @param output_name name of the function map (defined in funcMapper)
#' @param main_node this is always set to the script name, generated from script path in funcMapper. Used to highlight main script node in red.
#' @return A visNetwork plot of the user created function map, saved to the output path
#' @export


plot_dependency_graph <- function(dep_map, output_path, output_name, main_node = script_name) {

  edges <- get_edges_from_map(dep_map)
  all_nodes <- unique(c(edges$from, edges$to))

  nodes <- data.frame(
    id = all_nodes,
    label = all_nodes,
    color = ifelse(all_nodes == main_node, "red", "skyblue"),
    stringsAsFactors = FALSE
  )

  vis <- visNetwork(nodes,
                    edges,
                    main = glue("Function Map of {main_node}"),
                    width = "100%") %>%
    visEdges(arrows = "to") %>%
    visOptions(highlightNearest = TRUE,
               nodesIdSelection = list(enabled = TRUE, main = "Select by Function")) %>%
    visLayout(randomSeed = 567) %>%
    visHierarchicalLayout(direction = "LR", levelSeparation = 200)

  saveWidget(vis, file = paste0(output_path, "/", output_name, ".html"))
}
