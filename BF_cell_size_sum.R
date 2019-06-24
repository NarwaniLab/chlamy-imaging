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
BF_files[1] 

names(BF_files) <- BF_files %>% 
  gsub(pattern = ".csv$", replacement = "")

all_wells <- map_df(BF_files, read_csv, .id = "file_name") %>% 
  rename(cell_number = X1) %>% 
  separate(col = file_name, into = c("file_name", "plate"), 
           sep = "plate_19/") %>% 
  #separate(col = plate, into = c("well", "plate"), 
  #sep = c("01_1_1_BrightField_001_results_plate","01_1_2_BrightField_001_results_plate")) %>% 
  mutate(plate = str_replace(plate, "01_1_1_BrightField_001_results_plate", "x")) %>%
  mutate(plate = str_replace(plate, "01_1_2_BrightField_001_results_plate", "x")) %>% 
  separate(plate, into = c("well", "plate"),
           sep = "_x") %>% 
  mutate(plate = as.numeric(plate)) %>% 
  separate(col = well, into = c("row", "column"),
           sep = 1) %>%
  mutate(column = formatC(column, width = 2, flag = 0)) %>% 
  mutate(column = str_replace(column, " ", "0")) %>% 
  unite(col = well, row, column, sep = "")

#all_wells$plate

#all_wells$well[1] 

all_wells2 <- left_join(all_wells, plate_info, by = c("well", "plate")) %>%
  mutate(plate = as.numeric(plate)) %>% 
  filter(!is.na(plate_key)) %>% 
  left_join(., treatments) %>% 
  filter(population != "COMBO") 

all_BF <- all_wells2 %>% 
  group_by(population, phosphate_concentration, treatment, ancestor_id, well) %>%
  summarise_each(funs(sum, std.error), Area)

all_BF %>% 
  ggplot(aes(x = treatment, y = sum, color = phosphate_concentration)) + geom_point() +
  scale_color_viridis_c()   


