#set the working directory to the project root
setwd("../")

#PDM FARMER LOAN MANAGEMENT SYSTEM - SHINY APPLICATION
library(shiny)
library(shinydashboard)
library(DT)
library(plotly)
library(dplyr)
library(ggplot2)
library(lubridate)
library(stringr)
library(writexl)

#get all required files
source("config/config.R")
source("src/data_management/initialize_data.R")
source("src/data_management/farmer_registration.R")
source("src/data_management/loan_management.R")
source("src/analysis/summary_statistics.R")
source("src/analysis/performance_analysis.R")
source("src/visualization/basic_plots.R")
source("src/utils/helpers.R")

#Load system data
system_data <<- load_system_data()

#Source UI and Server
source("shiny_app/ui.R", local = TRUE)
source("shiny_app/server.R", local = TRUE)
 
# Wrap server to pass system_data
#server_with_data <- function(input, output, session) {
  #server(input, output, session, system_data)}

# Run the Shiny app
shinyApp(ui = ui, server = server)

