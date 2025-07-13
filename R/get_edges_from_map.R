#' Brief: Convert Dependency Map to Edge List
#'
#' Description: Converts a dependency map (as produced by build_dependency_map(), which is a list of data frames
#' representing function dependencies, into a unified edge list with from and to columns. This format is required
#' for visualizing the function relationships using visNetwork.
#'
#' Author: Antonio Fratamico
#' Date: 10/07/2025
#'
#' @importFrom stats na.omit
#' @param dep_map A named list of data frames, where each data frame contains the dependencies of a user-defined function.
#' @return A data frame representing the edge list, with columns from and to, suitable for plotting with visNetwork.


get_edges_from_map <- function(dep_map) {
  edges <- do.call(rbind, lapply(names(dep_map), function(target) {
    df <- dep_map[[target]]
    if (!is.null(df) && is.data.frame(df) && nrow(df) > 0) {
      df <- df[!is.na(df$Source) & !is.na(df$Target), ] # Remove rows with NA
      if (nrow(df) > 0) {
        data.frame(from = df$Source, to = df$Target, stringsAsFactors = FALSE)
      }
    }
  }))
  edges <- na.omit(edges) # Extra safety
  return(edges)
}
