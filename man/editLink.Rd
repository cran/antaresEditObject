% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/editLink.R
\name{editLink}
\alias{editLink}
\title{Edit a link between two areas}
\usage{
editLink(
  from,
  to,
  hurdles_cost = NULL,
  transmission_capacities = NULL,
  asset_type = NULL,
  display_comments = NULL,
  filter_synthesis = NULL,
  filter_year_by_year = NULL,
  dataLink = NULL,
  opts = antaresRead::simOptions()
)
}
\arguments{
\item{from}{The first area from which to create a link}

\item{to}{The second one}

\item{hurdles_cost}{Logical, which is used to state whether (linear)
transmission fees should be taken into account or not in economy and adequacy simulations}

\item{transmission_capacities}{Character, one of \code{enabled}, \code{ignore} or \code{infinite}, which is used to state whether 
the capacities to consider are those indicated in 8760-hour arrays or 
if zero or infinite values should be used instead (actual values / set to zero / set to infinite)}

\item{asset_type}{Character, one of \code{ac}, \code{dc}, \code{gas}, \code{virt} or \code{other}. Used to
state whether the link is either an AC component (subject to Kirchhoff’s laws), a DC component, 
or another type of asset.}

\item{display_comments}{Logical}

\item{filter_synthesis}{Output synthesis}

\item{filter_year_by_year}{Output year-by-year}

\item{dataLink}{For Antares v7, a matrix with eight column corresponding to : trans. capacity (direct)
trans. capacity (indirect), hurdles cost (direct), hurdles cost (indirect), impedances, loop flow,
PST min, PST max.
If \code{NULL} (default), a matrix whose rows are equal to \code{1, 1, 0, 0, 0, 0, 0, 0} is set. See Details}

\item{opts}{List of simulation parameters returned by the function
\code{antaresRead::setSimulationPath}}
}
\value{
An updated list containing various information about the simulation.
}
\description{
Edit a link between two areas
}
\details{
The eight times-series are:
\itemize{
 \item{"NTC direct"}{the upstream-to-downstream capacity, in MW}
 \item{"NTC indirect"}{the downstream-to-upstream capacity, in MW}
 \item{"Hurdle cost direct"}{an upstream-to-downstream transmission fee, in euro/MWh}
 \item{"Hurdle cost indirect"}{a downstream-to-upstream transmission fee, in euro/MWh}
 \item{"Impedances"}{virtual impedances that are used in economy simulations to give a physical meaning to raw outputs, when no binding constraints have been defined to enforce Kirchhoff's laws.}
 \item{"Loop flow"}{amount of power flowing circularly though the grid when all “nodes” are perfectly balanced (no import and no export).}
 \item{"PST min"}{lower bound of phase-shifting that can be reached by a PST installed on the link, if any.}
 \item{"PST max"}{upper bound of phase-shifting that can be reached by a PST installed on the link, if any.}
}
NB: For Antares v7 the eight columns must conform to above order. For Antares v6, only five columns are 
expected, and they must follow this other order: NTC direct, NTC indirect, Impedances, Hurdle cost direct,
Hurdle cost indirect.
}
\note{
In Antares, areas are sorted in alphabetical order to establish links between.
For example, link between "fr" and "be" will appear under "be". 
So the areas are sorted before creating the link between them, and \code{dataLink} is
rearranged to match the new order.
}
\examples{
\dontrun{
editLink(
  from = "area1",
  to = "area2",
  transmission_capacities = "infinite"
)
}
}
