#' @title Write Economic Options
#' 
#' @description
#' `r antaresEditObject:::badge_api_ok()`
#' 
#' This function allows to create or edit economic options. Areas/options present
#' in the input dataframe are edited, while all other values are left unchanged.
#'
#' @param x A dataframe. Must contain an \code{area} column listing some (but not
#'   necessarily all) areas of the study. Can contain up to 7 other columns among:
#'   \code{average_unsupplied_energy_cost}, \code{spread_unsupplied_energy_cost},
#'   \code{average_spilled_energy_cost}, \code{spread_spilled_energy_cost},
#'   (numeric columns), \code{non_dispatchable_power},
#'   \code{dispatchable_hydro_power} and \code{other_dispatchable_power}
#'   (logical columns).
#' @param opts
#'   List of simulation parameters returned by the function
#'   \code{antaresRead::setSimulationPath}
#'
#' @export
#' 
#' @importFrom assertthat assert_that
#'
#' @examples
#' \dontrun{
#' 
#' library(antaresRead)
#' 
#' # Set simulation path
#' setSimulationPath(path = "PATH/TO/SIMULATION", simulation = "input")
#' 
#' # Write some economic options for areas a, b and c
#' writeEconomicOptions(data.frame(
#'   area = c("a", "b", "c"),
#'   dispatchable_hydro_power = c(TRUE, FALSE, FALSE),
#'   spread_unsupplied_energy_cost = c(0.03, 0.024, 0.01),
#'   average_spilled_energy_cost = c(10, 8, 8),
#'   stringsAsFactors = FALSE
#' ))
#' 
#' }
writeEconomicOptions <- function(x,
                                 opts = antaresRead::simOptions()) {
  
  assertthat::assert_that(inherits(opts, "simOptions"))
  assertthat::assert_that(is.data.frame(x))
  
  if (!"area" %in% names(x)) {
    stop("'x' must contain an 'area' column.", call. = FALSE)
  }
  
  lapply(
    X = c("non_dispatchable_power", "dispatchable_hydro_power", "other_dispatchable_power"),
    FUN = function(v) assertthat::assert_that(is.logical(x[[v]]) || is.null(x[[v]]))
  )
  
  lapply(
    X = c("spread_unsupplied_energy_cost", "spread_spilled_energy_cost",
          "average_unsupplied_energy_cost", "average_spilled_energy_cost"),
    FUN = function(v) assertthat::assert_that(is.numeric(x[[v]]) || is.null(x[[v]]))
  )
  
  unkwnown_areas <- setdiff(x$area, opts$areaList)
  if (length(unkwnown_areas)) {
    stop(paste("Unknown areas:", paste(unkwnown_areas, collapse = ", ")), call. = FALSE)
  }
  
  
  if (is_api_study(opts)) {
    
    lapply(
      X = x$area,
      FUN = function(name) {
        params <- x[x$area == name, ]
        params <- as.list(params)[c(
          "non_dispatchable_power", 
          "dispatchable_hydro_power",
          "other_dispatchable_power",
          "spread_unsupplied_energy_cost",
          "spread_spilled_energy_cost"
        )]
        params <- dropNulls(params)
        if (length(params) < 1)
          return(NULL)
        params <- hyphenize_names(params)
        params
        actions <- lapply(
          X = seq_along(params),
          FUN = function(i) {
            list(
              target = sprintf("input/areas/%s/optimization/nodal optimization/%s", name, names(params)[i]),
              data = params[[i]]
            )
          }
        )
        actions <- setNames(actions, rep("update_config", length(actions)))
        cmd <- do.call(api_commands_generate, actions)
        api_command_register(cmd, opts = opts)
        `if`(
          should_command_be_executed(opts), 
          api_command_execute(cmd, opts = opts, text_alert = "Updating general settings: {msg_api}"),
          cli_command_registered("update_config")
        )
      }
    )
    
    if (!is.null(x$average_unsupplied_energy_cost)) {
      cmd <- api_command_generate(
        action = "update_config", 
        target = "input/thermal/areas/unserverdenergycost",
        data = setNames(as.list(x$average_unsupplied_energy_cost), x$area)
      )
      api_command_register(cmd, opts = opts)
      `if`(
        should_command_be_executed(opts), 
        api_command_execute(cmd, opts = opts, text_alert = "Update unsupplied energy cost option: {msg_api}"),
        cli_command_registered("update_config")
      )
    }
    
    if (!is.null(x$average_spilled_energy_cost)) {
      cmd <- api_command_generate(
        action = "update_config", 
        target = "input/thermal/areas/spilledenergycost",
        data = setNames(as.list(x$average_spilled_energy_cost), x$area)
      )
      api_command_register(cmd, opts = opts)
      `if`(
        should_command_be_executed(opts), 
        api_command_execute(cmd, opts = opts, text_alert = "Update spilled energy cost option: {msg_api}"),
        cli_command_registered("update_config")
      )
    }
    
    
    return(update_api_opts(opts))
  } else {
    # write optimization.ini files (one for each area)
    lapply(
      X = x$area,
      FUN = function(name) {
        params <- x[x$area == name, ]
        
        optim_path <- file.path(opts$inputPath, "areas", name, "optimization.ini")
        optim <- readIniFile(file = optim_path)
        
        if (!is.null(params$non_dispatchable_power))
          optim$`nodal optimization`$`non-dispatchable-power` <- params$non_dispatchable_power
        if (!is.null(params$dispatchable_hydro_power))
          optim$`nodal optimization`$`dispatchable-hydro-power` <- params$dispatchable_hydro_power
        if (!is.null(params$other_dispatchable_power))
          optim$`nodal optimization`$`other-dispatchable-power` <- params$other_dispatchable_power
        if (!is.null(params$spread_unsupplied_energy_cost))
          optim$`nodal optimization`$`spread-unsupplied-energy-cost` <- params$spread_unsupplied_energy_cost
        if (!is.null(params$spread_spilled_energy_cost))
          optim$`nodal optimization`$`spread-spilled-energy-cost` <- params$spread_spilled_energy_cost
        
        writeIni(optim, optim_path, overwrite = TRUE)
      }
    )
    
    # write thermal/areas.ini (unique file for all areas)
    thermal_areas_path <- file.path(opts$inputPath, "thermal", "areas.ini")
    if (file.exists(thermal_areas_path)) {
      thermal_areas <- readIniFile(file = thermal_areas_path)
    } else {
      thermal_areas <- list()
    }
    
    for (name in x$area) {
      params <- x[x$area == name, ]
      
      if (!is.null(params$average_unsupplied_energy_cost))
        thermal_areas$unserverdenergycost[[name]] <- params$average_unsupplied_energy_cost
      if (!is.null(params$average_spilled_energy_cost))
        thermal_areas$spilledenergycost[[name]] <- params$average_spilled_energy_cost
    }
    
    writeIni(thermal_areas, thermal_areas_path, overwrite = TRUE)
  }
  
}
