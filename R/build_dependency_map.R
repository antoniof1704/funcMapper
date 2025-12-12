
#' Brief: Build Recursive Dependency Map of User-Defined Functions
#'
#' @description Recursively constructs a dependency map for user-defined functions
#' starting from a specified root function. The function uses
#' `functiondepends::find_dependencies()` to identify direct callees and then
#' iterates through each dependency until the full tree is resolved.
#'
#' Unlike earlier versions, this implementation:
#' - Accepts a root function name and an environment containing all sourced functions.
#' - Returns a named list where each element is a character vector of immediate dependencies.
#' - Handles missing functions gracefully by recording them with an empty vector.
#'
#' @details The recursion stops when all user-defined functions reachable from the root
#' have been visited. Only functions present in the provided environment are included.
#'
#' @author Antonio Fratamico
#' @date 12/12/2025
#'
#' @importFrom functiondepends find_dependencies
#' @param func_name Character scalar. The name of the root function to begin tracing from.
#' @param env Environment containing user-defined functions (typically created in `funcMapper()`).
#' @param visited Character vector of already visited function names (internal use).
#' @param all_deps Named list accumulating dependencies (internal use).
#'
#' @return A named list where each name is a function and its value is a character vector
#' of user-defined functions it directly calls.
#' @export

build_dependency_map <- function(func_name, env, visited = character(), all_deps = list()) {
  if (func_name %in% visited) return(all_deps)
  visited <- c(visited, func_name)

  if (!exists(func_name, envir = env) || !is.function(env[[func_name]])) {
    all_deps[[func_name]] <- character(0)
    return(all_deps)
  }

  target_fun <- env[[func_name]]
  deps <- tryCatch(functiondepends::find_dependencies(target_fun, env), error = function(e) NULL)

  callee_col <- intersect(c("Source", "Function", "Callee"), names(deps))
  callees <- if (length(callee_col)) unique(as.character(deps[[callee_col[1]]])) else character(0)

  all_deps[[func_name]] <- callees

  for (dep in callees) {
    if (exists(dep, envir = env) && is.function(env[[dep]])) {
      all_deps <- build_dependency_map(dep, env, visited, all_deps)
    }
  }

  all_deps
}

