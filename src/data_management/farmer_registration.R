source("src/utils/helpers.R")

#Register a new district
register_district <- function(data, district_name, region){
  district_id <- generate_id("DIST", nrow(data$districts))
  
  new_district <- data.frame(
    district_id = district_id,
    district_name = district_name,
    region = region,
    population = 0,
    creation_date = Sys.Date(),
    stringsAsFactors = FALSE
  )
  data$districts <- rbind(data$districts, new_district)
  return(data)
}

#Register a new parish
register_path <- function(data, parish_name, district_id){
  parish_id <- generate_id("PAR", nrow(data$parishes))
  
  new_parish <- data.frame(
    parish_id = parish_id,
    parish_name = parish_name,
    district_id = district_id,
    total_farmers = 0,
    total_roups = 0,
    creation_date = Sys.Date(),
    stringsAsFactors = FALSE
  )
  data$parishes <- rbind(data$parishes, new_parish)
  return(data)
}
#register a farmer group
register_farmer_group <- function(data, group_name, parish_id, district_id, chairperson_name, chairperson_phone){
  group_id <- generate_id("GRP", nrow(data$farmer_groups))
  
  new_id <- data.frame(
    group_id = group_id,
    group_name= group_name,
    parish_id = parish_id,
    district_id = district_id,
    formation_date = Sys.Date(),
    chairperson_name = chairperson_name,
    chairperson_phone = chairperson_phone,
    total_members = 0,
    status = "Active",
    stringsAsFactors = FALSE
  )
  data$farmer_groups <- rbind(data$farmer_groups, new_group)
  return(data)
}

#Register a new farmer
register_farmer <- function(data, name, age, gender, group_id, phone){
  #validate inputs
  if (!validate_phone(phone)){
    stop("Invalid phone number format")
  }
  if (age < 18 || age > 100){
    stop("Farmer age must be between 18 and 100")
  }
  farmer_id <- generate_id("FARM", nrow(data$farmers))
  #Get parish and district from group
  
  group_info <- data$farmer_groups[data$farmer_groups$group_id == group_id, ]
  parish_id <- group_info$parish_id
  district_id <- group_info$district_id
  
  new_farmer <- data.frame(
    farmer_id = farmer_id,
    farmer_name = name,
    age = age,
    gender = gender,
    group_id = group_id,
    parish_id = parish_id,
    district_id = district_id,
    phone_number = phone,
    date_registered = Sys.Date(),
    status = "Active",
    stringsAsFactors = FALSE
  )
  data$farmer <- rbind(data$farmers, new_farmer)
  
  #update group member count
  data$farmer_groups$total_member[data$farmer_groups$group_id == group_id] <-
    data$farmer_groups$total_members[data$farmer_groups$group_id == group_id] +1
  
  #update parish farmer count
  data$parishes$total_farmers[data$parishes$parish_id == parish_id] <-
    data$parishes$total_farmers[data$parishes$parish_id == parish_id] +1
  
  return(data)
}



