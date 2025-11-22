#Analyze group performance
analyze_group_performance <- function(data) {
  group_performance <- data$loans %>%
    group_by(group_id) %>%
    summarise(
      total_members = n_distinct(farmer_id),
      total_loans = n(),
      total_dibursed = sum(loan_amount),
      total_repayable = sum(total_repayable),
      total_repaid = sum(total_repaid),
      outstanding_balance = su(outstanding_balance),
      repayment_rate = (sum(total_repaid) / sum(total_repayable))
      fully_paid_loans = sum(loan_status == "Fully Paid"),
      active_loans = sum(loan_status == "Active"),
      defaulted_loans = sum(loan_status == "Defaulted"),
      default_rate = (sum(loan_status == "Defaulted") / n()) * 100
    ) %>%
    left_join(data$farmer_groups %>% select(group_id, group_name, parish_id,district_id),
              by = "group_id") %>%
    arrange(desc(repayment_rate))
  return(group_performance)
}
#Risk assessment analysis
risk_assessment <- function(data) {
  risk_data <- data$loans %>%
    mutate(
      days_since_disbursement = as.numeric(Sys.Date() - disbursement_date),
      repayment_progress = (total_repaid / total_repayable) *100,
      days_to_repayment1 = as.numeric(expected_repayment_date1 - Sys.Date()),
      days_to_repayment2 = as.numeric(expected_repayment_date2 - Sys.Date())
    ) %>%
    filter(loan_status == "Active") %>%
    mutate(
      risk_level = case_when(
        days_since_disbursement > 180 & repayment_progress < 25 ~ "High Risk",
        days_since_disbursement > 120 & repayment_progress < 50 ~ "Medium Risk",
        days_to_repayment1 < 30 & repayment_progress < 80 ~ "Approaching Due Date",
        TRUE ~ "Low Risk"
      ),
      risk_score = case_when(
        risk_level == "High Risk" ~ 3,
        risk_level == "Medium Risk" ~ 2,
        risk_level == "Approaching Due Date" ~ 1,
        TRUE ~ 0
      )
    )
  return(risk_data)
}
#Gender-based analysis
gender_analysis <- function(data){
  gender_stats <- data$loans %>%
    left_join(data$farmers %>% select(farmer_id, gender), by = "farmer_id") %>%
    group_by(gender) %>%
    summarise(
      total_borrowers = n_distinct(farmer_id),
      total_loans = n(),
      total_disbursed = sum(loan_amount),
      total_repaid = sum(total_repaid),
      repayment_rate = (sum(total_repaid) / sum(total_repayable)) * 100,
      avg_loan_size = mean(loan_amount),
      fully_paid_ratio = sum(loan_status == "Fully Paid") / n()
    )
  return(gender_stats)
    
}












