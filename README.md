# Replication Code and Data for paper "The role of professional networks and institutional prestige in shaping the first career moves of scholars"

**Authos of scripts and maintainers of the repository**: Alexandra Rottenkolber, Ola Ali, Gergely Mónus, Jiaxuan Li

**Date of the last update**: 2026-05-06

**Open Science Framework permanent repository**: [https://doi.org/10.17605/OSF.IO/EVDHU](https://doi.org/10.17605/OSF.IO/EVDHU)

## Publication

**Title**: The role of professional networks and institutional prestige in shaping the first career moves of scholars

**Authors**: Alexandra Rottenkolber, Ola Ali, Gergely Mónus, Jiaxuan Li, Jisu Kim, Daniela Perrotta, Aliakbar Akbaritabar

**DOI**: [https://doi.org/10.1093/pnasnexus/pgag168](https://doi.org/10.1093/pnasnexus/pgag168)

**Publication venue and date**: PNAS Nexus, 2026

**Abstract**:
Mobility of researchers is closely linked to knowledge diffusion, scientific innovation, and international collaboration. While prior research highlights the role of networks in shaping migration flows, the extent to which personal and institutional ties influence the direction of scientific mobility remains unclear. This study leverages large-scale digital trace data from Scopus, capturing the complete mobility trajectories, co-authorship networks, and collaboration histories of 172,000 authors over two decades (1996–2020). Using multinomial and conditional multinomial logit models, we examine scholars' first career move by (i) classifying moves into four network-defined mobility-type categories and (ii) modelling destination choice as a function of co-authorship connection strength, institutional linkages, and institutional prestige. Our findings show that not only first-, but also second-order co-authorship ties — connections to a scholar's collaborators' collaborators — are a strong correlate of the direction of a move. Scholars with extensive individual professional networks, particularly those migrating abroad, are more likely to move along individual ties. In contrast, scholars from prestigious institutions, and those moving within national borders, are more likely to follow institutional routes. The destination-choice models confirm that both individual and institutional ties are associated with a higher probability of moving to specific research institutions, with a larger estimated association for individual than for institutional ones. Overall, this research provides empirical evidence on how individual and institutional connections shape scholars' first career mobility. The findings have important implications for migration theory and policy, emphasising the need to support both individual and institutional collaboration networks to foster global scientific and knowledge exchange.

## How to cite

If you use the data in this repository, please cite our publication using the following APA style or BibTex information.

### APA style

```
Alexandra Rottenkolber, Ola Ali, Gergely Mónus, Jiaxuan Li, Jisu Kim, Daniela Perrotta, Aliakbar Akbaritabar, The role of professional networks and institutional prestige in shaping the first career moves of scholars, PNAS Nexus, 2026;, pgag168, https://doi.org/10.1093/pnasnexus/pgag168

```

### BibTex handle

```BibTeX
@article{10.1093/pnasnexus/pgag168,
    author = {Rottenkolber, Alexandra and Ali, Ola and Mónus, Gergely and Li, Jiaxuan and Kim, Jisu and Perrotta, Daniela and Akbaritabar, Aliakbar},
    title = {The role of professional networks and institutional prestige in shaping the first career moves of scholars},
    journal = {PNAS Nexus},
    pages = {pgag168},
    year = {2026},
    month = {05},
    abstract = {Mobility of researchers is closely linked to knowledge diffusion, scientific innovation, and international collaboration. While prior research highlights the role of networks in shaping migration flows, the extent to which personal and institutional ties influence the direction of scientific mobility remains unclear. This study leverages large-scale digital trace data from Scopus, capturing the complete mobility trajectories, co-authorship networks, and collaboration histories of 172,000 authors over two decades (1996–2020). Using multinomial and conditional multinomial logit models, we examine scholars' first career move by (i) classifying moves into four network-defined mobility-type categories and (ii) modelling destination choice as a function of co-authorship connection strength, institutional linkages, and institutional prestige. Our findings show that not only first-, but also second-order co-authorship ties — connections to a scholar's collaborators' collaborators — are a strong correlate of the direction of a move. Scholars with extensive individual professional networks, particularly those migrating abroad, are more likely to move along individual ties. In contrast, scholars from prestigious institutions, and those moving within national borders, are more likely to follow institutional routes. The destination-choice models confirm that both individual and institutional ties are associated with a higher probability of moving to specific research institutions, with a larger estimated association for individual than for institutional ones. Overall, this research provides empirical evidence on how individual and institutional connections shape scholars' first career mobility. The findings have important implications for migration theory and policy, emphasising the need to support both individual and institutional collaboration networks to foster global scientific and knowledge exchange.},
    issn = {2752-6542},
    doi = {10.1093/pnasnexus/pgag168},
    url = {https://doi.org/10.1093/pnasnexus/pgag168},
    eprint = {https://academic.oup.com/pnasnexus/advance-article-pdf/doi/10.1093/pnasnexus/pgag168/68290939/pgag168.pdf},
}

```

## Open Access Working Paper

Rottenkolber, A., Ali, O., Mónus, G., Li, J., Kim, J., Perrotta, D., Akbaritabar, A. MPIDR Working Paper WP-2025-028, 31 pages. Rostock, Max Planck Institute for Demographic Research (September 2025) [https://doi.org/10.4054/MPIDR-WP-2025-028](https://doi.org/10.4054/MPIDR-WP-2025-028)

---

# Overview of repositry and files

This repository contains the replication code and input data for Figures 2 and 3 in the main manuscript, as well as Figure S1. Figures S2 and S3 are not included because they require individual-level Scopus data, which cannot be shared.

---

## Repository Structure

```
scholarly-mobility-replication/
├── Inputs/                          # Input data files (model outputs and aggregated data)
│   ├── importance.csv               # Decision tree feature importances (Figure S1)
│   ├── multinom_direction_FINAL_results.xlsx  # MLR predicted probabilities (Figures 2A, 2B, 3A.1, 3A.2)
│   ├── effect_statistics.csv        # MLR prestige effect statistics (Figure 3A.2)
│   ├── prediction_df_percentiles_plot_df.csv  # DCM percentile predictions (Figure 2C)
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
3. Set/edit the working directory:
4. To reproduce Figures 2, 3, and S1, run:
```r
source("Code_figure2_3_S1.R")
```

6. Create a folder called "Outputs" in the working directory that will include the figures.


---

## Data Availability Note

The input files in this repository contain **aggregated model outputs**. They do not contain individual-level Scopus records. The raw Scopus data used in the analysis is not publicly available due to license restrictions. Researchers interested in accessing the raw data should contact Elsevier/Scopus directly or reach out to the corresponding author at akbaritabar@demogr.mpg.de.
