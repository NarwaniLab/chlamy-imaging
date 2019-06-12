library (tidyverse)
library (readxl)
library (cowplot)
library (plotrix)
library (janitor)

BF_files <- c(list.files("data-raw/results_BF_phosphate_plate_10", full.names = TRUE))
BF_files <- BF_files[grepl(".csv", BF_files)]

four_wells <- map_df(BF_files, read_csv, .id = "file_name") %>% 
  rename(cell_number = X1) %>% 
  mutate(file_name = str_replace(file_name, " ", "")) %>% 
  separate(col = file_name, into = c("file_name", "plate"), 
           sep = c("phosphate_"))

four_wells %>% 
  ggplot(aes(x = Area, y = cell_number, color = file_name)) + geom_point() +
  scale_color_viridis_c()   


