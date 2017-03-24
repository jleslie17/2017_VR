library(lsa)
library(tidyverse)

path_to_scripts <- file.path("project/src")
datadir <- file.path("/project/data")
codedir <- file.path("/project/code")
Rdir <- file.path("/project/R")

source(file.path(path_to_scripts, "AddUnderscores.R"))
source(file.path(path_to_scripts, "AddUnderscoresPipes.R"))
source(file.path(path_to_scripts, "SpreadResponses.R"))
source(file.path(path_to_scripts, "GetMatches.R"))
source(file.path(path_to_scripts, "CompanyMatchesOutput.R"))

# Load data
del_data <- read.csv(
  "project/data/VR_Data_010217.csv",
  header = T,
  na.strings = '')
head(del_data)

# del_tibble <- read_csv(
#   "project/data/VR_Data_010217.csv"
# )

sponsor_data <- read.xlsx(paste(datadir, "Sponsor Intel 6 March.xlsx", sep = ''),
                         sheetIndex = 1,
                         header = T)
# Clean data ====
# Empty rows in del_data? No!
nrow(del_data[rowSums(is.na(del_data)) == ncol(del_data),])
# nrow(del_tibble[rowSums(is.na(del_tibble)) == ncol(del_tibble),])
nrow(sponsor_data[rowSums(is.na(sponsor_data)) == ncol(sponsor_data),])

targets <- del_data[, c(12:19)]
users <- sponsor_data[, c(5:6)]

# targets2 <- del_tibble %>% 
#   select(c(12:19))

# Put underscores between words, but not between answers
targets <- AddUnderscoresPipes(targets)
# Spread responses
tarSpread <- SpreadResponses(targets)
names(tarSpread)
head(targets)

head(users)
users <- AddUnderscores(users)
head(users)
usersSpread <- SpreadResponses(users)
names(usersSpread)
