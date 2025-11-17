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
            study_name = "test930", 
            antares_version = "9.3")
)


## -----------------------------------------------------------------------------
current_study_opts <- simOptions()
current_study_opts$antaresVersion

## ----areas--------------------------------------------------------------------
createArea(name = "fr")
createArea(name = "it")

## ----default values-----------------------------------------------------------
# new properties (default values)
rmarkdown::paged_table(as.data.frame(storage_values_default(), check.names = FALSE))

## ----creation/properties------------------------------------------------------
# creation
my_parameters <- storage_values_default()
my_parameters$`allow-overflow` <- TRUE

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
my_parameters$`allow-overflow` <- FALSE

editClusterST(area = "fr", 
              cluster_name = "test_storage",
              storage_parameters = my_parameters)

# read cluster properties 
tab <- readClusterSTDesc()
rmarkdown::paged_table(tab)

## ----create/ts----------------------------------------------------------------
# creation
ratio_value <- matrix(0.7, 8760,2)
  
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
new_ratio_value <- matrix(0.85, 8760,3)

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
good_ts <- matrix(0.7, nrow = 8760, ncol =3)
createClusterST(area = "fr",
                cluster_name = "RHS_new_dimensions",
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
good_ts <- matrix(0.7, nrow = 8760, ncol =2)
editClusterST (area = "fr",
                cluster_name = "RHS_new_dimensions",
               constraints_ts = list(
                 "test" = good_ts,
                 "test2"    = good_ts
               )  ,
               add_prefix = TRUE)
#Read
res=read_storages_constraints()

## ----echo=FALSE, message=FALSE, warning=FALSE---------------------------------
library(data.tree)
as.Node(res)

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
updateGeneralSettings(
  refreshtimeseries = 100,
  refreshintervalload = 100,
  refreshintervalhydro = 100,
  refreshintervalwind = 100,
  refreshintervalthermal = 100,
  refreshintervalsolar = 100)
 

## ----scenariobuilder----------------------------------------------------------
#Add sts
createClusterST(area = "fr",
                cluster_name = "Scenario_builder_sts")
 
ldata <- scenarioBuilder(
  n_scenario = 5,
  n_mc = 5,
  areas = "fr"
)
 
updateScenarioBuilder(ldata = ldata,
                      series = "sts")

#Add sta
name_no_prefix <- "add_constraints_sta"
 
constraints_properties <- list(
  "withdrawal-1"=list(
    variable = "withdrawal",
    operator = "equal",
    hours = c("[1,3,5]",
              "[120,121,122,123,124,125,126,127,128]")
  ),
  "netting-1"=list(
    variable = "netting",
    operator = "less",
    hours = c("[1, 168]")
  ))
 
createClusterST(area = "fr",
                cluster_name = name_no_prefix,
                constraints_properties = constraints_properties)
 
ldata <- scenarioBuilder(
  n_scenario = 5,
  n_mc = 5,
  areas = "fr"
)
 
updateScenarioBuilder(ldata = ldata,
                      series = "sta")
  
readScenarioBuilder(as_matrix = TRUE) 

## -----------------------------------------------------------------------------
#List of variables version >=9.3
vector_select_vars= list_thematic_variables()
#Add all variables
list_thematic=setThematicTrimming(selection_variables = vector_select_vars$col_name[68:72])
list_thematic$parameters$`variables selection`

## ----delete study, include=FALSE----------------------------------------------
# Delete study
unlink(current_study_opts$studyPath, 
       recursive = TRUE)
# clean global options
options(antares = NULL)

