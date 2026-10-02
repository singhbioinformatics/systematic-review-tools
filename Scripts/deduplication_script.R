Code for Duplication removal-


# =====================================================
# FINAL SYSTEMATIC REVIEW DEDUPLICATION SCRIPT
# REMOVE ALL REPETITION BASED ON TITLE
# =====================================================

# Install once
install.packages(c("readxl","dplyr","stringr","writexl"))

library(readxl)
library(dplyr)
library(stringr)
library(writexl)

# ---------------------------
# STEP 1: READ ALL 6 FILES
# ---------------------------

file1 <- read_excel()
file2 <- read_excel()
file3 <- read_excel()
file4 <- read_excel()
file5 <- read_excel()
file6 <- read_excel()
# ---------------------------
# STEP 2: CONVERT ALL COLUMNS TO CHARACTER
# (avoid type conflict errors)
# ---------------------------

file1 <- file1 %>% mutate(across(everything(), as.character))
file2 <- file2 %>% mutate(across(everything(), as.character))
file3 <- file3 %>% mutate(across(everything(), as.character))
file4 <- file4 %>% mutate(across(everything(), as.character))
file5 <- file5 %>% mutate(across(everything(), as.character))
file6 <- file6 %>% mutate(across(everything(), as.character))

# ---------------------------
# STEP 3: MERGE ALL FILES
# ---------------------------

all_data <- bind_rows(file1, file2, file3, file4, file5, file6)

cat("Total records BEFORE deduplication:", nrow(all_data), "\n")

# ---------------------------
# STEP 4: CLEAN TITLE
# (for accurate duplicate detection)
# ---------------------------

all_data$Title_clean <- all_data$Title %>%
  tolower() %>%                    # lowercase
  str_replace_all("[[:punct:]]","") %>%   # remove punctuation
  str_squish()                     # remove extra spaces

# ---------------------------
# STEP 5: REMOVE DUPLICATES
# ---------------------------

final_clean <- all_data[!duplicated(all_data$Title_clean), ]

cat("Total records AFTER deduplication:", nrow(final_clean), "\n")
cat("Total repetitions removed:",
    nrow(all_data) - nrow(final_clean), "\n")

# ---------------------------
# STEP 6: REMOVE HELPER COLUMN
# ---------------------------

final_clean <- final_clean %>% select(-Title_clean)

# ---------------------------
# STEP 7: EXPORT FINAL FILE
# ---------------------------

write_xlsx(final_clean, "Final_No_Repetition_File.xlsx")

cat("Final clean file created successfully.\n")
cat("File saved in your working directory.\n")

