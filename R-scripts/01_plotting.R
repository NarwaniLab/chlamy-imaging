### this is a script for plotting
### Hi Joey, it's Lenka!


library(tidyverse)
library(readxl)
library(janitor)



plate_layout <- read_excel("data-raw/chlamee-acclimated-plate-layout.xlsx") 
plate_info <- read_csv("data-raw/chlamee-phosphate-rstar-plate-info.csv")

cell_files <- c(list.files("data-raw/phosphate-fluo-results", full.names = TRUE))
cell_files <- cell_files[grepl(".csv", cell_files)]

names(cell_files) <- cell_files %>% 
  gsub(pattern = ".csv$", replacement = "") %>% 
  gsub(pattern = ".csv$", replacement = "")


all_fl <- map_df(cell_files, read_csv, .id = "file_name") 


all_fl$file_name[[1]]


all_fl2 <- all_fl[400:500,]

  all_fl3 <- all_fl %>% 
separate(col = file_name, into = c("file_path", "well"),
           sep = c("data-raw/phosphate-fluo-results/")) %>% 
  separate(col = well, into = c("well_id", "other"), sep = "_", remove = FALSE) %>% 
  separate(well_id, into = c("letter", "number"), sep = 1, remove = FALSE) %>% 
  mutate(number = as.numeric(number)) %>% 
  mutate(number = formatC(number, width = 2, flag = 0)) %>% 
  unite(col = well, letter, number, sep = "") %>% 
  separate(Label, into = c("stuff","plate"), sep = "phosphate_") %>% 
  mutate(plate = str_replace(plate, ".tif", "")) %>% 
  mutate(plate = str_replace(plate, "plate", "")) %>% 
  mutate(plate = as.numeric(plate)) %>% 
  mutate(well_plate = paste(well, plate, sep = "_")) %>% 
    group_by(well, plate, well_plate) %>% 
    mutate(cell_count = as.numeric(`X1`)) %>% 
    summarise_each(funs(mean, max, min), cell_count, Area, Mean)


all_fl4 <- left_join(all_fl3, plate_info, by = c("well", "plate")) %>% 
  mutate(population = ifelse(population == "cc1629", "COMBO", population)) %>% 
  select(population, phosphate_concentration, well, plate, well_plate, cell_count_max, Area_mean, Area_max, Mean_mean) %>% 
  filter(!is.na(population)) %>% 
  filter(population != "COMBO")

