#!/usr/bin/env Rscript

# ==============================================
# Pfam Domain Enrichment Analysis (Fisher's Test)
# ==============================================
#
# Input: 
#   - Target list (genes/proteins with Pfam domains)
#   - Background list (full proteome or comparison set)
# Output: 
#   - Table of enriched Pfam domains (p-value, odds ratio)
#
# Usage: Rscript pfam_enrichment.R <target_file> <background_file> <output_file>
# -----------------------------------------------------------------------------

# Load required libraries
if (!require("tidyverse")) install.packages("tidyverse")
library(tidyverse)

# ========================
# Read and preprocess data
# ========================

# Read command-line arguments.
# args <- commandArgs(trailingOnly = TRUE)
# if (length(args) != 3) {
#  stop("Usage: Rscript pfam_enrichment.R <target_file> <background_file> <output_file>")
# }

target_file <- file.choose()  # Choose files I want to compare
background_file <- file.choose() 
output_file <- file.choose() # Empty file  

# Read input files (expected format: one gene/protein per line with Pfam domains in comma-separated format)
# Example:
# Gene1  PF00001,PF00002
# Gene2  PF00003
target_data <- read.table(target_file, header = FALSE, col.names = c("gene", "domains")) 
background_data <- read.table(background_file, header = FALSE, col.names = c("gene", "domains"))

# Split comma-separated domains into lists
target_data <- target_data %>%
  mutate(domains = strsplit(as.character(domains), ",")) %>%
  unnest(domains)

background_data <- background_data %>%
  mutate(domains = strsplit(as.character(domains), ",")) %>%
  unnest(domains)

# =====================
# Perform enrichment
# =====================

# Get all unique Pfam domains in background
all_domains <- unique(background_data$domains) # Keps a list of uniq domains in the background file (without repetitions)

# Initialize results dataframe
results <- data.frame(
  domain = character(),
  p_value = numeric(),
  odds_ratio = numeric(),
  target_count = integer(),
  background_count = integer(),
  stringsAsFactors = FALSE
)

# Total numbers for Fisher's test
total_target <- nrow(distinct(target_data, gene)) # This R code calculates the total number of unique genes in two datasets (target_data and background_data), which will be used as the denominator in Fisher's exact test.
total_background <- nrow(distinct(background_data, gene))

# Loop through each Pfam domain and perform Fisher's exact test
for (domain in all_domains) {
  # Count occurrences in target set
  target_with_domain <- target_data %>% # This R code is part of a loop that performs Fisher's exact test for each Pfam domain (stored in all_domains). The specific line you're asking about counts how many unique genes in the target_data contain the current domain.
    filter(domains == domain) %>%
    distinct(gene) %>%
    nrow()
  
  # Count occurrences in background set
  background_with_domain <- background_data %>%
    filter(domains == domain) %>%
    distinct(gene) %>%
    nrow()
  
  # Build contingency table
  contingency_table <- matrix(
    c(
      target_with_domain,                # a (target with domain)
      total_target - target_with_domain, # c (target without domain)
      background_with_domain,            # b (background with domain)
      total_background - background_with_domain # d (background without domain)
    ),
    nrow = 2,
    dimnames = list(
      c("With_domain", "Without_domain"),
      c("Target", "Background")
    )
  )
  
  # Skip if counts are too low
  if (sum(contingency_table[1, ]) < 2) next
  
  # Fisher's exact test
  fisher_result <- fisher.test(contingency_table)  
  
  # Store results
  results <- rbind(results, data.frame(
    domain = domain,
    p_value = fisher_result$p.value,
    odds_ratio = fisher_result$estimate, # odds ratio: Measure of effect size (how much more likely the domain appears in target vs background). Odds ratio (OR > 1 = enriched in target; OR < 1 = depleted)
    target_count = target_with_domain,
    background_count = background_with_domain
  ))
}

# Adjust p-values for multiple testing (Benjamini-Hochberg). Este es el FDR
results$adj_p_value <- p.adjust(results$p_value, method = "BH")

# Sort by significance
results <- results[order(results$adj_p_value), ]

# ==============
# Save results
# ==============
write.csv(results, output_file, row.names = FALSE)

cat(sprintf("\nResults saved to: %s\n", output_file))