#PDM FARMER LOAN MANAGEMENT SYSTEM - SERVER LOGIC

server <- function(input, output, session ){
  # Reactive values for data storage
  values <- reactiveValues(
    data = system_data,
    summary = NULL
  )
  
  #Update summary when data changes
  observe({
    rep(values$data)
    values$summary <- generate_summary_dashboard(values$data)
  })
  
  #Dashboard value boxes
  output$total_farmers_box <- renderValueBox({
    req(values$summary)
    valueBox(
      values$summary$total_farmers, "Total Farmers",
      icon = icon("users"), color = "blue"
    )
  })
  
  output$total_loans_box <- renderValueBox({
    req(values$summary)
    valueBox(
      values$summary$total_loans, "Total Loans",
      #nrow(values$data$loans), "Total Loans", 
      icon = icon("hand-holding-usd"), color = "green"
    )
  })
  
  output$total_disbursed_box <- renderValueBox({
    total_dis <- sum(values$data$loans$loan_amount, na.rm = TRUE)
    valueBox(
      paste0("UGX ", format(total_dis, big.mark = ",")), "Total Disbursed",
      icon = icon("money-bill-wave"), color = "orange"
    )
  })
  
  output$repayment_rate_box <- renderValueBox({
    if (nrow(values$data$loans) > 0) {
      repayment_rate <- (sum(values$data$loans$total_repaid, na.rm = TRUE) / 
                         sum(values$data$loans$loan_amount, na.rm = TRUE)) * 100
    } else {
      repayment_rate <- 0
    }
    
    valueBox(
      paste0(round(repayment_rate, 1), "%"), "Repayment Rate",
      icon = icon("percent"), color = ifelse(repayment_rate > 60, "green", "red")
    )
  })
  
  #Dashboard plots
  output$disbursement_trend_plot <- renderPlotly({
    if (nrow(values$data$loans) > 0) {
      plot_data <- values$data$loans %>%
        group_by(disbursement_date = as.Date(disbursement_date)) %>%
        summarise(total = sum(loan_amount, na.rm = TRUE), .groups = 'drop')
      
      ggplotly(ggplot(plot_data, aes(x = disbursement_date, y = total)) +
                 geom_line() + geom_point() +
                 labs(title = "Loan Disbursement Trend",
                      x = "Date", y = "Amount (UGX)"))
    }
  })
  
  output$district_repayment_plot <- renderPlotly({
    if (nrow(values$data$loans) > 0) {
      plot_data <- values$data$loans %>%
        group_by(district_id) %>%
        summarise(
          repayment_rate = (sum(total_repaid, na.rm = TRUE) / 
                           sum(loan_amount, na.rm = TRUE)) * 100,
          .groups = 'drop'
        )
      
      ggplotly(ggplot(plot_data, aes(x = district_id, y = repayment_rate)) +
                 geom_col() +
                 labs(title = "Repayment Rate by District",
                      x = "District", y = "Repayment Rate (%)"))
    }
  })
  
  output$loan_status_plot <- renderPlotly({
    if (nrow(values$data$loans) > 0) {
      plot_data <- values$data$loans %>%
        group_by(loan_status) %>%
        summarise(count = n(), .groups = 'drop')
      
      ggplotly(ggplot(plot_data, aes(x = loan_status, y = count, fill = loan_status)) +
                 geom_col() +
                 labs(title = "Loan Status Distribution",
                      x = "Status", y = "Count"))
    }
  })
  
  #DATA MANAGEMENT OBSERVERS
  observeEvent(input$register_farmer_btn, {
    tryCatch({
      values$data$farmers <- rbind(
        values$data$farmers,
        data.frame(
          farmer_id = paste0("F", nrow(values$data$farmers) + 1),
          farmer_name = input$farmer_name,
          age = input$farmer_age,
          gender = input$farmer_gender,
          parish_id = input$farmer_parish,
          district_id = input$farmer_district,
          phone_number = input$farmer_phone,
          date_registered = Sys.Date(),
          status = "Active"
        )
      )
      showNotification("Farmer registered successfully", type = "message")
    }, error = function(e){
      showNotification(paste("Error:", e$message), type = "error")
    })
  })
  
  #update dropdowns based on selections
  observeEvent(input$farmer_district, {
    if (input$farmer_district != "") {
      parishes <- unique(values$data$farmers$parish_id)
      updateSelectInput(session, "farmer_parish", choices = c("", parishes))
    }
  })
  
  #tables for data management
  output$farmer_table <- renderDT({
    datatable(values$data$farmers, options = list(scrollX = TRUE))
  })
  
  output$loans_table <- renderDT({
    datatable(values$data$loans, options = list(scrollX = TRUE))
  })
  
  output$recent_activities_table <- renderDT({
    recent <- tail(values$data$loans, 10)
    datatable(recent[, c("loan_id", "farmer_id", "loan_amount", "disbursement_date")], 
              options = list(scrollX = TRUE))
  })
  
  output$group_performance_table <- renderDT({
    if (nrow(values$data$farmer_groups) > 0) {
      group_perf <- values$data$farmer_groups %>%
        left_join(values$data$loans, by = "group_id") %>%
        group_by(group_name) %>%
        summarise(
          total_members = first(total_members),
          total_disbursed = sum(loan_amount, na.rm = TRUE),
          total_repaid = sum(total_repaid, na.rm = TRUE),
          .groups = 'drop'
        )
      datatable(group_perf, options = list(scrollX = TRUE))
    }
  })
  
  output$gender_analysis_table <- renderDT({
    if (nrow(values$data$farmers) > 0) {
      gender_analysis <- values$data$farmers %>%
        group_by(gender) %>%
        summarise(count = n(), .groups = 'drop')
      datatable(gender_analysis, options = list(scrollX = TRUE))
    }
  })
  
  output$crop_performance_table <- renderDT({
    if (nrow(values$data$loans) > 0) {
      crop_perf <- values$data$loans %>%
        group_by(crop_type) %>%
        summarise(
          count = n(),
          total_amount = sum(loan_amount, na.rm = TRUE),
          total_repaid = sum(total_repaid, na.rm = TRUE),
          .groups = 'drop'
        )
      datatable(crop_perf, options = list(scrollX = TRUE))
    }
  })
  
  #Export functionality
  output$download_data <- downloadHandler(
    filename = function(){
      paste0("pdm_data_", Sys.Date(), ".", tolower(input$export_format))
    },
    content = function(file){
      if (input$export_format == "CSV") {
        write.csv(values$data$loans, file, row.names = FALSE)
      } else {
        writexl::write_xlsx(values$data$loans, file)
      }
    }
  )
}
