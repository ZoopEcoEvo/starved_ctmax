library(tidyverse)


# ####Randomization for Experiment 1####
# #RAN ON 6/21/2022       
# #DO NOT RUN AGAIN 
# #DO NOT RUN AGAIN
# #DO NOT RUN AGAIN
# 
# num_treatments.1 = 3 #Total number of treatment groups
# treatment_levels.1 = c("control", "tetraselmis", "oxyrrhis") #Names for the different treatment groupings
# n_per_treatment.1 = 20 #Total number of plates per treatment group
# total_n.1 = num_treatments.1 * n_per_treatment.1 #Total sample size for one experimental trial
# num_exp.1 = total_n.1 / 10
# 
# #Creates vector with required numbers of each diet
# individuals.1 = rep(treatment_levels.1, each = n_per_treatment.1)
# 
# #Creates a data frame to store the details about the experimental set up 
# setup.1 = data.frame("id" = seq(1:total_n.1),
#                      "treatment" = sample(x = individuals.1, size = total_n.1, replace = F),
#                      "replicate" = sample(x = rep(1:num_exp, each = 10), size = total_n.1, replace = F)) %>% 
#   select(-id) %>% 
#   dplyr::arrange(replicate) %>%
#   group_by(replicate) %>% #Arranges the data by source cup to make setting up the experiment easier
#   mutate(tube = sample(x = 1:10, size = 10, replace = F)) 
# table(setup.1$replicate, setup.1$tube)
# 
# 
# write.csv(setup.1, file = "Background/setup/exp1_summary.csv", row.names = F)
# 
# sum_table.1 = setup.1 %>% 
#   group_by(replicate) %>% 
#   count(treatment) %>%  
#   pivot_wider(id_cols = replicate, 
#               names_from = treatment, 
#               values_from = n)
# 
# write.csv(sum_table.1, file = "Background/setup/exp1_setup.csv", row.names = F)



#### Randomization for Experiment 2####
# 
# ### experiment setup ###
# replicate_levels <- c(1,2,3) #total number of replicates for the experiment
# 
# num_treatments.2 = 2 
# treatment_levels.2 = c("control", "starvation")
# n_per_treatment.2 = 25 # individuals per treatment
# total_n.2 = num_treatments.2 * n_per_treatment.2 #total individuals per replicate
# num_days.2 = total_n.2/10 #number of days per replicate
# 
# num_cups.2 = 6 #total number of cups
# n_per_cup.2 = 15
# cupped_n = n_per_cup.2 * num_cups.2 #total individuals in cups
# cupped_n_per_treatment.2 = cupped_n / num_treatments.2
# cupped_n_treatments.2 <- rep(treatment_levels.2, each = cupped_n_per_treatment.2) #assign cupped individuals to treatments
# 
# #vector of required individuals per treatment per replicate
# individuals.2 = rep(treatment_levels.2, each = n_per_treatment.2)
# 
# experiment_setup <-list()
# cup_treatments.2 <-list()
# cup_info.2 <- list()
# 
# for(t in seq_along(replicate_levels)) {
#   #tibble to assign cups to a treatment
#   cup_treatments.2[[t]] <- tibble("id" = seq(1:num_cups.2),
#                                   "treatment" = sample(x = rep(treatment_levels.2, each = num_cups.2/num_treatments.2), replace = F))
#   #cumulative cup tibble 
#   cup_info.2[[t]] <- tibble( "id" = seq(1:cupped_n),
#                              "treatment" = sample(x = cupped_n_treatments.2, size = cupped_n, replace = F),
#                              "source_cup" = NA)
#   
#   
#   
#   for(q in 1:num_treatments.2) {
#     cups = cup_treatments.2[[t]]$id[which(cup_treatments.2[[t]]$treatment == treatment_levels.2[q])] #select cup by specific treatment level
#     cupped_individuals = cup_info.2[[t]]$id[which(cup_info.2[[t]]$treatment == treatment_levels.2[q])] #select individual by specific treatment level
#     
#     if(length(cupped_individuals) == cupped_n_per_treatment.2) { #double check number of cupped individuals per treatment
#       source_cup = sample(rep(x = cups, each = n_per_cup.2), replace = F) #select number of individuals per cup
#       source_cup -> cup_info.2[[t]]$source_cup[which(cup_info.2[[t]]$treatment == treatment_levels.2[q])] #assign number of individuals to cup of specified treatment
#       
#     }else{
#       print("Incorrect sample size in treatment")
#     } 
#     
#     
#   }
#   
#   #arrange  setup tibble in list by order of cup 
#   cup_info.2[[t]] <- cup_info.2[[t]] %>% 
#     dplyr::arrange(source_cup)
#   
#   
#   
#   experiment_setup[[t]] <- tibble("id" = total_n.2,
#                                   "day" = sample(x = rep(1:num_days.2, each = 10), size = total_n.2, replace = F),
#                                   "cup" = sample(x = rep(cup_info.2[[t]]$source_cup, each = 10), size = total_n.2, replace = F) ) %>%
#     select(-id) %>%
#     arrange(day) %>%    
#     group_by(day) %>%
#     mutate(tube = sample(x = 1:10, size = 10, replace = F))
# }
# 
# table(cup_info.2[[1]]$treatment, cup_info.2[[1]]$source_cup)
# table(experiment_setup[[1]]$cup)
# 
# #write the csv file used to set up the samples 
# write.table(cup_info.2, file = "Background/setup/exp2_setup.csv", row.names = F, sep = ",")



### Matt's Version
#replicate 1: ran on 7/10/2022
#replicate 2: ran on 7/16/2022
#replicate 3: ran on 7/29/2022
#replicate 4: ran on 09/10/2022

### experiment setup ###
num_treatments.2 = 2 
num_cups.2 = 6 #total number of cups
n_per_cup.2 = 20
n_per_treatment.2 = 25 # individuals per treatment
total_n.2 = num_treatments.2 * n_per_treatment.2 #total individuals per replicate
num_days.2 = total_n.2/10 #number of days per replicate

#randomly assigns cups to the two treatments
cup_setup = data.frame("diet" = rep(c("starved", "fed"), each = num_cups.2 / num_treatments.2),
                       "cup" = sample(c(1:num_cups.2), replace = F))

#Creates vectors with the correct number of individuals per treatment, ID'd based on source cup
starve_inds = sample(rep(cup_setup$cup[which(cup_setup$diet == "starved")], 
                         each = n_per_cup.2), 
                     size = n_per_treatment.2, replace = F)

fed_inds = sample(rep(cup_setup$cup[which(cup_setup$diet == "fed")], 
                      each = n_per_cup.2), 
                  size = n_per_treatment.2, replace = F)

exp_setup = data.frame("day" = rep(c(1:num_days.2), #creates data frame with sampled individuals
                                   each = 5),
                       "starved" = starve_inds,
                       "fed" = fed_inds) %>%  
  pivot_longer(cols = c("fed", "starved"), #Pivots to long format for additional manipulation
               names_to = "diet",
               values_to = "cup") %>% 
  group_by(day, diet, cup) %>% 
  count() %>% #Counts number of individuals per source cup
  ungroup() %>% 
  complete(day, cup, fill = list(n = 0)) %>% #If a cup is missing from the original sample, it's added with the value 0 (no individuals are sampled from that cup on that day)
  select(-diet, day, cup, n) %>%  
  inner_join(cup_setup, by = "cup") #Bad solution for ensuring every cup has a diet

#Checks to make sure 10 individuals are selected per day, 5 each from the two treatments
exp_setup %>%  
  group_by(day,diet) %>% 
  summarise("day_total" = sum(n))

#Checks to make sure fewer than 15 individuals are used per cup
exp_setup %>%  
  group_by(cup) %>% 
  summarise("cup_total" = sum(n))

exp_setup %>% 
  select(-diet) %>% 
  write.csv(file = "Background/setup/exp2_daily_cups.csv", row.names = F) #This file details which individuals are used for the daily heat stress

write.table(cup_setup, file = "Background/setup/exp2_setup.csv", row.names = F, sep = ",") #This file would be sent to Matt for the inital set up 

