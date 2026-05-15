# =============================================================================
# **Authos of scripts and maintainers of the repository**: Alexandra Rottenkolber, Ola Ali, Gergely Mónus, Jiaxuan Li

# **Date of the last update**: 2026-05-06

# **Open Science Framework permanent repository**: [https://doi.org/10.17605/OSF.IO/EVDHU](https://doi.org/10.17605/OSF.IO/EVDHU)

# **GitHub repository**: [https://github.com/OlaAM/Scholarly_Migration](https://github.com/OlaAM/Scholarly_Migration)

# HOW TO RUN THIS SCRIPT
# -----------------------------------------------------------------------------
# 1. Install required packages by running:
#    install.packages(c("tidyverse", "cowplot", "ggpubr", "readxl", "patchwork"))
#
# 2. Set your working directory to the ROOT of this repository, e.g.:
#    setwd("/path/to/scholarly-mobility-replication")
#
# 3. Run the full script (Source, not line-by-line):
#    source("Code/plot_figures.R")
#
# 4. Output figures will be saved to the Outputs/ folder.
# =============================================================================

library(tidyverse)
library(cowplot)
library(ggpubr)
library(readxl)
library(patchwork)

options(scipen = 999)

# Relative paths — works for anyone who sets working directory to repo root
base_path   <- "./Inputs"
output_path <- "./Outputs"

dir.create(output_path, showWarnings = FALSE, recursive = TRUE)

# Helper to build full file paths
f <- function(filename) file.path(base_path, filename)


# =============================================================================
# FIGURE SI-1: Decision Tree feature importance
# =============================================================================

tree_data <- read_csv(f("importance.csv"))

tree_data <- tree_data %>%
  mutate(Feature = case_when(
    Feature == "Move Type"             ~ "International Move",
    Feature == "Current Inst Ranking"  ~ "Ranking of Receiving Institution",
    Feature == "Previous Inst Ranking" ~ "Ranking of Source Institution",
    Feature == "Current Continent"     ~ "Continent of Receiving Institution",
    Feature == "Previous Continent"    ~ "Continent of Source Institution",
    TRUE ~ Feature
  ))

tree_data <- tree_data[order(tree_data$Importance), ]

better_names <- c("Gender", "Cohort", "Career age", "Cumulative number\nof published articles",
                  "Year of Move", "Academic field of focal author", "Continent of source institution",
                  "Continent of target institution", "Ranking of source instiutuion",
                  "Ranking of target institution", "International move",
                  "Number of first- and\nsecond-order coauthors")
tree_data$better_names <- better_names

tree_plot <- ggplot(tree_data, aes(x = reorder(better_names, Importance), y = Importance)) +
  geom_bar(stat = "identity", fill = "gray") +
  coord_flip() +
  labs(x = "Feature", y = "Importance score") +
  theme_pubclean() +
  theme(axis.title.y = element_blank())

tree_plot


# =============================================================================
# FIGURES 2A & 2B: MLR — network size and move type
# =============================================================================

MLR_data2 <- read_xlsx(f("multinom_direction_FINAL_results.xlsx"), sheet = "Q2Q3_ranking")

# --- Figure 2A: Network size ---
MLR1 <- MLR_data2[1:3, c(1:5, 10:13)]

MLR1_prob_long <- MLR1 %>%
  pivot_longer(cols = starts_with("prob."), names_to = "category", values_to = "prob")

MLR1_se_long <- MLR1 %>%
  pivot_longer(cols = starts_with("se.prob."), names_to = "category", values_to = "se") %>%
  mutate(category = gsub("^se\\.", "", category))

MLR1_long <- left_join(MLR1_prob_long, MLR1_se_long, by = c("category", "connectedness_cat_cocoauth")) %>%
  select(connectedness_cat_cocoauth, prob, se, category) %>%
  mutate(prob = as.numeric(prob), se = as.numeric(se))

MLR1_plot_size <- ggplot(MLR1_long, aes(x = connectedness_cat_cocoauth, y = prob, color = category, group = category)) +
  geom_errorbar(aes(ymin = prob - se, ymax = prob + se), width = 0.1, size = 0.8) +
  geom_line(linewidth = 0.4, linetype = "dashed") +
  geom_point(size = 2) +
  scale_y_continuous(labels = scales::number_format(accuracy = 0.1)) +
  scale_x_discrete(labels = c("Low", "Medium", "High")) +
  labs(x = "Size of a scholar's network", y = "Predicted probability\nof moving", color = NULL) +
  scale_color_manual(
    values = c("steelblue", "orange", "Yellow green", "Firebrick"),
    labels = c("Neither connection", "Both connections", "Individual connections", "Institutional connections")
  ) +
  theme_pubclean() +
  theme(legend.key.height = unit(0.045, "npc"), legend.title = element_blank(),
        plot.title = element_blank(), legend.position = "bottom") +
  ylim(0, NA) +
  guides(color = guide_legend(nrow = 4))

MLR1_plot_size

# --- Figure 2B: Move type ---
MLR_move <- MLR_data2[11:13, c(1:5, 10:13)]
colnames(MLR_move) <- MLR_move[1, ]
MLR_move <- MLR_move[2:3, ]

MLR_move_prob_long <- MLR_move %>%
  pivot_longer(cols = starts_with("prob."), names_to = "category", values_to = "prob")

MLR_move_se_long <- MLR_move %>%
  pivot_longer(cols = starts_with("se.prob."), names_to = "category", values_to = "se") %>%
  mutate(category = gsub("^se\\.", "", category))

MLR_move_long <- left_join(MLR_move_prob_long, MLR_move_se_long, by = c("category", "move_type")) %>%
  select(move_type, prob, se, category) %>%
  mutate(prob = as.numeric(prob), se = as.numeric(se))

MLR_move_long$move_type <- factor(MLR_move_long$move_type, levels = levels(fct_rev(MLR_move_long$move_type)))

unique(MLR_move_long$category)
unique(MLR_move_long$move_type)
MLR_move_long <- MLR_move_long %>%
  mutate(x_adj = case_when(
    move_type == "international move" & category == "prob.both" ~ 2.05,
    move_type == "international move" & category == "prob.institutional_direction" ~ 1.95,
    move_type == "international move" ~ 2,
    move_type == "national move" ~ 1
  ))

MLR_move_plot <- ggplot(MLR_move_long, aes(x = x_adj, y = prob, ymin = prob - se, ymax = prob + se, color = category, group = category)) +
  geom_point(size = 3) + 
  scale_x_continuous(
    breaks = c(1, 2),
    labels = c("national move", "international move"),
    limits = c(0.5, 2.5)
  ) +
  labs(
    x = "Type of mobility event",  # Set x-axis title
    y = "Predicted probability\nof moving",  # Set y-axis title
    color = NULL  # Remove legend title
  ) +
  scale_color_manual(
    values = c("steelblue", "orange", "Yellow green", "Firebrick"),
    labels = c("Neither connection", "Both connections", "Individual connections", "Institutional connections")  # Rename legend labels
  ) +
  theme_pubclean() +
  theme(
    legend.key.height = unit(0.045, "npc"), 
    legend.title = element_blank(),  # Remove legend title
    plot.title = element_blank(),  # Remove plot title
    legend.position = "bottom",  # Move legend to the bottom
  ) +
  ylim(0, 0.6) +
  guides(color = guide_legend(nrow = 4))

MLR_move_plot


# =============================================================================
# FIGURE 2C: DCM — percentiles plot
# =============================================================================

dcm_data_percentiles <- read_csv(f("prediction_df_percentiles_plot_df.csv")) %>%
  filter(type != "neither")

dcmlabel1 <- expression(atop("" * S[Fj]^{ind[2]} * " varying, ", S[ij]^{inst[2]} * "at mean"))
dcmlabel2 <- expression(atop("" * S[Fj]^{ind[2]} * " varying, ", S[ij]^{inst[2]} * "at zero"))
dcmlabel3 <- expression(atop("" * S[ij]^{inst[2]} * " varying, ", S[Fj]^{ind[2]} * "at mean"))
dcmlabel4 <- expression(atop("" * S[ij]^{inst[2]} * " varying, ", S[Fj]^{ind[2]} * "at zero"))

dcm_plot2 <- ggplot(dcm_data_percentiles, aes(x = percentile, y = predictions, color = type, group = type)) +
  geom_line(size = 0.8) +
  scale_x_continuous(name = "Percentiles of connection strength", breaks = scales::pretty_breaks(n = 4)) +
  labs(y = "Predicted relative probability\nof choosing the target institution", color = NULL, fill = NULL) +
  scale_color_manual(
    values = c("Fire brick", "Yellow green", "orange", "steelblue"),
    labels = c(dcmlabel1, dcmlabel2, dcmlabel3, dcmlabel4)
  ) +
  scale_fill_manual(
    values = c("Fire brick", "Yellow green", "orange", "steelblue"),
    labels = c(dcmlabel1, dcmlabel2, dcmlabel3, dcmlabel4)
  ) +
  theme_pubclean() +
  theme(legend.key.height = unit(0.09, "npc"), legend.title = element_blank(),
        plot.title = element_blank(), legend.position = "bottom") +
  guides(color = guide_legend(ncol = 2), fill = guide_legend(ncol = 2, byrow = TRUE))

dcm_plot2


# =============================================================================
# FIGURE 3 A.1 & A.2: MLR — prestige source and target
# =============================================================================

# Target prestige (A.2)
MLR_prestige_target     <- read_csv(f("effect_statistics.csv"))
MLR_prestige_target_old <- MLR_data2[31:35, c(1:5, 10:13)]
colnames(MLR_prestige_target_old)[colnames(MLR_prestige_target_old) == "connectedness_cat_cocoauth"] <- "ln_current_ranking"

MLR_prestige_target$ln_current_ranking <- c(-3, 0.7, 3, 7, 10)
MLR_prestige_target$prob.A_neither     <- as.numeric(MLR_prestige_target_old$prob.A_neither)
MLR_prestige_target$se.prob.A_neither  <- as.numeric(MLR_prestige_target_old$se.prob.A_neither)

pres_long_target <- left_join(
  MLR_prestige_target %>% pivot_longer(cols = starts_with("prob."), names_to = "category", values_to = "prob"),
  MLR_prestige_target %>% pivot_longer(cols = starts_with("se.prob."), names_to = "category", values_to = "se") %>%
    mutate(category = gsub("^se\\.", "", category)),
  by = c("category", "ln_current_ranking")
) %>%
  select(ln_current_ranking, prob, se, category) %>%
  mutate(prob = as.numeric(prob), se = as.numeric(se),
         ln_current_ranking = as.numeric(ln_current_ranking))

pres_plot_target <- ggplot(pres_long_target, aes(x = ln_current_ranking, y = prob, color = category, group = category)) +
  geom_ribbon(aes(ymin = prob - se, ymax = prob + se, fill = category), alpha = 0.2) +
  geom_line(size = 0.8) +
  scale_x_continuous(name = "Logarithm of the\ntarget institution's ranking", breaks = scales::pretty_breaks(n = 5)) +
  labs(y = "Predicted probability\nof moving", color = NULL, fill = NULL) +
  scale_color_manual(values = c("steelblue", "orange", "Yellow green", "Firebrick"),
                     labels = c("Neither connection", "Both connections", "Individual connections", "Institutional connections")) +
  scale_fill_manual(values = c("steelblue", "orange", "Yellow green", "Firebrick"),
                    labels = c("Neither connection", "Both connections", "Individual connections", "Institutional connections")) +
  theme_pubclean() +
  theme(legend.title = element_blank(), plot.title = element_blank(), legend.position = "bottom") +
  guides(color = guide_legend(nrow = 2), fill = guide_legend(nrow = 2))

pres_plot_target

# Source prestige (A.1)
MLR_prestige_source <- MLR_data2[39:43, c(1:5, 10:13)]
colnames(MLR_prestige_source)[colnames(MLR_prestige_source) == "connectedness_cat_cocoauth"] <- "ln_previous_ranking"

pres_long_source <- left_join(
  MLR_prestige_source %>% pivot_longer(cols = starts_with("prob."), names_to = "category", values_to = "prob"),
  MLR_prestige_source %>% pivot_longer(cols = starts_with("se.prob."), names_to = "category", values_to = "se") %>%
    mutate(category = gsub("^se\\.", "", category)),
  by = c("category", "ln_previous_ranking")
) %>%
  select(ln_previous_ranking, prob, se, category) %>%
  mutate(prob = as.numeric(prob), se = as.numeric(se),
         ln_previous_ranking = as.numeric(ln_previous_ranking))

pres_plot_source <- ggplot(pres_long_source, aes(x = ln_previous_ranking, y = prob, color = category, group = category)) +
  geom_ribbon(aes(ymin = prob - se, ymax = prob + se, fill = category), alpha = 0.2) +
  geom_line(size = 0.8) +
  scale_y_continuous(labels = scales::number_format(accuracy = 0.1)) +
  scale_x_continuous(name = "Logarithm of the\nsource institution's ranking", breaks = scales::pretty_breaks(n = 5)) +
  labs(y = "Predicted probability\nof moving", color = NULL, fill = NULL) +
  scale_color_manual(values = c("steelblue", "orange", "Yellow green", "Firebrick"),
                     labels = c("Neither connection", "Both connections", "Individual connections", "Institutional connections")) +
  scale_fill_manual(values = c("steelblue", "orange", "Yellow green", "Firebrick"),
                    labels = c("Neither connection", "Both connections", "Individual connections", "Institutional connections")) +
  theme_pubclean() +
  theme(legend.title = element_blank(), plot.title = element_blank(), legend.position = "bottom") +
  guides(color = guide_legend(nrow = 1), fill = guide_legend(nrow = 1)) +
  ylim(0, 1)

pres_plot_source


# =============================================================================
# FIGURE 3 B.1, B.2, C.1, C.2: DCM — prestige x connection strength interaction
# =============================================================================

df_prestige_strength_interaction <- read_csv(f("prediction_df_stength_prestige_interaction.csv"))

SIZE_P       <- 12
legend_HEIGHT <- 0.03
FACE <- NULL
SIZE <- 14
JUST <- "center"

# Individual connection strength — source prestige (B.1)
pltInd_source2 <- ggplot(df_prestige_strength_interaction, aes(x = strength, y = predictions)) +
  geom_smooth(data = filter(df_prestige_strength_interaction, type == "varying Q2, Q3 at mean, source prestige low"),
              aes(group = type, colour = type), method = "gam", se = FALSE) +
  geom_smooth(data = filter(df_prestige_strength_interaction, type == "varying Q2, Q3 at mean, source prestige medium"),
              aes(group = type, colour = type), method = "gam", se = FALSE) +
  geom_smooth(data = filter(df_prestige_strength_interaction, type == "varying Q2, Q3 at mean, source prestige high"),
              aes(group = type, colour = type), method = "gam", se = FALSE) +
  scale_color_manual("Prestige level",
                     values = c("varying Q2, Q3 at mean, source prestige low"    = "lightblue",
                                "varying Q2, Q3 at mean, source prestige medium" = "steelblue",
                                "varying Q2, Q3 at mean, source prestige high"   = "darkblue"),
                     labels = c("varying Q2, Q3 at mean, source prestige low"    = "low",
                                "varying Q2, Q3 at mean, source prestige medium" = "medium",
                                "varying Q2, Q3 at mean, source prestige high"   = "high"),
                     breaks = c("varying Q2, Q3 at mean, source prestige high",
                                "varying Q2, Q3 at mean, source prestige medium",
                                "varying Q2, Q3 at mean, source prestige low")) +
  ylab("Marginal relative\npredicted probability") +
  xlab(expression("Indivdiual connection strength (" * S[Fj]^{ind[2]} * ")")) +
  xlim(0, 1) + ylim(0, 0.011) +
  theme_pubclean() +
  theme(axis.title = element_text(size = SIZE_P), legend.key.height = unit(legend_HEIGHT, "npc"))

# Individual connection strength — target prestige (B.2)
pltInd_target2 <- ggplot(df_prestige_strength_interaction, aes(x = strength, y = predictions)) +
  geom_smooth(data = filter(df_prestige_strength_interaction, type == "varying Q2, Q3 at mean, target prestige low"),
              aes(group = type, colour = type), method = "gam", se = FALSE) +
  geom_smooth(data = filter(df_prestige_strength_interaction, type == "varying Q2, Q3 at mean, target prestige medium"),
              aes(group = type, colour = type), method = "gam", se = FALSE) +
  geom_smooth(data = filter(df_prestige_strength_interaction, type == "varying Q2, Q3 at mean, target prestige high"),
              aes(group = type, colour = type), method = "gam", se = FALSE) +
  scale_color_manual("Prestige level",
                     values = c("varying Q2, Q3 at mean, target prestige low"    = "lightblue",
                                "varying Q2, Q3 at mean, target prestige medium" = "steelblue",
                                "varying Q2, Q3 at mean, target prestige high"   = "darkblue"),
                     labels = c("varying Q2, Q3 at mean, target prestige low"    = "low",
                                "varying Q2, Q3 at mean, target prestige medium" = "medium",
                                "varying Q2, Q3 at mean, target prestige high"   = "high"),
                     breaks = c("varying Q2, Q3 at mean, target prestige high",
                                "varying Q2, Q3 at mean, target prestige medium",
                                "varying Q2, Q3 at mean, target prestige low")) +
  ylab("Marginal relative\npredicted probability") +
  xlab(expression("Indivdiual connection strength (" * S[Fj]^{ind[2]} * ")")) +
  xlim(0, 1) + ylim(0, 0.011) +
  theme_pubclean() +
  theme(axis.title = element_text(size = SIZE_P), legend.key.height = unit(legend_HEIGHT, "npc")) +
  guides(size = guide_legend(title.position = "top"),
         color = guide_legend(nrow = 3), fill = guide_legend(nrow = 3))

# Institutional connection strength — source prestige (C.1)
pltInst_source2 <- ggplot(df_prestige_strength_interaction, aes(x = strength, y = predictions)) +
  geom_smooth(data = filter(df_prestige_strength_interaction, type == "varying Q3, Q2 at mean, source prestige low"),
              aes(group = type, colour = type), method = "gam", se = FALSE) +
  geom_smooth(data = filter(df_prestige_strength_interaction, type == "varying Q3, Q2 at mean, source prestige medium"),
              aes(group = type, colour = type), method = "gam", se = FALSE) +
  geom_smooth(data = filter(df_prestige_strength_interaction, type == "varying Q3, Q2 at mean, source prestige high"),
              aes(group = type, colour = type), method = "gam", se = FALSE) +
  scale_color_manual("Prestige level",
                     values = c("varying Q3, Q2 at mean, source prestige low"    = "lightblue",
                                "varying Q3, Q2 at mean, source prestige medium" = "steelblue",
                                "varying Q3, Q2 at mean, source prestige high"   = "darkblue"),
                     labels = c("varying Q3, Q2 at mean, source prestige low"    = "low",
                                "varying Q3, Q2 at mean, source prestige medium" = "medium",
                                "varying Q3, Q2 at mean, source prestige high"   = "high"),
                     breaks = c("varying Q3, Q2 at mean, source prestige high",
                                "varying Q3, Q2 at mean, source prestige medium",
                                "varying Q3, Q2 at mean, source prestige low")) +
  ylab(" ") +
  xlab(expression("Institutional connection strength (" * S[ij]^{inst[DCM]} * ")")) +
  xlim(0, 1) + ylim(0, 0.011) +
  theme_pubclean() +
  theme(axis.title = element_text(size = SIZE_P), legend.key.height = unit(legend_HEIGHT, "npc"))

# Institutional connection strength — target prestige (C.2)
pltInst_target2 <- ggplot(df_prestige_strength_interaction, aes(x = strength, y = predictions)) +
  geom_smooth(data = filter(df_prestige_strength_interaction, type == "varying Q3, Q2 at mean, target prestige low"),
              aes(group = type, colour = type), method = "gam", se = FALSE) +
  geom_smooth(data = filter(df_prestige_strength_interaction, type == "varying Q3, Q2 at mean, target prestige medium"),
              aes(group = type, colour = type), method = "gam", se = FALSE) +
  geom_smooth(data = filter(df_prestige_strength_interaction, type == "varying Q3, Q2 at mean, target prestige high"),
              aes(group = type, colour = type), method = "gam", se = FALSE) +
  scale_color_manual("Prestige level",
                     values = c("varying Q3, Q2 at mean, target prestige low"    = "lightblue",
                                "varying Q3, Q2 at mean, target prestige medium" = "steelblue",
                                "varying Q3, Q2 at mean, target prestige high"   = "darkblue"),
                     labels = c("varying Q3, Q2 at mean, target prestige low"    = "low",
                                "varying Q3, Q2 at mean, target prestige medium" = "medium",
                                "varying Q3, Q2 at mean, target prestige high"   = "high"),
                     breaks = c("varying Q3, Q2 at mean, target prestige high",
                                "varying Q3, Q2 at mean, target prestige medium",
                                "varying Q3, Q2 at mean, target prestige low")) +
  ylab(" ") +
  xlab(expression("Institutional connection strength (" * S[ij]^{inst[DCM]} * ")")) +
  xlim(0, 1) + ylim(0, 0.011) +
  theme_pubclean() +
  theme(axis.title = element_text(size = SIZE_P), legend.key.height = unit(legend_HEIGHT, "npc")) +
  guides(size = guide_legend(title.position = "top"),
         color = guide_legend(nrow = 3), fill = guide_legend(nrow = 3))


# =============================================================================
# ASSEMBLE FINAL FIGURES
# =============================================================================

# --- Figure 2 (panels A, B, C) ---
plt_comb_1.2_sub <- ggarrange(MLR1_plot_size, MLR_move_plot,
                              labels = c("A", "B"), ncol = 2, nrow = 1,
                              common.legend = TRUE, legend = "bottom")

figure2 <- ggarrange(plt_comb_1.2_sub, dcm_plot2,
                     labels = c("", "C"), ncol = 2, nrow = 1,
                     widths = c(0.66, 0.33))
figure2

# --- Figure 3 (panels A.1, A.2, B.1, B.2, C.1, C.2) ---
figure3 <- ggarrange(
  text_grob(" ", face = FACE, size = SIZE),
  text_grob(" ", face = FACE, size = SIZE),
  ggarrange(pres_plot_source, pltInd_source2, pltInst_source2,
            labels = c("A.1", "B.1", "C.1"), ncol = 3, nrow = 1,
            common.legend = TRUE, legend = "none"),
  text_grob(" ", face = FACE, size = SIZE),
  text_grob(" ", face = FACE, size = SIZE),
  ggarrange(pres_plot_target,
            ggarrange(pltInd_target2, pltInst_target2,
                      labels = c("B.2", "C.2"), ncol = 2, nrow = 1,
                      common.legend = TRUE, legend = "bottom"),
            labels = c("A.2", " "), widths = c(1, 2)),
  nrow = 6,
  heights = c(0.05, 0.1, 1, 0.05, 0.1, 1.3)) +
  annotation_custom(grid::grobTree(grid::textGrob("On prestige of the source institution",
                                                  gp = grid::gpar(fontface = "bold", fontsize = 14), x = 0, y = 0.96, hjust = 0))) +
  annotation_custom(grid::grobTree(grid::textGrob("On prestige of the target institution",
                                                  gp = grid::gpar(fontface = "bold", fontsize = 14), x = 0, y = 0.52, hjust = 0)))
figure3

# --- Figure SI-1 ---
tree_plot

# =============================================================================
# SAVE FIGURES
# =============================================================================

ggsave(file.path(output_path, "figure2.png"),  figure2,    width = 10, height = 5,  dpi = 300)
ggsave(file.path(output_path, "figure3.png"),  figure3,    width = 11, height = 8,  dpi = 300)
ggsave(file.path(output_path, "figure_SI1.png"), tree_plot, width = 8,  height = 5,  dpi = 300)

message("All figures saved to: ", output_path)
