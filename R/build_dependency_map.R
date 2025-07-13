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
#' @return A named list of data frames, where each data frame contains the dependencies of a user-defined function.


build_dependency_map <- function(func_name, visited = character(), all_deps = list()) {
  func_name <- as.character(func_name) # Ensure it's a string

  # if function in visited return list
  if (func_name %in% visited) {
    return(all_deps)
  }

  visited <- c(visited, func_name)
  deps <- functiondepends::find_dependencies(func_name)

  all_deps[[func_name]] <- deps

  for (dep_func in deps$Source) {
    dep_func <- as.character(dep_func) # Ensure each dependency is a string
    all_deps <- build_dependency_map(dep_func, visited, all_deps)
  }


  # Get all objects in the global environment
  all_objs <- ls(envir = .GlobalEnv)
  all_objs_list <- mget(all_objs, envir = .GlobalEnv, inherits = FALSE)

  # Filter to keep only functions (user funcs)
  user_funcs <- names(all_objs_list)[sapply(all_objs_list, is.function)]

  # Keep only user created functions
  all_deps <- all_deps[names(all_deps) %in% user_funcs]

  return(all_deps)
}
