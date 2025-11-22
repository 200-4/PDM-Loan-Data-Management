source("config/config.R")

#Initialize empty data structures
initialize_data_structures <- function(){
  list(
    districts = data.frame(
      district_id = character(),
      district_name = character(),
      region = character(),
      population = integer(),
      creation_date = as.Date(character()),
      stringsAsFactors = FALSE
      
    ),
    parishes = data.frame(
      parish_id = character(),
      parish_name = character(),
      district_id = character(),
      total_farmers = integer(),
      total_groups = integer(),
      creation_date = as.Date(character()),
      stringsAsFactors = FALSE
    ),
    
    farmer_groups = data.frame(
      group_id = character(),
      group_name = character(),
      parish_id = character(),
      district_id = character(),
      formation_date = as.Date(character()),
      chairperson_name = character(),
      chairperson_phone = character(),
      total_members = integer(),
      status = character(),
      stringsAsFactors = FALSE
    ),
    
    farmers = data.frame(
      farmer_id = character(),
      farmer_name = character(),
      age = integer(),
      gender = character(),
      group_id = character(),
      parish_id = character(),
      district_id = character(),
      phone_number = character(),
      date_registered = as.Date(character()),
      status = character(),
      stringsAsFactors = FALSE
    ),
    
    loans = data.frame(
      loan_id = character(),
      farmer_id = character(),
      group_id = character(),
      parish_id = character(),
      district_id = character(),
      crop_type = character(),
      loan_amount = numeric(),
      interest_rate = numeric(),
      total_repayable = numeric(),
      disbursement_rate = as.Date(character()),
      expected_repayment_date1 = as.Date(character()),
      expected_repayment_date2 = as.Date(character()),
      repayment_amount1 = numeric(),
      repayment_date1 = as.Date(character()),
      repayment_amount2 = numeric(),
      repayment_date2 = as.Date(character()),
      total_repaid = numeric(),
      outstanding_balance = numeric(),
      loan_status = character(),
      last_updated = as.Date(character()),
      stringsAsFactors = FALSE
      
    )
  )
}
#LOAD DATA FROM CSV FILES
load_system_data <- function(){
  data <- list()
  
  tryCatch({
    for (df_name in names(SYSTEM_CONFIG$data_paths)){
      file_path <- SYSTEM_CONFIG$data_paths[[df_name]]
      if (file.exists(file_path)) {
        data[[df_name]] <- read.csv(file_path, stringsAsFactors = FALSE)
        #CONVERT DATE COLUMN
        date_columns <- grepl("date", names(data[[df_name]]), ignore.case = TRUE)
        if (any(date_columns)) {
          data[[df_name]][, date_columns] <- lapply(data[[df_name]][, date_columns], as.Date)
        }
      } else {
        data[[df_name]] <- initialize()[[df_name]]
      }
      
    }
    cat("Data Loaded successfully\n")
    return(data)
  }, error = function(e) {
      cat("Error loading data: ", e$message, "\n")
      return(initialize_data_structures())
  })
}

#save data to CSV Files
save_system_data <- function(data){
  tryCatch({
    for (df_name in names(data)) {
      file.path <- SYSTEM_CONFIG$data_paths[[df_name]]
      write.csv(data[[df_name]], file_path, row.names = FALSE)
    }
    cat("Data saved successfully\n")
    return(TRUE)
  }, error = function(e){
    cat("Error saving data:", e$message, "\n")
    return(FALSE)
  })
}
#create backup
create_data_backup <- function(data) {
  backup_file <- paste0(SYSTEM_CONFIG$data_paths$backups,
                        "pdm_backup_", format(Sys.Date(), "%Y%m%d"), ".rds")
  saveRDS(data, backup_file)
  cat("Backup created:", backup_file, "\n")
}

