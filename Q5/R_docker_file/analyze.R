#!/usr/bin/env Rscript

# analyze.R
# ------------------------------------------------------------------------------
# Reads a CSV with columns like:
#   Date collected, Species, Sex, Weight
# Performs analyses:
#   1) Group by Species & calculate Mean Weight
#   2) Calculate total weight by Species
#   3) Sorting the data by Weight
#   4) Count the number of records per Species
#   5) Count Males & Females
#   6) Filter data by species
#   7) Plot a Weight distribution by Sex
#
# Writes text results to R_outputs_5.txt. Saves a plot to distribution.png.

# We’ll assume the CSV filename is passed as first argument
args <- commandArgs(trailingOnly=TRUE)
if (length(args) < 1) {
  stop("[ERROR] No CSV file path provided!")
}
csv_file <- args[1]

out_file <- "R_outputs_5.txt"

# Load libraries
install.packages("dplyr", repos = "http://cran.us.r-project.org") # For data manipulation
install.packages("ggplot2", repos = "http://cran.us.r-project.org") # For plotting

library(dplyr)
library(ggplot2)

cat("[INFO] Reading CSV:", csv_file, "\n")

# 1) Read the CSV
df <- read.csv(csv_file, stringsAsFactors = FALSE)

sink(out_file, append=FALSE)  # Start writing to R_outputs_5.txt

cat("===== R Analysis Results =====\n\n")
cat("[1] Data Preview:\n")
print(head(df))
cat("\n")

cat("[2] Group by Species & Calculate Mean Weight:\n")
grouped_mean <- df %>%
  group_by(Species) %>%
  summarize(MeanWeight = mean(Weight, na.rm=TRUE))
print(grouped_mean)
cat("\n")

cat("[3] Calculate Total Weight by Species:\n")
grouped_total <- df %>%
  group_by(Species) %>%
  summarize(TotalWeight = sum(Weight, na.rm=TRUE))
print(grouped_total)
cat("\n")

cat("[4] Sorting the data by Weight (descending):\n")
sorted_df <- df %>% arrange(desc(Weight))
print(sorted_df)
cat("\n")

cat("[5] Count the Number of Records per Species:\n")
count_species <- df %>%
  group_by(Species) %>%
  tally()
print(count_species)
cat("\n")

cat("[6] Count Males & Females:\n")
mf_count <- df %>%
  group_by(Sex) %>%
  tally()
print(mf_count)
cat("\n")

cat("[7] Filter Data by Species (example: 'OT'):\n")
filtered_ot <- df %>% filter(Species == "OT")
print(filtered_ot)
cat("\n")

sink()  # Stop writing to R_outputs_5.txt

cat("[INFO] Generating Weight Distribution Plot by Sex...\n")
# 8) Plot weight distribution by Sex
ggplot(df, aes(x=Sex, y=Weight, fill=Sex)) +
  geom_boxplot() +
  theme_minimal() +
  ggtitle("Weight Distribution by Sex")

cat("[INFO] Analysis complete. See 'R_outputs_5.txt' and 'distribution.png'.\n")
