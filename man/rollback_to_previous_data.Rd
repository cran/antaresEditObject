% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/writeHydroValues.R
\name{rollback_to_previous_data}
\alias{rollback_to_previous_data}
\title{Rollback to previous hydro data if the data is not consistent}
\usage{
rollback_to_previous_data(
  area,
  prev_data,
  rollback_type,
  opts = antaresRead::simOptions()
)
}
\arguments{
\item{area}{The area where to execute the control and rollback the data.}

\item{prev_data}{The original data to restore if necessary.}

\item{rollback_type}{The file to restore and the control(s) to execute.}

\item{opts}{List of simulation parameters returned by the function
\code{\link[antaresRead:setSimulationPath]{antaresRead::setSimulationPath()}}.}
}
\description{
Rollback the data to previous one if the check is KO.
For a given area, check if the data is consistent and rollback to previous data if the check is KO.
}
\note{
Function called only for an \strong{Antares version >= 860}.
}
