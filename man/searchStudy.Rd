% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/API.R
\name{searchStudy}
\alias{searchStudy}
\title{Search study in AntaREST}
\usage{
searchStudy(
  workspace = NULL,
  folder = NULL,
  name = NULL,
  ...,
  host = NULL,
  token = NULL
)
}
\arguments{
\item{workspace}{Space in which to search for a study.}

\item{folder}{Folder in which to search for a study.}

\item{name}{Name for the study.}

\item{...}{Other query parameters.}

\item{host}{Host of AntaREST server API.}

\item{token}{API personnal access token.}
}
\value{
a \code{data.table} with informations about studies on the server.
}
\description{
Search study in AntaREST
}
\examples{
\dontrun{

searchStudies(host = "http://localhost:8080")

}
}
