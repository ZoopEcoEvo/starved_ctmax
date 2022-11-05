library(tidyverse) 

lit = readxl::read_excel(path = "Data/starvation_refs.xls")

lit %>% 
  count(`Source Title`) %>% 
  mutate("Journal" = as.factor(`Source Title`)) %>% 
  arrange(desc(n)) %>% 
  select(Journal, n) %>% 
  filter(n > 1) %>% 
  mutate(Journal = fct_reorder(Journal, n)) %>% 
  ggplot(aes(x = Journal, y = n)) + 
  geom_bar(stat = "identity") + 
  scale_y_continuous(breaks = seq(from = 0, to = 10, by = 2)) + 
  theme_bw() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5), 
        panel.grid = element_blank())

lit %>% 
  ggplot(aes(x = `Publication Year`)) + 
  geom_bar() + 
  theme_bw() + 
  theme(panel.grid = element_blank())

author_counts = unlist(str_split(lit$Authors, pattern = "; ")) %>% 
  table() %>% 
  sort(decreasing = T) 

common_authors = names(author_counts[which(author_counts > 2)])

must_reads = lit %>%  
  filter(str_detect(Authors, pattern = paste(common_authors, collapse = "|")))

ggplot(must_reads, aes(x = `Publication Year`)) + 
  geom_bar() + 
  theme_bw() + 
  theme(panel.grid = element_blank())
