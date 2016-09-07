library(dplyr)
library(ggplot2)
library(INBOtheme) # install with devtools: install_github("inbo/inboTheme")
library(tidyr)
library(grid)

# gebruik een RStudio project! Dan heb je geen setwd() nodig
setwd("~/githubs/inbo_alien-species-checklist/src/grafiek_pathways")

dataset <- read.csv(
    "../../data/interim/pathway_figure_aggregate_all.tsv",
    sep = "\t"
)

# Make category capital letters
dataset <- mutate_at(dataset, .cols = c("category"), .funs = toupper)

# automatically create multiliners for x-axis,
# splitting on the first space after the center
label.splitter <- function(label, maxlength){
    label <- as.character(label)
    if (nchar(label) > maxlength) {
        # find space closest to center of string
        split.space <- nchar(label) %/% 2
        regex.statement <- paste("(^.{", split.space, "})(\\S*)([ ])", sep = "")
        label <- gsub(regex.statement, "\\1\\2\n", label)
    }
    return(label)
}
# subcategory add line splits
max.length.allowed <- 30
dataset$subcategory <- as.factor(sapply(dataset$subcategory,
                                        FUN = label.splitter,
                                        max.length.allowed))
# category add line splits
max.length.allowed <- 20
dataset$category <- as.factor(sapply(dataset$category,
                                     FUN = label.splitter,
                                     max.length.allowed))

# Create the graph
ggplot(dataset, aes(x = reorder(subcategory, -count_species_key),
                    y = count_species_key)) +
    geom_bar(stat = "identity", width = .65) +
    geom_text(aes(label = count_species_key), y = .1, vjust = 0.5,
              size = 4, angle = 90, hjust = 1.2) +
    ylab("Number of species") +
    facet_grid(. ~ category, scales = "free_x",
               space = "free_x") +
    theme_inbo2015(base_size = 11) +
    theme(
        axis.text.x = element_text(angle = 90, hjust = 1,
                                   vjust = 0.2, size = 10),
        axis.title.x = element_blank(),
        axis.text.y = element_text(size = 12, angle = 90,
                                   hjust = 0.5),
        axis.title.y = element_text(size = 14),
        strip.text.x = element_text(angle = 90, size = 12)
        )
# Remark: Rotation of the figure should done outside ggplot
ggsave("pathway_graph.png", width = 30, height = 33,
       units = "cm", dpi = 150)

# -------------------------------------------------------

dataset <- read.csv(
    "../../data/interim/pathway_figure_aggregate_plant_animal.tsv",
    sep = "\t"
)

# Make category capital letters
dataset <- mutate_at(dataset, .cols = c("category"), .funs = toupper)
# subcategory add line splits
max.length.allowed <- 30
dataset$subcategory <- as.factor(sapply(dataset$subcategory,
                                        FUN = label.splitter,
                                        max.length.allowed))
# category add line splits
max.length.allowed <- 20
dataset$category <- as.factor(sapply(dataset$category,
                                     FUN = label.splitter,
                                     max.length.allowed))

# Create the graph
ggplot(dataset, aes(x = reorder(subcategory, -count_species_key),
                    y = count_species_key, fill = kingdom)) +
    geom_bar(stat = "identity", width = .65) +
    ylab("Number of species") +
    facet_grid(. ~ category, scales = "free_x",
               space = "free_x") +
    theme_inbo2015(base_size = 11) +
    theme(
        axis.text.x = element_text(angle = 90, hjust = 1,
                                   vjust = 0.2, size = 10),
        axis.title.x = element_blank(),
        axis.text.y = element_text(size = 12, angle = 90,
                                   hjust = 0.5),
        axis.title.y = element_text(size = 14),
        strip.text.x = element_text(angle = 90, size = 12),
        legend.direction = "horizontal",
        legend.position = "bottom",
        legend.text = element_text(angle = 90, size = 14),
        legend.title = element_blank(),
        legend.text.align = -.6
    )

ggsave("pathway_graph_plant_animal.png", width = 30, height = 33,
       units = "cm", dpi = 150)

#-------------------------------------------------------

checklist <- read.csv(
    "../../data/interim/nara_figure_cumul_data.tsv",
    sep = "\t"
)

# drop the rows without habitat info
checklist <- checklist[checklist$habitat_short != "",]

## Cumulative histogram ->
## cfr. ISSUE as count is also in between groups...
## http://dantalus.github.io/2015/08/16/step-plots/
# ggplot(data = checklist, aes(firstObservationYearBE)) +
#     geom_histogram(aes(y = cumsum(..count..),
#                        fill = habitat_short),
#                     binwidth = 15,
#                     position = "stack") +
#     xlab("") +
#     ylab("Aantal uitheemse soorten") +
#     theme_inbo2015(base_size = 14) +
#     theme(legend.position = "top",
#           legend.title = element_blank())

# Possible SOLUTION 1: plot them each independent

bin_years = 15
ggplot(data = checklist, aes(firstObservationYearBE)) +
    stat_bin(data = subset(checklist, habitat_short == "terrestrial"),
             aes(y = cumsum(..count..)),
             binwidth = bin_years,
             geom = "step", size = 3,
             color = INBOgreen) +
    annotate("text",
             x = max(checklist$firstObservationYearBE) + 1.,
             y = sum(checklist$habitat_short == "terrestrial"),
             label = as.character(sum(checklist$habitat_short == "terrestrial")),
             size = 8, color = INBOgreen) +
    stat_bin(data = subset(checklist, habitat_short == "freshwater"),
             aes(y = cumsum(..count..)),
             binwidth = bin_years,
             geom = "step", size = 3, color = INBOblue) +
    annotate("text",
             x = max(checklist$firstObservationYearBE)+ 1.,
             y = sum(checklist$habitat_short == "freshwater"),
             label = as.character(sum(checklist$habitat_short == "freshwater")),
             size = 8, color = INBOblue) +
    stat_bin(data = subset(checklist, habitat_short == "marine"),
                   aes(y = cumsum(..count..)),
                    binwidth = bin_years,
                   geom = "step", size = 3, color = INBOreddishbrown) +
    annotate("text",
             x = max(checklist$firstObservationYearBE) + 1.,
             y = sum(checklist$habitat_short == "marine"),
             label = as.character(sum(checklist$habitat_short == "marine")),
             size = 8, color = INBOreddishbrown) +
    stat_bin(data = subset(checklist, habitat_short == "estuarine"),
                   aes(y = cumsum(..count..)),
                   binwidth = bin_years,
                   geom = "step", size = 3, color = INBOdarkgreen) +
    annotate("text",
             x = max(checklist$firstObservationYearBE) + 1.,
             y = sum(checklist$habitat_short == "estuarine"),
             label = as.character(sum(checklist$habitat_short == "estuarine")),
             size = 8, color = INBOdarkgreen) +
    xlab("") +
    ylab("Aantal uitheemse soorten") +
    theme_inbo2015(base_size = 14) +
    theme(legend.position = "top",
          legend.title = element_blank(),
          legend.text = element_text((size = 14)))




# Consider to calculate it manually and plot the 'bars'...



# other try-out...
library(plyr)
checklist <- ddply(checklist,.(habitat_short),transform,
                   len = length(firstObservationYearBE))
ggplot(data = checklist, aes(firstObservationYearBE,
                             fill = habitat_short,
                             color = habitat_short)) +
    geom_step(aes(len = len, y = ..y.. * len),
              stat="ecdf", bin = 15)

ggsave("cumul_number.png", width = 30, height = 33,
       units = "cm", dpi = 150)




