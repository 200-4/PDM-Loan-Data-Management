# PDM Farmer Loan Management System

A shiny-based web application for managing farmer loans under the Parish Development Model (PDM) initiative
![PDM_SYSTEM_IMAGE](Images/PDM_USER_FLOW.jpg)

## Overview
This system allows the ministry of Agriculture to record,manage,and analyze PDM Farmer loan data. It supports operations such as farmer registration,loan disbursement,repayment recording,
and generation of reports and visualizations

## Features

- **Data Management**
  - Register and manage districts,parishes,farmer groups,and farmers.
  - Disburse loans to farmers and record repayments.
- **Loan Tracking**:
  - Track Loan Status (Active,Fully Paid, Defaulted).
  - Monitor repayment progress
- **Reporting and analytics**
  - View summary statistics (total loans, amount disbursed, repayment rate, etc)
  - Performance analysis by district, parish, group, crop type, and gender
  -  Risk assessment of loans.
- **Data Visualization**:
  - Interactive charts and plots for repayment rates, loan status, disbursement trends, etc.

## System Reuiremnts
- R (version 4.5 or higher)
- Rstudio (recommended)
## Installation
1. Clone or download the project repository
2. Open the project in Rstudio.
3. Install the required R packages by running the following in R


```r
install.packages(c("shiny","shinydashboard","DT","plotly","dplyr",ggplot2","lubridate"."stringr","readxl","writexl", "openxlsx"))
