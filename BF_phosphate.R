library (tidyverse)
library (readxl)
library (cowplot)
library (plotrix)
library (janitor)

plate_layout <- read_excel("data-raw/chlamee-acclimated-plate-layout.xlsx") 
plate_info <- read_csv("data-raw/chlamee-phosphate-rstar-plate-info.csv")

treatments <- read_excel("data-general/ChlamEE_Treatments_JB.xlsx") %>% 
  clean_names() %>% 
  mutate(treatment = ifelse(is.na(treatment), "none", treatment)) 

BF_files <- c(list.files("data-raw/results_BF_ph_plate_19", full.names = TRUE))
BF_files <- BF_files[grepl(".csv", BF_files)] 

all_wells <- map_df(BF_files, read_csv, .id = "file_name") %>% 
  rename(cell_number = X1) %>% 
  separate(col = file_name, into = c("file_name", "plate"), 
           sep = c("phosphate_")) %>% 
  mutate(plate = "19") 

all_wells2 <- all_wells %>% 
  unite(cell_number, Area, col = "well", remove = FALSE, sep = "") %>% 
  
 
all_BF <- left_join(all_wells, plate_info, by = c("well", "plate")) %>%
  mutate(plate = as.numeric(plate)) %>% 
  left_join(., treatments) %>% 
  filter(population != "COMBO")

all_BF2 <- all_BF %>% 
  group_by(cell_number, Area, treatment, ancestor_id)

four_wells %>% 
  ggplot(aes(x = Area, y = cell_number, color = file_name)) + geom_point() +
  scale_color_viridis_c()   


