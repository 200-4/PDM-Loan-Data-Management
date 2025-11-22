source("config/config.R")

#Create repayment rate by district plot
plot_repayment_by_district <- function(data) {
  district_data <- data$loans %>%
    group_by(district_id) %>%
    summarise(
      repayment_rate = (sum(total_repaid) / sum(total_repayable)) * 100
    ) %>%
    left_join(data$districts %>% select(district_id, district_name), by = "district_id")
  
  p <- ggplot(district_data, aes(x = reorder(district_name, repayment_rate), y = repayment_rate)) +
    geom_col(fill = "steelblue", alpha = 0.8) + 
    geom_text(aes(label = paste0(round(repayment_rate, 1), "%")),
              hjust = -0.1, size = 3) + coord_flip() +
    labs(
      title = "Loan Repayment Rates by District",
      x = "District",
      y = "Repayment Rate (%)"
    ) + 
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5, face = "bold"))
  return(p)
}


#Loan status distribution plot
plot_loan_status <- function(data){
  status_data <- data$loans %>%
    count(loan_status) %>%
    mutate(percentage = n / sum(n) * 100)
  p <- ggplot(status_data, aes(x = "", y = n, fill = loan_status) ) +
    geom_bar(stat = "identity", width = 1) + coord_polar("y", start = 0) +
    geom_text(aes(label = paste0(round(percntage, 1), "%")),
              position = position_stack(vjust = 0.5)) + 
    labs(
      title = "Loan Status Distribution",
      fill = "Loan Status"
    ) + 
    theme_void() + 
    theme(plot.title = element_text(hjust = 0.5, face = "bold"))
  
  return(p)
}

#create monthly disbursement trend
plot_disbursement_trend <- function(data) {
  trend_data <- data$loans %>%
    mutate(month = floor_date(disbursement_date, "month")) %>%
    group_by(month) %>%
    summaise(
      total_disbursed = sum(loan_amount),
      number_of_loans = n()
    ) %>%
    filter(month >= Sys.Date()- 365)
  p <- ggplot(trend_data, aes(x = month, y = total_disbursed)) +
    geom_line(color = "blue", size = 1) +
    geom_point(color = "blue", size = 2) +
    geom_area(fill = "lightblue", alpha = 0.3) +
    labs(
      title = "Monthly Loan Disbursement trend",
      x = "Month",
      y = "Total Amount Distribution (ugx)"
    ) + 
    theme_minimal() +
    scale_y_continous(labels = scales::comma) + 
    theme(plot.title = element_text(hjust = 0.5, face = "bold"))
  return(p)
}
#create crop performance comparison
plot_crop_performance <- function(data) {
  crop_data <- data$loans %>%
    summarise(
      avg_repayment_rate = mean((total_repaid / total_repayable) * 100, na.rm = TRUE),
      total_loans = n()
    ) %>%
    filter(total_loans >= 5) #showing significant data only
  p <- ggplot(crop_data, aes(x = reorder(crop_type, avg_repayment_rate), y= avg_repayment_rate)) +
                             geom_col(fill = "darkgreen", alpha = 0.8) + 
                               geom_text(aes(label = paste0(round(avg_repayment_rate, 1), "%")),
                             hjust = -0.1, size = 3
                             ) + coord_flip() + labs(
                               title = "Average Repayment Rate by Crop Type",
                               x = "Crop Type",
                               y = "Average Repayment Rate (%)"
                             ) + 
                theme_minimal() + theme(plot.title = element_text(hjust = 0.5, face = "bold"))
  return(p)
                
}














