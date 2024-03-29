% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/writeMiscGen.R
\name{writeMiscGen}
\alias{writeMiscGen}
\title{Write Misc Gen data}
\usage{
writeMiscGen(data, area, opts = antaresRead::simOptions())
}
\arguments{
\item{data}{Data to write.}

\item{area}{Name of the area for which to write data.}

\item{opts}{List of simulation parameters returned by the function
\code{\link[antaresRead:setSimulationPath]{antaresRead::setSimulationPath()}}}
}
\value{
An updated list containing various information about the simulation.
}
\description{
\ifelse{html}{\figure{badge_api_ok.svg}{options: alt='Antares API OK'}}{Antares API: \strong{OK}}
}
\examples{
\dontrun{

writeMiscGen(matrix(data = c(rep(0, 8760 * 7), rep(-100000, 8760)), ncol = 8), "area1")

}
}
