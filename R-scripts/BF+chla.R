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

BF_files <- c(list.files("data-raw/results_BF_ph_plate_28", full.names = TRUE))
BF_files <- BF_files[grepl(".csv", BF_files)] 

names(BF_files) <- BF_files %>% 
  gsub(pattern = ".csv$", replacement = "")


# BF

BF_wells <- map_df(BF_files, read_csv, .id = "file_name") %>% 
  rename(cell_number = X1) %>%
  separate(col = file_name, into = c("file_name", "plate"), 
           sep = "plate_28/") %>%
  #separate(col = plate, into = c("well", "plate"), 
  #sep = c("01_1_1_BrightField_001_results_plate","01_1_2_BrightField_001_results_plate")) %>% 
  mutate(plate = str_replace(plate, "01_1_1_BrightField_001_results_plate_", "x")) %>%
  mutate(plate = str_replace(plate, "01_1_2_BrightField_001_results_plate_", "x")) %>%
  separate(plate, into = c("well", "plate"),
           sep = "_x") %>%
  mutate(plate = as.numeric(plate)) %>% 
  separate(col = well, into = c("row", "column"),
           sep = 1) %>%
  mutate(column = formatC(column, width = 2, flag = 0)) %>% 
  mutate(column = str_replace(column, " ", "0")) %>% 
  unite(col = well, row, column, sep = "") %>%
  rename(BF_cell_size = Area)

BF_wells2 <- left_join(BF_wells, plate_info, by = c("well", "plate")) %>%
  mutate(plate = as.numeric(plate)) %>% 
  filter(!is.na(plate_key)) %>% 
  left_join(., treatments) %>% 
  filter(population != "COMBO")

all_BF <- BF_wells2 %>% 
  group_by(population, phosphate_concentration, treatment, ancestor_id, well, plate) %>%
  summarise_each(funs(mean, std.error), BF_cell_size) %>% 
  rename (BF_cell_size = mean)

all_BF %>% 
  ggplot(aes(x = treatment, y = BF_cell_size, color = phosphate_concentration)) + geom_point() +
  scale_color_viridis_c() + labs(y = "BF cell size")


# Fluo


fluo_files <- c(list.files("data-raw/results_chla_ph_plate_28", full.names = TRUE))
fluo_files <- fluo_files[grepl(".csv", fluo_files)] 

names(fluo_files) <- fluo_files %>% 
  gsub(pattern = ".csv$", replacement = "")

fluo_wells <- map_df(fluo_files, read_csv, .id = "file_name") %>% 
  rename(cell_number = X1) %>% 
  separate(col = file_name, into = c("file_name", "plate"), 
           sep = "plate_28/") %>% 
  #separate(col = plate, into = c("well", "plate"), 
  #sep = c("01_1_1_BrightField_001_results_plate","01_1_2_BrightField_001_results_plate")) %>% 
  mutate(plate = str_replace(plate, "01_1_1_Chlorophyll_001_results_plate_", "x")) %>%
  mutate(plate = str_replace(plate, "01_1_2_Chlorophyll_001_results_plate_", "x")) %>% 
  separate(plate, into = c("well", "plate"),
           sep = "_x") %>%
  mutate(plate = as.numeric(plate)) %>% 
  separate(col = well, into = c("row", "column"),
           sep = 1) %>%
  mutate(column = formatC(column, width = 2, flag = 0)) %>% 
  mutate(column = str_replace(column, " ", "0")) %>% 
  unite(col = well, row, column, sep = "") %>% 
  filter(well == "F08")

fluo_wells2 <- left_join(fluo_wells, plate_info, by = c("well", "plate")) %>%
  mutate(plate = as.numeric(plate)) %>% 
  filter(!is.na(plate_key)) %>% 
  left_join(., treatments) %>% 
  filter(population != "COMBO")  %>% 
  separate(Label, into = c("photo_nbr", "rest"),
           sep = "_Chlorophyll") %>%
  separate(photo_nbr, into = c("rest2", "number"),
           sep = -1)

all_fluo <- fluo_wells2 %>% 
  rename(fluo_cell_size = Area) %>% View
  group_by(population, phosphate_concentration, treatment, ancestor_id, well, plate, number) %>%
  summarise_each(funs(mean, std.error), fluo_cell_size) %>% 
  rename (fluo_cell_size = mean)

all_fluo %>% 
  ggplot(aes(x = treatment, y = fluo_cell_size, color = phosphate_concentration)) + geom_point() +
  scale_color_viridis_c() + labs(y = "fluo cell size")

fluo_BF <- left_join(all_fluo, all_BF, by = c("well"))

#fluo_BF %>% 
  #ggplot(aes(x = treatment, y = fluo_cell_size + BF_cell_size, color = phosphate_concentration)) + geom_point() +
  #scale_color_viridis_c()
fluo_BF %>% 
  ggplot(aes(x = fluo_cell_size, y = BF_cell_size)) + geom_point() + 
  geom_abline(yintercept = 0, slope = 1) 
#+ xlim(30, 45) + ylim(30, 45)

