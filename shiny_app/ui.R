#PDM FARMER LOAN MANAGEMENT SYSTEM - UI DEFINITION

dashboardPage(
  dashboardHeader(
    title = "PDM Farmer Loan Management System",
    titleWidth = 350
  ),
  
  dashboardSidebar(
    width = 350,
    sidebarMenu(
      id = "tabs",
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Data Management", tabName = "data_management", icon = icon("database"),
               menuSubItem("Register Farmer", tabName = "register_farmer"),
               menuSubItem("Disburse Loan", tabName = "disburse_loan"),
               menuSubItem("Record Repayment", tabName = "record_repayment")),
      menuItem("Reports & Analytics", tabName = "analytics", icon = icon("chart-bar"),
               menuSubItem("Summary Reports", tabName = "Summary_reports"),
               menuSubItem("Perform Analysis", tabName = "performance_analysis"),
               menuSubItem("Risk Assessment", tabName = "risk_assessment")),
      menuItem("Visualization", tabName = "visualizations", icon = icon("chart-line")),
      menuItem("Data Export", tabName = "export", icon = icon("download")),
      menuItem("System Admin", tabName = "admin", icon = icon("cog"))
    )
  ),
  
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href="www/styles.css")
    ),
    
    tabItems(
      #Dashboard Tab
      tabItem(
        tabName = "dashboard",
        fluidRow(
          valueBoxOutput("total_farmers_box"),
          valueBoxOutput("total_loans_box"),
          valueBoxOutput("total_disbursed_box"),
          valueBoxOutput("repayment_rate_box")
        ),
        fluidRow(
          box(
            title = "Loan Disbursement Trend", status = "primary", solidHeader = TRUE, plotlyOutput("disbursement_trend_plot"), width = 6
          ),
          box(
            title = "Repayment Rates by District", status = "success", solidHeader = TRUE,
            plotlyOutput("district_repayment_plot"), width = 6
          )
        ),
        fluidRow(
          box(
            title = "Loan Status Distribution", status = "info", solidHeader = TRUE,
            plotlyOutput("loan_status_plot"), width = 6
          ),
          box(
            title = "Recent Activities", status = "warning", solidHeader = TRUE,
            DTOutput("recent_activities_table"), width = 6
          )
        )
      ),
      
      #Register Farmer Tab
      tabItem(
        tabName = "register_farmer",
        box(
          title = "Register New Farmer", status = "primary", solidHeader = TRUE, width = 12,
          fluidRow(
            column(6, 
                   textInput("farmer_name", "Farmer Name*", placeholder = "Enter full name"),
                   numericInput("farmer_age", "Age*", value = NULL, min = 18, max = 100),
                   selectInput("farmer_gender","Gender*", choices = c("", "Male", "Female", "Other"))
            ),
            column(6,
                   selectInput("farmer_district","District*", choices = c("")),
                   selectInput("farmer_parish", "Parish*", choices = c("")),
                   textInput("farmer_phone", "Phone Number*", placeholder = "07XXXXXXXXX")
            )
          ),
          actionButton("register_farmer_btn", "Register Farmer", class = "btn-primary"),
          br(), br(),
          DTOutput("farmer_table")
        )
      ),
      
      #Disburse Loan Tab
      tabItem(
        tabName = "disburse_loan",
        box(
          title = "Disburse New Loan", status = "success", solidHeader = TRUE, width = 12,
          fluidRow(
            column(6,
                   selectInput("loan_farmer", "Select Farmer*", choices = c("")),
                   selectInput("loan_crop", "Crop Type*", choices = c("")),
                   numericInput("loan_amount", "Loan Amount (UGX)*", value = NULL, min = 100000, max = 10000000)
            ),
            column(6,
                   verbatimTextOutput("farmer_info"),
                   verbatimTextOutput("loan_calculations")
            )
          ),
          actionButton("disburse_loan_btn", "Disburse Loan", class = "btn-success"),
          br(), br(),
          DTOutput("loans_table")
        )
      ),
      
      #Record Repayment Tab
      tabItem(
        tabName = "record_repayment",
        box(
          title = "Record Loan Repayment", status = "info", solidHeader = TRUE, width = 12,
          fluidRow(
            column(6,
                   selectInput("repayment_loan", "Select Loan*", choices = c("")),
                   numericInput("repayment_amount", "Repayment Amount (UGX)*", value = NULL),
                   selectInput("repayment_instalment", "Installment Number*", choices = c("1" = 1, "2" = 2))
            ),
            column(6, 
                   verbatimTextOutput("loan_details"),
                   verbatimTextOutput("repayment_summary")
            )
          ),
          actionButton("record_repayment_btn", "Record Repayment", class = "btn-info"),
          br(), br(),
          DTOutput("repayment_table")
        )
      ),
      
      #Summary Reports Tab
      tabItem(
        tabName = "Summary_reports",
        box(
          title = "System Summary Reports", status = "primary", solidHeader = TRUE, width = 12,
          fluidRow(
            column(3,
                   selectInput("report_period", "Report Period",
                               choices = c("Weekly", "Monthly", "Quarterly", "Annual"), selected = "Monthly")),
            column(3, 
                   actionButton("generate_report", "Generate Report", class = "btn-primary")
            )
          ),
          br(),
          fluidRow(
            column(6,
                   DTOutput("district_summary_table")
            ),
            column(6, DTOutput("crop_summary_table"))
          ),
          br(),
          fluidRow(
            column(12, 
                   DTOutput("detailed_loan_table")
            )
          )
        )
      ),
      
      #Performance Analysis Tab
      tabItem(
        tabName = "performance_analysis",
        tabBox(
          width = 12,
          tabPanel("Group Performance",
                   DTOutput("group_performance_table")),
          tabPanel("Gender Analysis", 
                   DTOutput("gender_analysis_table")),
          tabPanel("Crop Performance",
                   DTOutput("crop_performance_table"))
        )
      ),
      
      #Visualization Tab
      tabItem(
        tabName = "visualizations",
        fluidRow(
          box(
            title = "Repayment Rate by District", width = 6,
            plotlyOutput("viz_district_repayment")
          ),
          box(
            title = "Loan Status Distribution", width = 6,
            plotlyOutput("viz_loan_status")
          )
        ),
        fluidRow(
          box(
            title = "Monthly Disbursement Trend", width = 6,
            plotlyOutput("viz_disbursement_trend")
          ),
          box(
            title = "Crop Performance", width = 6,
            plotlyOutput("viz_crop_performance")
          )
        )
      ),
      
      #Data Export Tab
      tabItem(
        tabName = "export",
        box(
          title = "Data Export", status = "primary", solidHeader = TRUE, width = 12,
          fluidRow(
            column(4,
                   selectInput("export_data", "Select Data to Export", choices = c("Farmers","Loans", "Groups","Districts", "All Data"))
            ),
            column(4, 
                   selectInput("export_format", "Export Format", choices = c("CSV","Excel"))),
            column(4, br(), downloadButton("download_data", "Download Data"))
          )
        )
      )
    )
  )
)