% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/createCluster.R
\name{createCluster}
\alias{createCluster}
\alias{createClusterRES}
\title{Create a cluster}
\usage{
createCluster(
  area,
  cluster_name,
  group = "Other",
  ...,
  list_pollutants = NULL,
  time_series = NULL,
  prepro_data = NULL,
  prepro_modulation = NULL,
  add_prefix = TRUE,
  overwrite = FALSE,
  opts = antaresRead::simOptions()
)

createClusterRES(
  area,
  cluster_name,
  group = "Other RES 1",
  ...,
  time_series = NULL,
  add_prefix = TRUE,
  overwrite = FALSE,
  opts = antaresRead::simOptions()
)
}
\arguments{
\item{area}{The area where to create the cluster.}

\item{cluster_name}{Name for the cluster, it will prefixed by area name, unless you set \code{add_prefix = FALSE}.}

\item{group}{Group of the cluster, depends on cluster type:
\itemize{
\item thermal cluster, one of: Gas, Hard coal, Lignite, Mixed fuel, Nuclear, Oil, Other, Other 2, Other 3, Other 4.
\item renewable cluster, one of: Wind Onshore, Wind Offshore, Solar Thermal, Solar PV, Solar Rooftop, Other RES 1, Other RES 2, Other RES 3, Other RES 4.
}}

\item{...}{Parameters to write in the Ini file. Careful!
Some parameters must be set as \code{integers} to avoid warnings in Antares, for example,
to set \code{unitcount}, you'll have to use \code{unitcount = 1L}.}

\item{list_pollutants}{\code{list} named with specific pollutants (only for Antares version >= 860)}

\item{time_series}{the "ready-made" 8760-hour time-series available for simulation purposes.}

\item{prepro_data}{Pre-process data, a \code{data.frame} or \code{matrix},
default is a matrix with 365 rows and 6 columns.}

\item{prepro_modulation}{Pre-process modulation, a \code{data.frame} or \code{matrix},
if specified, must have 8760 rows and 1 or 4 columns.}

\item{add_prefix}{If \code{TRUE} (the default), \code{cluster_name} will be prefixed by area name.}

\item{overwrite}{Logical, overwrite the cluster or not.}

\item{opts}{List of simulation parameters returned by the function
\code{\link[antaresRead:setSimulationPath]{antaresRead::setSimulationPath()}}}
}
\value{
An updated list containing various information about the simulation.
}
\description{
\ifelse{html}{\figure{badge_api_ok.svg}{options: alt='Antares API OK'}}{Antares API: \strong{OK}} (thermal clusters only)

Create a new thermal or RES (renewable energy source) cluster.
}
\note{
Parameter \code{list_pollutants} is only available for Antares studies >= v8.6.0.

You must provide named \code{list} (numerical values or NULL ) :

\code{list( "nh3"= 0.25, "nox"= 0.45, "pm2_5"= 0.25,   "pm5"= 0.25, "pm10"= 0.25, "nmvoc"= 0.25, "so2"= 0.25,  "op1"= 0.25, "op2"= 0.25, "op3"= 0.25,   "op4"= 0.25, "op5"= NULL, "co2"= NULL)}
}
\examples{
\dontrun{

library(antaresRead)
library(antaresEditObject)

# Create a cluster :
createCluster(
  area = "fr", 
  cluster_name = "my_cluster",
  group = "other", 
  unitcount = 1L, # or as.integer(1)
  marginal_cost = 50
)
# by default, cluster name is prefixed 
# by the area name
levels(readClusterDesc()$cluster)
# > "fr_my_cluster"

# To prevent this, use `add_prefix`
createCluster(
  area = "fr", 
  cluster_name = "my_cluster",
  add_prefix = FALSE,
  group = "other", 
  marginal_cost = 50
)
levels(readClusterDesc()$cluster)
# > "my_cluster"


# Create a RES cluster :
createClusterRES(
  area = "fr", 
  cluster_name = "my_cluster_res",
  group = "other", 
  unitcount = 1L, # or as.integer(1)
  nominalcapacity = 50,
  ts_interpretation = "power-generation"
) 

# You can also specify that the Time-Series of the RES cluster are
# production factors :
createClusterRES(
  area = "fr", 
  cluster_name = "my_cluster_res",
  group = "other", 
  unitcount = 1L, # or as.integer(1)
  nominalcapacity = 50,
  ts_interpretation = "production-factor"
)


# Pre-process data : 

# this is the default data :
createCluster(
  area = "fr", 
  cluster_name = "my_cluster",
  prepro_data = matrix(
    data = c(rep(1, times = 365 * 2),
             rep(0, times = 365 * 4)), 
    ncol = 6
  )
)

# with a data.frame
createCluster(
  area = "fr", 
  cluster_name = "my_cluster",
  prepro_data = data.frame(
    v1 = rep(7, 365), # column name does not matter
    v2 = rep(27, 365),
    v3 = rep(0.05, 365),
    v4 = rep(0.12, 365),
    v5 = rep(0, 365),
    v6 = rep(1, 365)
  )
)


# Pre-process modulation : 
# this is the default data
createCluster(
  area = "fr", 
  cluster_name = "my_cluster",
  prepro_modulation = matrix(
    data = c(rep(1, times = 365 * 24 * 3),
             rep(0, times = 365 * 24 * 1)),
    ncol = 4
  )
)

# with a data.frame
createCluster(
  area = "fr", 
  cluster_name = "my_cluster",
  prepro_modulation = data.frame(
    var1 = rep(0, 8760), # column name does not matter
    var2 = rep(1, 8760),
    var3 = rep(0, 8760),
    var4 = rep(1, 8760)
  )
)

}
}
\seealso{
\code{\link[=editCluster]{editCluster()}} or \code{\link[=editClusterRES]{editClusterRES()}} to edit existing clusters, \code{\link[=removeCluster]{removeCluster()}} or \code{\link[=removeClusterRES]{removeClusterRES()}} to remove clusters.
}
