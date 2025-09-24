## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(antaresEditObject)

## ----init---------------------------------------------------------------------
dir_path <- tempdir()
suppressWarnings(
  createStudy(path = dir_path, 
            study_name = "test920", 
            antares_version = "9.2")
)


## -----------------------------------------------------------------------------
current_study_opts <- simOptions()
current_study_opts$antaresVersion

## ----areas--------------------------------------------------------------------
createArea(name = "fr")
createArea(name = "it")

## ----st-storage/group---------------------------------------------------------
# creation
createClusterST(area = "fr", 
                cluster_name = "test_storage", 
                group = "my_own_group")

createClusterST(area = "it", 
                cluster_name = "test_storage", 
                group = "my_own_group_again")

# edit group of existing st-storage cluster
editClusterST(area = "fr", 
              cluster_name = "test_storage", 
              group = "my_own_group_Pondage")

# read cluster properties
tab <- readClusterSTDesc()
rmarkdown::paged_table(tab)

## ----default values-----------------------------------------------------------
# new properties (default values)
rmarkdown::paged_table(as.data.frame(storage_values_default(), check.names = FALSE))

## ----creation/properties------------------------------------------------------
# creation
my_parameters <- storage_values_default()
my_parameters$efficiencywithdrawal <- 0.5
my_parameters$`penalize-variation-injection` <- TRUE
my_parameters$`penalize-variation-withdrawal` <- TRUE

createClusterST(area = "fr", 
                cluster_name = "test_storage", 
                group = "new_properties", 
                storage_parameters = my_parameters, 
                overwrite = TRUE)

createClusterST(area = "it", 
                cluster_name = "test_storage", 
                group = "new_properties", 
                storage_parameters = my_parameters,
                overwrite = TRUE)

# read cluster properties 
tab <- readClusterSTDesc()
rmarkdown::paged_table(tab)

## ----edit/properties----------------------------------------------------------
# edit properties of existing st-storage cluster
my_parameters$efficiencywithdrawal <- 0.9
my_parameters$`penalize-variation-injection` <- FALSE
my_parameters$`penalize-variation-withdrawal` <- FALSE

editClusterST(area = "fr", 
              cluster_name = "test_storage",
              storage_parameters = my_parameters)

# read cluster properties 
tab <- readClusterSTDesc()
rmarkdown::paged_table(tab)

## ----create/ts----------------------------------------------------------------
# creation
ratio_value <- matrix(0.7, 8760)
  
# default properties with new optional TS
createClusterST(area = "fr", 
                cluster_name = "good_ts_value", 
                cost_injection = ratio_value, 
                cost_withdrawal = ratio_value, 
                cost_level = ratio_value, 
                cost_variation_injection = ratio_value,
                cost_variation_withdrawal = ratio_value)

# read cluster TS values 
tab <- readInputTS(st_storage = "all", 
                   showProgress = FALSE)
rmarkdown::paged_table(head(tab))

## ----edit/ts------------------------------------------------------------------
# edit TS values of existing st-storage cluster
new_ratio_value <- matrix(0.85, 8760)

# edit everything or anyone you want 
editClusterST(area = "fr",
              cluster_name = "good_ts_value",
              cost_injection = new_ratio_value, 
              cost_withdrawal = new_ratio_value)

# read cluster TS values 
tab <- readInputTS(st_storage = "all", 
                   showProgress = FALSE)
rmarkdown::paged_table(head(tab))

## ----message=FALSE------------------------------------------------------------
# Create 
createClusterST(area = "fr",
                cluster_name = "Additional_Properties",
                storage_parameters = my_parameters, 
                PMAX_injection = NULL, 
                PMAX_withdrawal = NULL, 
                inflows = NULL, 
                lower_rule_curve = NULL, 
                upper_rule_curve = NULL,
                cost_injection = NULL, 
                cost_withdrawal = NULL,
                cost_level = NULL,
                cost_variation_injection = NULL, 
                cost_variation_withdrawal =NULL,
                constraints_properties = list(
                  "test"=list(
                    variable = "withdrawal",
                    operator = "equal",
                    hours = c("[1,3,5]"),
                  "test2"=list(
                   variable = "netting",
                   operator = "less",
                   hours = c("[1, 168]")
                 )
                  )))

# Edit 
editClusterST (area = "fr", 
               cluster_name = "Additional_Properties", 
               storage_parameters = my_parameters, 
                PMAX_injection = NULL, 
                PMAX_withdrawal = NULL, 
                inflows = NULL, 
                lower_rule_curve = NULL, 
                upper_rule_curve = NULL,
                cost_injection = NULL, 
                cost_withdrawal = NULL,
                cost_level = NULL,
                cost_variation_injection = NULL, 
                cost_variation_withdrawal =NULL,
               constraints_properties <- list(
                 "test"=list(
                   variable = "withdrawal",
                   operator = "equal",
                   hours = c("[1,3,5]",
                              "[120,121,122,123,124,125,126,127,128]"),
                   enabled = FALSE
                 ),
                 "test2"=list(
                   variable = "netting",
                   operator = "less",
                   hours = c("[1, 168]")
                 )))


## ----message=FALSE------------------------------------------------------------
# Create
good_ts <- matrix(0.7, nrow = 8760, ncol = 1)
createClusterST(area = "fr",
                cluster_name = "Additional_Values",
                storage_parameters = my_parameters, 
                PMAX_injection = NULL, 
                PMAX_withdrawal = NULL, 
                inflows = NULL, 
                lower_rule_curve = NULL, 
                upper_rule_curve = NULL,
                cost_injection = NULL, 
                cost_withdrawal = NULL,
                cost_level = NULL,
                cost_variation_injection = NULL, 
                cost_variation_withdrawal =NULL,
                constraints_properties = list(
                  "test"=list(
                    variable = "withdrawal",
                    operator = "equal",
                    hours = c("[1,3,5]",
                              "[120,121,122,123,124,125,126,127,128]")
                    #enabled = FALSE
                  ),
                  "test2"=list(
                    variable = "netting",
                    operator = "less",
                    hours = c("[1, 168]")
                  )),
                # constraints_ts 
                constraints_ts = list(
                  "test" = good_ts,
                  "test2"    = good_ts
                ))

# Edit
editClusterST (area = "fr",
                cluster_name = "Additional_Values",
               constraints_ts = list(
                 "test" = good_ts,
                 "test2"    = good_ts+1
               )  ,
               add_prefix = TRUE)
#Read
res=read_storages_constraints()

## ----echo=FALSE, message=FALSE, warning=FALSE---------------------------------
library(listviewer)
jsonedit(res, mode = "view", options = list(collapsed = 1))

## ----remove-------------------------------------------------------------------
# read cluster names
levels(readClusterSTDesc()$cluster)

# remove a cluster
removeClusterST(area = "fr", 
                cluster_name = "good_ts_value")

# read cluster 
tab <- readClusterSTDesc()
rmarkdown::paged_table(tab)

## ----generaldata--------------------------------------------------------------
# user messages
updateAdequacySettings(
    set_to_null_ntc_between_physical_out_for_first_step = FALSE)
updateAdequacySettings(enable_first_step = FALSE)

## ----scenariobuilder----------------------------------------------------------
# the number of coeff is equivalent to the number of areas
  my_coef <- runif(length(getAreas()))
  
  opts <- simOptions()
  
  # build data 
  ldata <- scenarioBuilder(
    n_scenario = 10,
    n_mc = 10,
    areas = getAreas(),
    coef_hydro_levels = my_coef
  )
  
  # update scenearionbuilder.dat
  updateScenarioBuilder(ldata = ldata,
                        series = "hfl")
  
  readScenarioBuilder(as_matrix = TRUE)

## ----delete study, include=FALSE----------------------------------------------
# Delete study
unlink(current_study_opts$studyPath, 
       recursive = TRUE)
# clean global options
options(antares = NULL)

