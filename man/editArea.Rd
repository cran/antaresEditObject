% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/editArea.R
\name{editArea}
\alias{editArea}
\title{Edit an area in an Antares study}
\usage{
editArea(
  name,
  color = NULL,
  localization = NULL,
  nodalOptimization = NULL,
  filtering = NULL,
  adequacy = NULL,
  opts = antaresRead::simOptions()
)
}
\arguments{
\item{name}{Name of the area as a character, without punctuation except - and _.}

\item{color}{Color of the node}

\item{localization}{Localization on the map}

\item{nodalOptimization}{Nodal optimization parameters, see \code{\link[=nodalOptimizationOptions]{nodalOptimizationOptions()}}.}

\item{filtering}{Filtering parameters, see \code{\link[=filteringOptions]{filteringOptions()}}.}

\item{adequacy}{Adequacy parameters, see \code{\link[=adequacyOptions]{adequacyOptions()}}.}

\item{opts}{List of simulation parameters returned by the function
\code{\link[antaresRead:setSimulationPath]{antaresRead::setSimulationPath()}}}
}
\value{
An updated list containing various information about the simulation.
}
\description{
\ifelse{html}{\figure{badge_api_ok.svg}{options: alt='Antares API OK'}}{Antares API: \strong{OK}}

Edit an existing area in an Antares study.
}
\examples{
\dontrun{

library(antaresRead)

# Set simulation path
setSimulationPath(path = "PATH/TO/SIMULATION", simulation = "input")

# Edit an existing area
editArea("area", color = grDevices::rgb(230, 108, 44, max = 255),
  localization = c(1, 1),
  opts = antaresRead::simOptions()) 

editArea("de",  nodalOptimization = list("spilledenergycost" = list(fr = 30)),
opts = antaresRead::simOptions())

editArea("de",  nodalOptimization = nodalOptimizationOptions(),
opts = antaresRead::simOptions())

editArea(
  "de",
  filtering = list("filter_synthesis"=paste(c("hourly","daily"),collapse = ", "))
)

}
}
\seealso{
\code{\link[=createArea]{createArea()}}, \code{\link[=removeArea]{removeArea()}}
}
