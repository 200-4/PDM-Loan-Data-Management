#PDM FARMER LOAN MANAGEMENT SYSTEM
#RUN THIS FILE TO START THE SYSTME

cat("==PDM Farmer Loan Management System ==\n")
cat("Initializing System...\n")

#Load required packages and configurations
source("config/config.R")
load_required_packages()


#load all source files
source_files <- list.files("src", pattern = "\\.R$")
for (file in source_files) {
  source(file)
  cat("Loaded:", file, "\n")
}
cat("System Initialization complete!\n")

#run shiny app
shiny::runApp("shiny_app")