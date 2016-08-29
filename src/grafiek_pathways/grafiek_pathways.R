library(dplyr)
library(readxl)
library(ggplot2)
library(INBOtheme)
library(tidyr)
library(grid)
library(gridExtra)

# gebruik een RStudio project! Dan heb je geen setwd() nodig
# setwd("C:/Users/tim_adriaens/Google Drive/Data/adviezen/2016/INBO.A.2016.12_pathways/")
setwd("C:/Users/tim_adriaens/Google Drive/Data/adviezen/2016/INBO.A.2016.12_pathways/")
dataset <- read_excel(
  "pathways_tabel.xlsx",
  sheet = 1,
  col_names = c("subcategorie", "hoofdcategorie", "kingdom", "species"),
  skip = 1
) %>%
  mutate(
    # zet correcte linebreaks
    subcategorie = gsub("\\\\n ", "\n", subcategorie),
    # bepaal volgorde subcategorie
    subcategorie = reorder(subcategorie, -species),
    # bepaal volgorde hoofdcategorie
    hoofdcategorie = factor(
      hoofdcategorie,
      #levels = c(
      #  "ESCAPE from confinement", "UNAIDED", "TRANSPORT - STOWAWAY",
      #  "TRANSPORT - CONTAMINANT", "RELEASE IN NATURE", "CORRIDOR"

        levels = c(
          "RELEASE IN NATURE", "ESCAPE from confinement", "TRANSPORT - CONTAMINANT", "TRANSPORT - STOWAWAY",
          "TRANSPORT - CONTAMINANT",  "CORRIDOR", "UNAIDED"

      )
    )
  )
ggplot(dataset, aes(x = subcategorie, y = species)) +
  geom_bar(stat = "identity", width = .75) +
  geom_text(aes(label=species), y = .1, vjust= 1.5, size=3) +
    facet_grid(. ~ hoofdcategorie, scales = "free_x", space = "free_x") +
  theme_inbo2015(base_size = 11) +
  theme(
    axis.text.x = element_text(angle =  90, hjust = 1, vjust = 0.2),
    axis.title.x = element_blank()
  )

dataset <- read_excel("grafiekjes.xlsx", sheet = 2)[1:6, 1:4] %>%
  gather("Regio", "Aantal", -1, na.rm = FALSE) %>%
  mutate(
    Aantal = ifelse(is.na(Aantal), 0, Aantal),
    N = gsub("^.*N =", "", Regio),
    N = gsub("\\).*$", "", N),
    N = as.integer(N),
    Verhouding = Aantal / N
  )
colnames(dataset)[1] <- "Level1"


p <- ggplot(dataset, aes(x = Level1, y = Verhouding, fill = Regio)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label=Aantal, y = -0.0001), vjust= 1.5, size=3, color = "black", position= position_dodge(0.75)) +
  theme_inbo2015(base_size = 8) +
  theme(
    axis.title.x = element_blank(),
    plot.margin = margin(t = 2, r = 2, b = 22, l = 20, unit = "mm")
  )
p

basis <- dataset %>%
  select(Level1, Regio, Aantal) %>%
  spread(Level1, Aantal) %>%
  tableGrob(
    cols = NULL,
    rows = NULL,
    widths = unit(c(29, rep(35.2, 6)), "mm"),
    theme = ttheme_default(
      base_size = 8,
      base_colour = inbo.hoofd
    )
  )
p + annotation_custom(basis, xmin = -1.1, ymax = -0.42)
