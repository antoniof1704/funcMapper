#' Brief: Build Recursive Dependency Map of User-Defined Functions
#'
#' Description: This function recursively builds a list of data frames, each representing a user-defined function
#' and its dependencies. Starting from the main function (typically the main script wrapped as a function), it uses
#' find_dependencies() from the functiondepends package to trace all user-defined function calls. The process
#' continues until no new dependencies are found.
#'
#' Author: Antonio Fratamico
#' Date: 10/07/2025
#'
#'
#' @importFrom functiondepends find_dependencies
#' @param func_name The name of the main function (converted from the main script) to begin tracing dependencies from.
#' @param visited A character vector used to track already visited functions and prevent infinite recursion.
#' @param all_deps A list used to accumulate the dependency data frames for each user-defined function.
#' @param env The local enviroment created in funcMapper()
#' @return A named list of data frames, where each data frame contains the dependencies of a user-defined function.
#' @export


build_dependency_map <- function(func_name, visited = character(), all_deps = list(), env = parent.frame()) {
  func_name <- as.character(func_name)

  if (func_name %in% visited) {
    return(all_deps)
  }

  visited <- c(visited, func_name)

  # Use correct env
  deps <- functiondepends::find_dependencies(func_name, env)

  all_deps[[func_name]] <- deps

  # Check if deps has a 'Source' column and recurse
  if (!is.null(deps) && "Source" %in% names(deps)) {
    for (dep_func in deps$Source) {
      dep_func <- as.character(dep_func)
      all_deps <- build_dependency_map(dep_func, visited, all_deps, env)
    }
  }

  # Restrict to user-defined functions in env
  all_objs <- ls(envir = env)
  all_objs_list <- mget(all_objs, envir = env, inherits = FALSE)
  user_funcs <- names(all_objs_list)[sapply(all_objs_list, is.function)]
  all_deps <- all_deps[names(all_deps) %in% user_funcs]

  return(all_deps)
}
