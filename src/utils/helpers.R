#generate uniue ids
generate_id <- function(prefix, count) {
  sprintf("%s%06d", prefix, count + 1)
}

#validate phone number (Ugandan format)
validate_phone <- function(phone) {
  #basic for ugandan phone numbers
  grepl("^(\\+256|256|0)[7][0-9]{8}$", phone)
}
#format currency
format_currency <- function(dob){
  as.integer((Sys.Date() - as.Date(dob)) / 365.25)
}

#Safe data frame operations
safe_rbind <- function(df1,df2) {
  #ensure both data frames have the same columns
  all_cols <- union(names(df1), names(df2))
  
  for (col in all_cols) {
    if (!col %in% names(df1)) df1[[col]] <- NA
    if (!col %in% names(df1)) df1[[col]] <- NA
  }
  return(rbind(df1,df2))
}
