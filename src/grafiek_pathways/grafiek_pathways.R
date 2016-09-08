library(dplyr)
library(ggplot2)
library(INBOtheme) # install with devtools: install_github("inbo/inboTheme")
library(tidyr)
library(grid)
library(zoo)

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

habitats = c("freshwater", "marine", "estuarine", "terrestrial")


# Filter the habitat descriptions on the different habitat short names
for (habitat in habitats) {
    checklist[habitat] <- stringr::str_extract(checklist$habitat,
                                                   habitat)
}

# drop the rows without habitat info (for at least any one there is habitat defined)
checklist <- checklist[rowSums(is.na(checklist[habitats])) < 4,]

# Create the period sections
bin_years <- 15
checklist$period_sections <- cut(checklist$firstObservationYearBE,
                                 seq(1800, 2030, bin_years),
                                 include.lowest = TRUE, ordered_result = TRUE)

# years earlier to given
min_year <- 1800
checklist[checklist$firstObservationYearBE < min_year,
          "firstObservationYearBE"] <- min_year

# Combine the habitat columns to a single variable column
checklist <- checklist %>% gather(habitat_short, habitat_name,
                                  c(freshwater, marine,
                                    estuarine, terrestrial)) %>%
                            select(-habitat_short) %>%
                            drop_na()

# Sort on the year values
checklist <- checklist[order(checklist$firstObservationYearBE), ]

# combine the period section for every 15 years HIEERDOOR TEVEEL!!
checklist$period_count <- ave(rep(1, nrow(checklist)),
                           checklist$period_sections,
                           checklist$habitat_name,
                           FUN = sum)

# count number of species in each habitat-period combination
checklist_count <- count(checklist, c("habitat_name", "period_sections"))

# create cumulative counts per factor
checklist_count$cumcount <- ave(checklist_count$freq,
                                checklist_count$habitat_name,
                                FUN = cumsum)
#checklist_count$habitat_name <- as.factor(checklist_count$habitat_name)


# Fill in the remaining habitat-period combination
# strategy: combine with a dataframe with all combinations and fill in
# empty spots with continuous value from last known
levels(checklist_count$period_sections) <- seq(min_year, 2020, bin_years)
checklist_count$habitat_name <- factor(checklist_count$habitat_name)

all_options <- with(checklist_count,
                    expand.grid(period_sections = levels(checklist_count$period_sections),
                                habitat_name = levels(habitat_name)))
all_options <- all_options[order(all_options$period_sections),]

checklist_count_all <- merge(all_options, checklist_count,
                             by = c("habitat_name", "period_sections"),
                             all.x = TRUE)

checklist_count_all <- ddply(checklist_count_all, .(habitat_name), na.locf)
checklist_count_all$cumcount <- as.numeric(checklist_count_all$cumcount)
checklist_count_all$period_sections <- as.numeric(checklist_count_all$period_sections)

ggplot(data = checklist_count_all, aes(x = period_sections,
                                   y = cumcount)) +
                geom_bar(stat = "identity") +
                theme_inbo2015(base_size = 14) +
                facet_grid( . ~ habitat_name) +
                scale_x_discrete(labels = seq(1800, 2030, bin_years)) +
                xlab("") +
                ylab("Aantal uitheemse soorten") +
                theme(strip.text.x = element_text(size = 16)) +
                scale_x_continuous(breaks = seq(1800, 2010, 50))

# -----------------------












## Cumulative histogram ->
## cfr. ISSUE as count is also in between groups...
## http://dantalus.github.io/2015/08/16/step-plots/
ggplot(data = checklist, aes(firstObservationYearBE,
                             colour = habitat_short)) +
    geom_histogram(aes(y = cumsum(..count..),
                       fill = habitat_short),
                    binwidth = 15,
                    position = "stack") +
    xlab("") +
    ylab("Aantal uitheemse soorten") +
    theme_inbo2015(base_size = 14) +
    theme(legend.position = "top",
          legend.title = element_blank())  +
    facet_grid(.~ habitat_short)

# Possible SOLUTION 2: plot them each independent


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
             x = max(checklist$firstObservationYearBE) + 1.,
             y = sum(checklist$habitat_short == "freshwater"),
             label = as.character(sum(checklist$habitat_short == "freshwater")),
             size = 8, color = INBOblue) +
    stat_bin(data = subset(checklist, habitat_short == "marine"),
                   aes(y = cumsum(..count..)),
                    binwidth = bin_years,
                   geom = "step", size = 3, color = INBOreddishbrown) +
    annotate("text",
             x = max(checklist$firstObservationYearBE) + 1.,
             y = sum(checklist$habitat_short == "marine") - 3,
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
    annotate("text",
             x = max(checklist$firstObservationYearBE) - 3,
             y = max(table(checklist$habitat_short)) + 4,
             label = paste("Totaal: ", as.character(nrow(checklist))),
             size = 8, color = INBOred) +
    xlab("") +
    ylab("Aantal uitheemse soorten") +
    theme_inbo2015(base_size = 14) +
    theme(legend.position = "top",
          legend.title = element_blank(),
          legend.text = element_text((size = 14)))

ggsave("cumulatief_aantal_invasieve.png", width = 33, height = 25,
       units = "cm", dpi = 150)





















