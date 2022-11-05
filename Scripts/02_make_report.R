library(rmarkdown)

process_all_data = F
make_figures = F

#Process the temperature and time data to estimate CTmax values
source(file = "Scripts/01_data_processing.R")

#Read in the processed data
full_data = read.csv(file = "Output/Data/full_data.csv")
temp_record = read.csv(file = "Output/Data/temp_record.csv")
ramp_record = read.csv(file = "Output/Data/ramp_record.csv")

#Make Figures
if(make_figures == T){
  render(input = "Output/Figures/project_figures.Rmd", #Input the path to your .Rmd file here
         output_file = "project_figures.html") #Name your file here; as it is, this line will create reports named with the date
}

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

#Render the manuscript draft
render(input = "Manuscript/Sasaki_and_Moreno_2023.Rmd", #Input the path to your .Rmd file here
       output_file = paste("draft_", Sys.Date(), ".pdf", sep = ""), #Name your file here; as it is, this line will create reports named with the date
       output_dir = "Output/Drafts/") #Set the path to the desired output directory here
