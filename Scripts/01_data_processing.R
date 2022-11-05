library(tidyverse)

cumul_data = data.frame()
temp_record = data.frame()
ramp_record = data.frame()
file_list = dir(path = "Data/time_data/")

all_runs = str_split_fixed(file_list, pattern = "_time.xlsx", n = 2)[,1]
if(process_all_data == T){
  prev_runs = NA #Use this line the first time the script is run to process all files
  new_files = "yes"
}else{
  prev_runs = read.table(file = "Output/Data/prev_runs.txt", header = T)
  prev_runs = prev_runs$x
  new_files = "no"
}

new_runs = all_runs[which(!(all_runs %in% prev_runs))]
runs = c()

if(length(new_runs) > 0){
  for(f in 1:length(new_runs)){
    file_name = new_runs[f]
    runs = c(runs, file_name)
    
    #Loads data from temperature sensors (logging at 5 second intervals)
    temp_data <- read_csv(paste("Data/temperature_data/", file_name, "_temp.CSV", collapse = "", sep = "")) %>% 
      mutate("Time" = as.character(Time),
             "Date" = as.POSIXct(Date))
    
    time_data <- readxl::read_excel(paste("Data/time_data/", file_name, "_time.xlsx", collapse = "", sep = ""), na = "NA") %>% 
      drop_na(minute)%>%
      mutate(time = (minute + (second / 60)) - 2, #Accounts for the two minute delay at startup in the temperature logger
             'run_date' = as.POSIXct(run_date),
             start_time = as.POSIXct(start_time)) %>% 
      mutate("rank" = dense_rank(desc(time)))
    
    if(paste(file_name, "_length.xlsx", collapse = "", sep = "") %in% dir("Data/body_size/")){
      length_data <- readxl::read_excel(paste("Data/body_size/", file_name, "_length.xlsx", collapse = "", sep = ""),
                                        na = "NA")
    }else{
      length_data = tibble("tube" = time_data$tube,
                           "length" = NA,
                           "sex" = NA)}
    
    td = temp_data %>% 
      mutate("time_point" = row_number(), #assigns each time point a sequential value
             "second_passed" = time_point * 5, #converts time point to seconds passed since logging began
             "minute_passed" = second_passed / 60,
             "minute_interval" = floor(second_passed / 60)) %>% #integer math to convert from seconds since logging began to minute time interval 
      #filter(time_point > 15) %>% #removes initial temperature ramping
      pivot_longer(cols = c(Temp1, Temp2, Temp3), #Pivots data set so there's only one column of temperature data
                   names_to = "sensor",
                   values_to = "temp_C") %>% ungroup()
    
    min_ramp = td  %>% 
      group_by(sensor, minute_interval) %>% #Calculates rate of change for each sensor during each of the minute time intervals
      group_modify(~ data.frame(
        "ramp_per_second" = unclass(
          coef(lm(data = .x, temp_C ~ second_passed))[2]))) 
    
    min_ramp$ramp_per_minute = min_ramp$ramp_per_second * 60
    
    min_ramp$run = length(prev_runs) + f
    
    ### Combine with time data to get CTmax values 
    ind_measurements = data.frame()
    for(i in 1:dim(time_data)[1]){
      ct_time = time_data$time[i]
      tube = time_data$tube[i]
      rank = time_data$rank[i]
      values = td %>% 
        dplyr::filter(minute_passed > (ct_time - (0.1 * rank)) & minute_passed < (ct_time)) %>% 
        summarise(
          "tube" = tube,
          "ct_max" = mean(temp_C))
      
      ramp_data = min_ramp %>% 
        dplyr::filter(minute_interval > (ct_time - 5) & minute_interval < ct_time) %>% 
        ungroup() %>% 
        summarise("ramp_rate" = mean(ramp_per_minute))
      
      ind_measurements = bind_rows(ind_measurements, data.frame(values, ramp_data))
    }
    
    ct_data = inner_join(time_data, ind_measurements, by = c("tube"))
    ct_data = inner_join(ct_data, length_data, by = c("tube"))
    write.csv(ct_data, file = paste("Output/Data/", file_name, "_ctmax.csv", sep = "", collapse = ""))
    
    ct_data$run =length(prev_runs) + f
    cumul_data = bind_rows(cumul_data, ct_data) 
    
    td$run = length(prev_runs) + f
    temp_record <- bind_rows(temp_record, td)
    
    ramp_record = bind_rows(ramp_record, min_ramp)
  }
  
  #Assigns the specified Order to each species
  full_data = cumul_data
  
  if(new_files == "yes"){
    #Records full data set
    write.table(x = runs, file = "Output/Data/prev_runs.txt", row.names = F) 
    write.table(x = full_data, file = "Output/Data/full_data.csv", sep = ",", row.names = F)
    write.table(x = temp_record, file = "Output/Data/temp_record.csv", sep = ",", row.names = F)
    write.table(x = ramp_record, file = "Output/Data/ramp_record.csv",  sep = ",", row.names = F)
  }else{
    #Records full data set
    write.table(x = runs, file = "Output/Data/prev_runs.txt", row.names = F, col.names = F, append = T) 
    write.table(x = full_data, file = "Output/Data/full_data.csv", sep = ",", row.names = F,col.names =F, append = T)
    write.table(x = temp_record, file = "Output/Data/temp_record.csv", sep = ",", row.names = F,col.names =F, append = T)
    write.table(x = ramp_record, file = "Output/Data/ramp_record.csv",  sep = ",", row.names = F, col.names =F,  append = T)
  }
}


