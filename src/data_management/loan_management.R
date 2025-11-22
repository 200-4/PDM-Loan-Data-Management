source("config/config.R")

#DISBURSE A NEW LOAN
disburse_loan <- function(dta, farmer_id, crop_type, loan_amount){
  #validate loan amount
  if (loan_amount < SYSTEM_CONFIG$parameters$min_loan_amount || 
      loan_amount > SYSTEM_CONFIG$parameters$max_loan_amount) {
    stop("Loan amount outside acceptable range")
  }
  
  #get farmer info
  farmer_info <- data$farmers[data$farmers$farmer_id == farmer_id, ]
  group_id <- farmer_info$group_id
  parish_id <- farmer_info$parish_id
  district_id <- farmer_info$district_id
  
  #calculate amount with interest
  interest_rate <- SYSTEM_CONFIG$ parameters$interest_rate
  total_repayable <- loan_amount * (1 + interest_rate)
  
  #calculate repayment dates
  disbursement_date <- Sys.Date()
  expected_repayment_date1 <- disbursement_date %m+% months(6)
  expected_repayment_date2 <- disbursement_date %m+% months(12)
  
  new_loan <- data.frame(
    loan_id = loan_id,
    farmer_id = farmer_id,
    group_id = group_id,
    parish_id = parish_id,
    district_id = district_id,
    crop_type = crop_type,
    loan_amount = loan_amount,
    interest_rate= interest_rate,
    total_repayable = total_repayable,
    disbursement_date = disbursement_date,
    expected_repayment_date1 = expected_repayment_date1,
    expected_repayment_date2 = expected_repayment_date2,
    repayment_amount1 = 0,
    repayment_date1 = as.Date(NA),
    repayment_amount2 = 0,
    repayment_date2 = as.Date(NA),
    total_repaid = 0,
    outstanding_balance = total_repayable,
    loan_status = "Active",
    last_updatd = Sys.Date(),
    stringsAsFactors =FALSE
    
  )
  data$loans <- rbind(data$loans, new_loan)
  return(data)
}

#Record loan repayment
record_repayment <- function(data, loan_id, repayment_amount, installment_number){
  loan_index <- which(data$loan_id == loan_id)
  
  if (length(loan_index) == 0){
    stop("Loan ID Not Found")
    
  }
  if (installment_number == 1){
    data$loans$repayment_amount1[loan_index] <- repayment_amount
    data$loans$repayment_date1[loan_index] <- Sys.Date()
    
  } else if (installment_number == 2){
    data$loans$repayment_amount2[loan_index] <- repayment_amount
    data$loans$repayment_date2[loan_index] <- Sys.Date()
    
  } else {
    stop("Installment number must be 1 or 2")
    
  }
  
  
  #update totals
  data$loan$total_repaid[loan_index] <- data$loans$repayment_amount1[loan_index]
  + data$loans$repayment_amount2[loan_index]
  data$loan$outstanding_balance[loan_index] <- data$loans$total_repayable[loan_index] - 
    data$loans$total_repaid[loan_index]
  
  #update loan status
  if (data$loans$total_repaid[loan_index] >= data$loans$repayment_amount2[loan_index]){
    data$loans$loan_status[loan_index] <- "Fully paid"
    
  } else if (data$loans$disbursement_data[loan_index] < Sys.Date() - 365 && data$loans$total_repaid[loan_index] 
             < data$loans$total_repayable[loan_index] * 0.5) {
               
               data$loans$loan_status[loan_index] <- "Defaulted"
  } else { data$loans$loan_status[loan_index] <- "Active"}
  data$loans$last_updated[loan_index] <- Sys.Date()
  return(data)
             
}

#update loan status for all loans
update_all_loan_statuses <- function(data) {
  data$loans <- data$loans %>%
    mutate(
      total_repaid = repayment_amount1 + repayment_amount2,
      outstanding_balance = total_repayable - total_repaid,
      loan_status = case_when(
        total_repaid <= total_repayable ~ "Fully Paid",
        disbursement_date < Sys.Date() - 365 & total_repaid < total_repayable * 0.5 ~ "Defaulted",
        TRUE ~ "Active"
      ),
      last_updated = Sys.Date()
    )
  return(data)
}


