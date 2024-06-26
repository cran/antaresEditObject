#Copyright © 2016 RTE Réseau de transport d’électricité

# Copy the test studies in a temporary folder

pathstd <- tempdir()

sourcedir <- system.file("testdata", package = "antaresRead")

studies <- list.files(sourcedir, pattern = "\\.tar\\.gz$", full.names = TRUE)

# Hack: For some unknown reason, this script is executed at some point of
# the R CMD CHECK before package is correctly installed and tests actually run. 
# The following "if" prevents errors at this step

setup_study <- function(study, sourcedir) {
  if (sourcedir != "") {
    # if (Sys.info()['sysname'] == "Windows") {
    #   untar(file.path(sourcedir, "antares-test-study.tar.gz"), exdir = path, 
    #         extras = "--force-local")
    # } else {
      untar(study, exdir = pathstd)
    # }

    assign("studyPath", file.path(pathstd, "test_case"), envir = globalenv())
    assign("nweeks", 2, envir = globalenv())
  }
}
