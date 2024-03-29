% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/updateAdequacySettings.R
\name{updateAdequacySettings}
\alias{updateAdequacySettings}
\title{Update adequacy parameters of an Antares study}
\usage{
updateAdequacySettings(
  include_adq_patch = NULL,
  set_to_null_ntc_from_physical_out_to_physical_in_for_first_step = NULL,
  set_to_null_ntc_between_physical_out_for_first_step = NULL,
  include_hurdle_cost_csr = NULL,
  check_csr_cost_function = NULL,
  enable_first_step = NULL,
  price_taking_order = NULL,
  threshold_initiate_curtailment_sharing_rule = NULL,
  threshold_display_local_matching_rule_violations = NULL,
  threshold_csr_variable_bounds_relaxation = NULL,
  opts = antaresRead::simOptions()
)
}
\arguments{
\item{include_adq_patch}{Logical. If TRUE, will run Adequacy Patch}

\item{set_to_null_ntc_from_physical_out_to_physical_in_for_first_step}{Logical. default to TRUE}

\item{set_to_null_ntc_between_physical_out_for_first_step}{Logical. default to TRUE}

\item{include_hurdle_cost_csr}{Logical. default to FALSE}

\item{check_csr_cost_function}{Logical. default to FALSE}

\item{enable_first_step}{Logical. default to TRUE}

\item{price_taking_order}{Character. can take values DENS (default value) and Load.}

\item{threshold_initiate_curtailment_sharing_rule}{Double. default to 0.0}

\item{threshold_display_local_matching_rule_violations}{Double. default to 0.0}

\item{threshold_csr_variable_bounds_relaxation}{Integer. default to 3}

\item{opts}{List of simulation parameters returned by the function
\code{\link[antaresRead:setSimulationPath]{antaresRead::setSimulationPath()}}}
}
\value{
An updated list containing various information about the simulation.
}
\description{
\ifelse{html}{\figure{badge_api_ok.svg}{options: alt='Antares API OK'}}{Antares API: \strong{OK}}

Update adequacy parameters of an Antares study
}
\examples{
\dontrun{

updateAdequacySettings(
  include_adq_patch = TRUE,
  set_to_null_ntc_from_physical_out_to_physical_in_for_first_step = TRUE,
  set_to_null_ntc_between_physical_out_for_first_step = TRUE
)

}

}
