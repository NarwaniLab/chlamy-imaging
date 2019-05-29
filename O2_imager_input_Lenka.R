library (tidyverse)
library (readxl)
library (cowplot)

RFU_files <- c(list.files("data-raw/imager-outputs", full.names = TRUE))
RFU_files <- RFU_files[grepl(".xls", RFU_files)]

names(RFU_files) <- RFU_files %>% 
  gsub(pattern = ".xlsx$", replacement = "") %>% 
  gsub(pattern = ".xls$", replacement = "")

# RFU_files[grepl("104", RFU_files)]

# RFU_files <- RFU_files[!grepl("acc", RFU_files)]

all_plates <- map_df(RFU_files, read_excel, range = "B56:N64", .id = "file_name") %>%
  rename(row = X__1) %>% 
  filter(!grepl("dilution", file_name)) %>% 
  mutate(file_name = str_replace(file_name, " ", ""))