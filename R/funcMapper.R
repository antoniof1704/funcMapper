#' Brief: Map User Created Functions in any R Script
#'
#' Description: This function generates an interactive function map of all user-defined functions that originate
#' from a specified R script (the "main script"). It leverages the find_dependencies() function from the functiondepends
#' package to recursively trace all user-created function dependencies within the script.
#'
#' The process begins by converting the main script into a function (if it isn't already), enabling the tool to
#' identify and highlight the root function in the resulting map. It then iteratively explores each function, parsing
#' and mapping any nested user-defined functions until the full dependency tree is uncovered.
#'
#' The final output is a hierarchical VisNetwork visualisation that clearly illustrates the structure and relationships
#' between functions, with the main script node distinctly highlighted in red for easy identification.
#'
#' Author: Antonio Fratamico
#' Date: 10/07/2025
#'
#' @param script_path File path of R script you wish to map the functions of (need to specify .R at end of script name)
#' @param output_name name of the function map (no need to specify .html)
#' @param output_path path to save function map to (no need for '/' at end of path)
#' @param source run the script if have not done already to load functions into environment (default is FALSE not to run it)
#' @param cleanup_temp_file delete temporary script file converted into function for the mapping process (default is TRUE - might not want to delete)
#' @return Save a function map (html file) in designated output path


funcMapper <- function(script_path,
                       output_name,
                       output_path,
                       source = FALSE,
                       cleanup_temp_file = TRUE
) {

  # Optional - Run script path to load function into global env (if not already run)
  if (source) {
    source(script_path)
  }

  # Read and indent the script
  script_lines <- readLines(script_path)
  indented_lines <- paste0(" ", script_lines)

  # Get script name you want to map
  script_name <- tools::file_path_sans_ext(basename(script_path))

  # Wrap in a function
  wrapped_lines <- c(
    sprintf("%s <- function() {", script_name),
    indented_lines,
    "}"
  )

  # Write to temp file
  temp_file = tempfile(fileext = ".R")
  writeLines(wrapped_lines, temp_file)

  # Source the wrapped script
  source(temp_file, local = .GlobalEnv)

  # Build dependency map
  dep_map <- build_dependency_map(script_name)

  # Plot dependency map
  plot_dependency_graph(dep_map, output_path, output_name, script_name)

  # Optionally delete the temp file
  if (cleanup_temp_file && file.exists(temp_file)) {
    file.remove(temp_file)
  }

}

