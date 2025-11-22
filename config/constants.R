#System constants
SYSTEM_CONSTANTS <- list(
  #status codes
  loan_status = c("Active" = "ACT","Fully Paid" = "FP","Defaulted"="DEF"),
  farmer_status = c("Active" = "A", "Inactive" = "I", "Suspended" = "S"),
  
  #Risk levels
  risk_levels = c("Low Risk" = "Low","Medium Risk"="MED", "High Risk" = "High"),
  #Gender codes
  gender_codes = c("Males"="M", "Female"="F", "Other"="0"),
  
  #ID Prefixes
  id_prefixes = list(
    farmer = "FARM",
    loan = "LOAN",
    group = "GRP",
    district = "DIST",
    parish = "PAR"
  )
)
