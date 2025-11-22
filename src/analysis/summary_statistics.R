#Generate summary statistics
generate_summary_dashboard <- function(data) {
  summary <- list()
  
  #basic counts
  summary$total_districts <- n_distinct(data$districts$district_id)
  summary$total_parishes <- n_distinct(data$parishes$parish_id)
  summary$total_groups <- n_distinct(data$farmer_groups$group_id)
  summary$total_farmers <- n_distinct(data$farmers$farmer_id)
  summary$total_loans <- nrow(data$loans)
  
  #loan amounts
  summary$total_disbursed <- sum(data$loans$loan_amount, na.rm = TRUE)
  summary$total_repayable <- sum(data$loans$total_repayable, na.rm = TRUE)
  summary$total_repaid <- sum(data$loans$total_repaid, na.rm =  TRUE)
  summary$total_oustanding <- sum(data$loans$outstanding_balance, na.rm = TRUE)
  
  #Rates and averages
  summary$repayment_rate <- (summary$total_repaid / summary$total_repayable) * 100
  summary$avg_loan_size <- mean(data$loans$loan_amount, na.rm=TRUE)
  summary$avg_repayment <- mean(data$loans$total_repaid, na.rm = TRUE)
  
  #status breakdown
  summary$loan_satus_summary <- data$loans %>%
    count(loan_status) %>%
    mutate(percentage = (n / sum(n)) * 100)
  
  #District performance
  summary$district_performance <- data$loans %>%
    group_by(district_id) %>%
    summarise(
      total_loans = n(),
      total_disbursed = sum(loan_amount),
      total_repaid = sum(total_repaid),
      repayment_rate = (sum(total_repaid) / sum(total_repayable)) * 100,
      avg_loan_size = mean(loan_amount)
    ) %>%
    arrange(desc(repayment_rate))
  return(summary)
    
}
#generate period based reports
generate_periodic_reports <- function(data, period= "Monthly") {
  current_date <- Sys.Date()
  
  if (period == "Monthly"){
    start_date <- floor_date(current_date, "month")
  } else if (period == "Quarterly"){
    start_date <- floor_date(cuurent_date, "quarter")
  } else if (period == "Annual"){
    start_date <- floor_date(current_date, "Year")
  } else {
    start_date <- current_date - 30 # can be changed
  }
  
  period_loans <- data$loans %>%
    filter(disbursement_date >= start_date)
  report <- list(
    period = period,
    start_date = start_date,
    end_date = current_date,
    loans_disbursed = nrow(period_loans),
    amount_disbursed = sum(period_loans$loan_amount),
    amount_repaid = sum(period_loans$total_repaid),
    new_farmers = nrow(data$farmers %>% filter(date_registered >= start_date)),
    new_groups = nrow(data$farmer_groups %>% filter(formation_date >= start_date))
  )
  return(data)
}













