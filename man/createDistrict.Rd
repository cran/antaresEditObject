% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/createDistrict.R
\name{createDistrict}
\alias{createDistrict}
\title{Create a district}
\usage{
createDistrict(
  name,
  caption = NULL,
  comments = NULL,
  apply_filter = c("none", "add-all", "remove-all"),
  add_area = NULL,
  remove_area = NULL,
  output = FALSE,
  overwrite = FALSE,
  opts = antaresRead::simOptions()
)
}
\arguments{
\item{name}{District's name.}

\item{caption}{Caption for the district.}

\item{comments}{Comments for the district.}

\item{apply_filter}{Possible values are \code{add-all} to add all areas to the district,
\code{remove-all} to clear the district, or \code{none} (default) to don't apply a filter.}

\item{add_area}{Character vector of area(s) to add to the district.}

\item{remove_area}{Character vector of area(s) to remove from the district.}

\item{output}{Logical, compute the results for the district or not?}

\item{overwrite}{Logical, should the district be overwritten if already exist?}

\item{opts}{List of simulation parameters returned by the function
\code{\link[antaresRead:setSimulationPath]{antaresRead::setSimulationPath()}}}
}
\value{
An updated list containing various information about the simulation.
}
\description{
Allows selecting a set of areas so as to bundle them together in a "district".
}
\examples{
\dontrun{
createDistrict(
  name = "mydistrict",
  apply_filter = "add-all",
  remove_area = c("fr", "be")
)
}
}
