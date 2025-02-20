
check_api_study <- function(opts) {
  if (!is_api_study(opts)) {
    stop("The study is not an API study", call. = FALSE)
  }
}

is_api_study <- function(opts) {
  isTRUE(opts$typeLoad == "api")
}

api_not_implemented <- function(opts, fun = as.character(sys.call(sys.parent()))[1L]) {
  if (is_api_study(opts)) {
    stop(fun, " is not implemented in API mode.", call. = FALSE)
  }
}

is_api_mocked <- function(opts) {
  isTRUE(opts$mockAPI)
}

should_command_be_executed <- function(opts) {
  isTRUE(opts$modeAPI == "sync")
}

#' @importFrom antaresRead api_get
is_variant <- function(opts) {
  infos <- api_get(opts = opts, endpoint = opts$study_id)
  identical(infos$type, "variantstudy")
}

check_variant <- function(opts) {
  if (!is_variant(opts)) {
    stop(
      "Study isn't a variant, please create a variant from your study with createVariant() or use an existing one with useVariant()",
      call. = FALSE
    )
  }
}

is_quiet <- function() {
  getOption("antaresEditObject.quiet", default = FALSE)
}

cli_command_registered <- function(command = "") {
  if (!is_quiet())
    cli::cli_alert_info("Command {.emph {command}} registered, see all commands with {.code getVariantCommands()}")
}


update_api_opts <- function(opts) {
  if (is_api_mocked(opts))
    return(invisible(opts))
  modeAPI <- opts$modeAPI
  if (identical(modeAPI, "async"))
    return(invisible(opts))
  host <- opts$host
  study_id <- opts$study_id
  suppressWarnings({
    opts <- antaresRead::setSimulationPathAPI(
      host = host,
      study_id = study_id,
      token = opts$token,
      simulation = "input"
    )
  })
  opts$host <- host
  opts$study_id <- study_id
  opts$modeAPI <- modeAPI
  options(antares = opts)
  return(invisible(opts))
}


# Print methods -----------------------------------------------------------

#' @importFrom utils head
#' @importFrom jsonlite toJSON
#' @export
print.antares.api.commands <- function(x, ...) {
  p <- lapply(
    X = x,
    FUN = function(x) {
      if (!is.null(x$args)) {
        x$args <- lapply(
          X = x$args,
          FUN = function(y) {
            if (length(y) > 10) {
              y <- paste(
                jsonlite::toJSON(head(y), pretty = FALSE, auto_unbox = TRUE),
                "[truncated]..."
              )
              class(y) <- "json"
            } 
            y
          }
        )
      }
      x
    }
  )
  print(jsonlite::toJSON(as.list(p), pretty = TRUE, auto_unbox = TRUE, force = TRUE, json_verbatim = TRUE))
}
#' @export
print.antares.api.command <- function(x, ...) {
  print(jsonlite::toJSON(list(as.list(x)), pretty = TRUE, auto_unbox = TRUE))
}
#' @export
print.antares.api.logs <- function(x, ...) {
  cat(x)
}


# API commands ------------------------------------------------------------

#' Generate a command
#'
#' @param action Action to perform
#' @param ... Named list of arguments
#'
#' @return The command generated
#' @noRd
#'
#' @examples
#' api_command_generate("create_area", area_name = "new area")
api_command_generate <- function(action, ...) {
  command <- list(
    action = action,
    args = dropNulls(list(...))
  )
  class(command) <- c(class(command), "antares.api.command")
  return(command)
}

#' Generate several commands
#'
#' @param ... List of actions with arguments.
#'
#' @return The commands generated
#' @noRd
#'
#' @examples
#' api_commands_generate(
#'   create_area = list(area_name = "new area"),
#'   create_area = list(area_name = "other area")
#' )
api_commands_generate <- function(...) {
  commands <- list(...)
  commands <- lapply(
    X = seq_along(commands),
    FUN = function(i) {
      list(
        action = names(commands)[i],
        args = commands[[i]]
      )
    }
  )
  class(commands) <- c(class(commands), "antares.api.commands")
  return(commands)
}

api_command_register <- function(command, opts) {
  commands <- getOption("antaresEditObject.apiCommands", default = list())
  if (inherits(command, "antares.api.command")) {
    newCommands <- append(commands, list(command))
  } else if (inherits(command, "antares.api.commands")) {
    newCommands <- c(commands, command)
  } else {
    stop(
      "'command' must be a command generated with api_command_generate() or api_commands_generate()"
    )
  }
  options("antaresEditObject.apiCommands" = newCommands)
  return(invisible(newCommands))
}

#' @importFrom httr POST accept_json content_type_json stop_for_status content
#' @importFrom jsonlite toJSON
#' @importFrom antaresRead api_get api_put api_delete api_post
api_command_execute <- function(command, opts, text_alert = "{msg_api}") {
  if (inherits(command, "antares.api.command")) {
    body <- jsonlite::toJSON(list(command), auto_unbox = TRUE)
  } else if (inherits(command, "antares.api.commands")) {
    body <- jsonlite::toJSON(command, auto_unbox = TRUE)
  } else {
    stop(
      "'command' must be a command generated with api_command_generate() or api_commands_generate()"
    )
  }
  
  # send command for study or variant
  api_post(opts, 
           paste0(opts$study_id, "/commands"), 
           body = body, 
           encode = "raw")
  
  # extract command name to put message
  command_name <- jsonlite::fromJSON(body, simplifyVector = TRUE)
  command_name <- command_name$action
  msg_api=" " # HACK /!\
  cli::cli_alert_success(paste0(text_alert, "success"))
  
  # Snaphost /generate" for variant only
  if (is_variant(opts)) {
    variant_res <- api_put(opts, paste0(opts$study_id, "/generate"))
    
    # retrieve task information
    result_task_id <- api_get(opts = opts, 
                              endpoint = file.path("v1", "tasks", variant_res), 
                              default_endpoint = NULL)
    
    while(is.null(result_task_id$result)) {
      if(!is.null(opts$verbose))
        if(opts$verbose)
          message("...Generate Snapshot task in progress...")
      if(is.null(opts$sleep))
        Sys.sleep(0.5)
      else
        Sys.sleep(opts$sleep)
      result_task_id <- api_get(opts = opts, 
                                endpoint = file.path("v1", "tasks", variant_res), 
                                default_endpoint = NULL)
    }
    
    # test if task is terminated with success
    result_task_id_log <- result_task_id$result
    status <- isTRUE(result_task_id_log$success)
    details_command <- jsonlite::fromJSON(result_task_id_log$return_value, 
                                          simplifyVector = FALSE)
    
    if(status){
      if(!is.null(opts$verbose))
        if(opts$verbose)
          message(paste0("Snapshot generated for : ", 
                         details_command$details[[1]]$name))
    }
      
    else
      stop(paste0("Not success for task : ", details_command$details[[1]]$name))
    return(invisible(TRUE))
  }
}





# utils -------------------------------------------------------------------

#' @importFrom antaresRead api_get
api_get_raw_data <- function(id, path, opts) {
  api_get(
    opts, 
    endpoint = paste0(id, "/raw"), 
    query = list(
      path = path, 
      formatted = TRUE
    )
  )
}

#' @importFrom antaresRead api_get
api_get_variants <- function(id, opts) {
  variants <- api_get(
    opts, 
    endpoint = paste0(id, "/variants")
  )
  lapply(
    X = variants$children,
    FUN = function(x) {
      list(name = x$node$name, id = x$node$id)
    }
  )
}

# standardization of character strings for the API 
# (e.g. cluster names, links, etc.)
transform_name_to_id <- function(name, lower = TRUE, id_dash = FALSE) {
  valid_id <- gsub("[^a-zA-Z0-9_(),& -]+", " ", name)
  valid_id <- trimws(valid_id)
  if(lower)
    valid_id <- tolower(valid_id)
  if(id_dash)
    valid_id <- gsub("-", "_", valid_id)
  return(valid_id)
}


#' API methods
#'
#' @param opts Antares simulation options or a `list` with an `host = ` slot.
#' @param endpoint API endpoint to interrogate, it will be added after `default_endpoint`.
#'  Can be a full URL (by wrapping ìn [I()]), in that case `default_endpoint` is ignored.
#' @param ... Additional arguments passed to API method ([httr::PATCH()]).
#' @param default_endpoint Default endpoint to use.
#'
#' @return Response from the API.
#' @export
#'
#' @importFrom httr PATCH accept_json stop_for_status content add_headers
#' @importFrom utils URLencode
#'
#' @examples
#' \dontrun{
#' # Simple example to update st-storages properties 
#' 
#' # read existing study 
#' opts <- setSimulationPath("path_to_the_study", "input")
#' 
#' # make list of properties
#' prop <- list(efficiency = 0.5,
#'   reservoircapacity = 350, 
#'   initialleveloptim = TRUE)
#'   
#' # convert to JSON
#' body <- jsonlite::toJSON(prop,
#'   auto_unbox = TRUE)   
#'   
#' # send to server (see /apidoc)
#' api_patch(opts = opts, 
#'   endpoint = file.path(opts$study_id, 
#'                      "areas", 
#'                       area,
#'                      "storages",
#'                      cluster_name), 
#'  body = body, 
#'  encode = "raw")   
#'
#' }
api_patch <- function(opts, endpoint, ..., default_endpoint = "v1/studies") {
  if (inherits(endpoint, "AsIs")) {
    opts$host <- endpoint
    endpoint <- NULL
    default_endpoint <- NULL
  }
  
  if (is.null(opts$host))
    stop("No host provided in `opts`: use a valid simulation options object or explicitly provide a host with opts = list(host = ...)")
  
  if (!is.null(opts$token) && opts$token != "") 
    config <- add_headers(Authorization = paste("Bearer ", 
                                                opts$token), 
                          Accept = "application/json")
  else 
    config <- add_headers(Accept = "application/json")
  
  # send request
  result <- PATCH(
    url = URLencode(paste(c(opts$host, default_endpoint, endpoint), collapse = "/")),
    config = config,
    ...
  )
  
  # manage response
  api_content <- content(result)
  if(!is.null(names(api_content)))
    api_content <- paste0("\n[Description] : ", api_content$description,
                          "\n[Exception] : ", api_content$exception)
  else
    api_content <- NULL
  stop_for_status(result, task = api_content)
  content(result)
}
