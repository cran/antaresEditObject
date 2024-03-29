% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/API.R
\name{mockSimulationAPI}
\alias{mockSimulationAPI}
\title{Mock API usage}
\usage{
mockSimulationAPI(force = FALSE, antares_version = "8.2.0")
}
\arguments{
\item{force}{Logical, force mocking simulation even if
\link[antaresRead:setSimulationPath]{antaresRead::setSimulationPathAPI} has already been called.}

\item{antares_version}{Antares version number.}
}
\value{
An updated list containing various information about the simulation.
}
\description{
Use this to generate command without an active API connection,
it allow to use function to edit a study to later on get API commands.
}
\examples{
\dontrun{
# Mock simulation API
mockSimulationAPI()
# Create an area
createArea("new area")
# Get commands
getVariantCommands()
}
}
