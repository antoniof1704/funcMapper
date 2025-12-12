
#' Brief: Map User-Defined Functions from an R Script
#'
#' Description: This function generates an interactive dependency map of all user-defined
#' functions originating from a specified R script. It leverages the `find_dependencies()`
#' function from the **functiondepends** package to recursively trace relationships between
#' functions defined in the script.
#'
#' The process begins by sourcing the script into an isolated environment, ensuring all
#' top-level function definitions are available for analysis. It then iteratively explores
#' each function, mapping any nested user-defined dependencies until the full tree is uncovered.
#'
#' The final output is a hierarchical **visNetwork** visualisation that clearly illustrates
#' the structure and relationships between functions, with the chosen root function highlighted
#' in red for easy identification.
#'
#' Author: Antonio Fratamico
#' Date: 12/12/2025
#'

#' @param script_path character Path to the R script you want to analyse.
#' @param output_name character Base filename for the output (no extension).
#' @param output_path character Directory to save the output HTML.
#' @param func_name   character|NULL Entry function to analyse. If NULL,
#'   we try tools::file_path_sans_ext(basename(script_path)).
#' @param source      logical Source the script into a private env (default TRUE).
#'
#' @return (invisibly) the dependency map (named list)
#' @export

funcMapper <- function(script_path,
                       output_name,
                       output_path,
                       func_name = NULL,
                       source = TRUE) {

  stopifnot(length(script_path) == 1L, file.exists(script_path))

  # Private environment (CRAN-safe; no .GlobalEnv writes)
  local_env <- new.env(parent = baseenv())

  if (isTRUE(source)) {
    # Source TOP-LEVEL definitions into local_env
    sys.source(script_path, envir = local_env)
  }

  # Infer entry function name from script if not provided
  if (is.null(func_name)) {
    inferred <- tools::file_path_sans_ext(basename(script_path))
    if (exists(inferred, envir = local_env, inherits = FALSE) &&
        is.function(get(inferred, envir = local_env, inherits = FALSE))) {
      func_name <- inferred
    } else {
      # If not found, list available top-level functions to guide the user
      all_objs  <- ls(envir = local_env)
      obj_list  <- mget(all_objs, envir = local_env, inherits = FALSE)
      user_funs <- names(obj_list)[vapply(obj_list, is.function, logical(1))]
      stop(sprintf(
        "Could not infer an entry function from '%s'.\nAvailable functions in the script: %s\n",
        inferred,
        if (length(user_funs)) paste(user_funs, collapse = ", ") else "<none>"
      ))
    }
  }

  # Sanity check
  if (!exists(func_name, envir = local_env, inherits = FALSE) ||
      !is.function(get(func_name, envir = local_env, inherits = FALSE))) {
    stop(sprintf("Function '%s' was not found (or is not a function) in the sourced script.", func_name))
  }

  # Build dependency map and render
  dep_map <- build_dependency_map(func_name = func_name, env = local_env)
  plot_dependency_graph(dep_map, output_path, output_name, root_name = func_name)

  invisible(dep_map)
}

