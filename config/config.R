#System Config
SYSTEM_CONFIG <- list(
 #file paths
 data_paths = list(
   districts = "data/raw/districts.csv",
   parishes = "data/raw/parishes.csv",
   farmer_groups = "data/raw/farmer_groups.csv",
   farmers = "data/raw/farmers.csv",
   loans = "data/raw/loans.csv",
   backups = "data/backups/"
   
 ),
 #System parameters
 parameters = list(
   max_loan_amount = 10000000, #10 millions,
   min_loan_amount = 100000, #One hundred thousands
   interest_rate = 0.05,
   repayment_period_months = 12,
   group_size_limit = 50
   
 ),
 #crop types
 crop_types = c("Maize","Beans","Coffee", "Bananas", "Cassava","Rice","Wheat","Vegetables","Fruits","Other"),
 
 #District types
 regions = c("Central","Eastern","Northern","Western"),
 
 #Reporting periods
 report_periods = c("Weekly","Monthly","Quarterly","Annual")
)
 
 #load required libraries
 load_required_packages <- function(){
   required_pkgs <- c(
     "dplyr","tidyr","data.table","ggplot2",
     "lubridate","stringr","shiny","shinydashboard",
     "DT","plotly","readr","writexl"
   )
  for (pkg in required_pkgs) {
    if (!require(pkg, character.only = TRUE)){
      install.packages(pkg)
      library(pkg, character.only = TRUE)
    }
    
  } 
 }
