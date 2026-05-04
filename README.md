# Scholarly_Migration
Replication Code and Data
## "It's who you know — unless you're famous: Professional networks and prestige in scholarly mobility"

MPIDR Working Paper WP 2025-028 | September 2025  
DOI: https://doi.org/10.4054/MPIDR-WP-2025-028

---

## Overview

This repository contains the replication code and input data for the main manuscript figures ( 2 and 3)
in addition to the S1 figure, figures S2,S3 are not included as they the individual level data from Scopus which cannot be shared. 
---

## Repository Structure

```
scholarly-mobility-replication/
├── Inputs/                          # Input data files (model outputs and aggregated data)
│   ├── importance.csv               # Decision tree feature importances (Figure S1)
│   ├── multinom_direction_FINAL_results.xlsx  # MLR predicted probabilities (Figures 2A, 2B, 3A.1, 3A.2)
│   ├── effect_statistics.csv        # MLR prestige effect statistics (Figure 3A.2)
│   ├── prediction_df_percentiles_plot_df_capped.csv  # DCM percentile predictions (Figure 2C)
│   ├── prediction_df_stength_prestige_interaction.csv # DCM prestige interactions (Figures 3B.1, 3B.2, 3C.1, 3C.2)



│
├── Code/
│   ├── Code_figure2_3_S1.R
│
├── Outputs/                         # Reproduced figures
│   ├── figure2.png                  # Figure 2 (panels A, B, C)
│   ├── figure3.png                  # Figure 3 (panels A.1, A.2, B.1, B.2, C.1, C.2)
│   ├── figure_SI1.png               # Figure S1 (decision tree feature importance)
│
│
└── README.md
```

---

## How to Reproduce the Figures

### Requirements
- R (version 4.0 or higher recommended)
- The following R packages:
```r
install.packages(c("tidyverse", "cowplot", "ggpubr", "readxl", "patchwork", "arrow"))
```

### Steps

1. Clone or download this repository to your local machine
2. Open R or RStudio
3. Set your working directory to the **root** of the repository:
```r
setwd("/path/to/scholarly-mobility-replication")
```
4. To reproduce Figures 2, 3, and S1, run:
```r
source("Code/plot_figures.R")
```

6. All figures will be saved to the `Outputs/` folder


---

## Data Availability Note

The input files in this repository contain **aggregated model outputs**. They do not contain individual-level Scopus records. The raw Scopus data used in the analysis is not publicly available due to license restrictions. Researchers interested in accessing the raw data should contact Elsevier/Scopus directly or reach out to the corresponding author at akbaritabar@demogr.mpg.de.

