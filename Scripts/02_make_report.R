library(rmarkdown)
library(tidyverse)

process_all_data = F
make_figures = F
knit_manuscript = T

#Process the temperature and time data to estimate CTmax values
source(file = "Scripts/01_data_processing.R")

#Read in the processed data
full_data = read.csv(file = "Output/Data/full_data.csv")
temp_record = read.csv(file = "Output/Data/temp_record.csv")
ramp_record = read.csv(file = "Output/Data/ramp_record.csv")

#Make Figures
if(make_figures == T){
  
  # Cell concentration data to calculate grazing rates
  cell_data = readxl::read_excel(path = "Data/grazing_test.xlsx") %>% 
    drop_na(cells)
  
  render(input = "Output/Reports/project_figures.Rmd", #Input the path to your .Rmd file here
         output_file = "project_figures.html") #Name your file here; as it is, this line will create reports named with the date
}

# Loads in just the starvation data object
starv_data = full_data %>% 
  filter(experiment == "two") %>% 
  mutate("cumul_day" = as.numeric(as.Date(run_date) - first(as.Date(run_date))),
         "rep" = case_when(
           cumul_day < 6 ~ 1,
           cumul_day > 104 ~ 5, 
           cumul_day > 60 ~ 4, 
           cumul_day > 19 ~ 3,
           cumul_day > 6 ~ 2)) %>% 
  group_by(rep) %>% 
  mutate("rep_day" = cumul_day - first(cumul_day))

if(knit_manuscript == T){
  #Render the manuscript draft
  render(input = "Manuscript/Moreno_and_Sasaki_2023.Rmd", #Input the path to your .Rmd file here
         output_file = "Moreno_and_Sasaki_2023", #Name your file here; as it is, this line will create reports named with the date
         output_dir = "Output/Drafts/",
         output_format = "all",
         clean = T)
}
