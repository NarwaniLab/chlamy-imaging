library(tidyverse)
library(cowplot)
library(readxl)
library(plotrix)

plate_layout <- read_excel("data-raw/chlamee-acclimated-plate-layout.xlsx") 
plate_info <- read_csv("data-raw/chlamee-phosphate-rstar-plate-info.csv")

treatments <- read_excel("data-general/ChlamEE_Treatments_JB.xlsx") %>% 
  clean_names() %>% 
  mutate(treatment = ifelse(is.na(treatment), "none", treatment))


RFU_files <- c(list.files("data-raw/imager-outputs", full.names = TRUE))
RFU_files <- RFU_files[grepl(".xls", RFU_files)]

names(RFU_files) <- RFU_files %>% 
  gsub(pattern = ".xlsx$", replacement = "") %>% 
  gsub(pattern = ".xls$", replacement = "")


all_plates <- map_df(RFU_files, read_excel, range = "B78:N86", .id = "file_name") %>%
  rename(row = ...1) %>% 
  mutate(file_name = str_replace(file_name, " ", "")) %>% 
  separate(col = file_name, into = c("file_path", "plate"),
           sep = c("phosphate_")) %>% 
  separate(col = plate, into = c("plate_new", "extra"),
           sep = c("_")) %>% 
  mutate(plate_new = str_replace(plate_new, "plate", "")) %>% 
  mutate(plate = as.numeric(plate_new)) %>% 
  select(-plate_new)


all_plates2 <- all_plates %>% 
  gather(key = column, value = RFU, 4:15) %>% 
  unite(row, column, col = "well", remove = FALSE, sep = "") %>% 
  mutate(column = formatC(column, width = 2, flag = 0)) %>% 
  mutate(column = str_replace(column, " ", "0")) %>% 
  unite(col = well, row, column, sep = "") %>% 
  filter(!is.na(RFU)) 


all_fluo <- left_join(all_plates2, plate_info, by = c("well", "plate")) %>% 
  mutate(plate = as.numeric(plate)) %>% 
  filter(!is.na(plate_key)) %>% 
  rename(fluor = RFU) %>% 
  mutate(population = ifelse(population == "cc1629", "COMBO", population)) %>% 
  left_join(., treatments) %>% 
  filter(population != "COMBO")


all_f_summ <- all_fluo %>% 
  group_by(population, phosphate_concentration, treatment, ancestor_id) %>% 
  summarise_each(funs(mean, std.error), fluor)


all_f_summ %>% 
  ggplot(aes(x = treatment, y = mean, color = phosphate_concentration)) + geom_point() +
  scale_color_viridis_c() +
  facet_wrap(~ phosphate_concentration, scales = "free")
ggsave("figures/practice-plot-fluo-Lenka.png", width = 12, height = 8)
