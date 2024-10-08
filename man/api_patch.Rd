% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/API-utils.R
\name{api_patch}
\alias{api_patch}
\title{API methods}
\usage{
api_patch(opts, endpoint, ..., default_endpoint = "v1/studies")
}
\arguments{
\item{opts}{Antares simulation options or a \code{list} with an \verb{host = } slot.}

\item{endpoint}{API endpoint to interrogate, it will be added after \code{default_endpoint}.
Can be a full URL (by wrapping ìn \code{\link[=I]{I()}}), in that case \code{default_endpoint} is ignored.}

\item{...}{Additional arguments passed to API method (\code{\link[httr:PATCH]{httr::PATCH()}}).}

\item{default_endpoint}{Default endpoint to use.}
}
\value{
Response from the API.
}
\description{
API methods
}
\examples{
\dontrun{
# Simple example to update st-storages properties 

# read existing study 
opts <- setSimulationPath("path_to_the_study", "input")

# make list of properties
prop <- list(efficiency = 0.5,
  reservoircapacity = 350, 
  initialleveloptim = TRUE)
  
# convert to JSON
body <- jsonlite::toJSON(prop,
  auto_unbox = TRUE)   
  
# send to server (see /apidoc)
api_patch(opts = opts, 
  endpoint = file.path(opts$study_id, 
                     "areas", 
                      area,
                     "storages",
                     cluster_name), 
 body = body, 
 encode = "raw")   

}
}
