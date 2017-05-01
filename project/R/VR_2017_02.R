library(lsa)
library(tidyverse)
library(xlsx)

path_to_scripts <- file.path("project/src")
datadir <- file.path("project/data")
codedir <- file.path("/project/code")
Rdir <- file.path("/project/R")
output_dir <- file.path("/project/figs")

source(file.path(path_to_scripts, "AddUnderscores.R"))
source(file.path(path_to_scripts, "AddUnderscoresPipes.R"))
source(file.path(path_to_scripts, "SpreadResponses.R"))
source(file.path(path_to_scripts, "GetMatches.R"))
source(file.path(path_to_scripts, "CompanyMatchesOutput.R"))
source(file.path(path_to_scripts, "Matrix_functions.R"))

# Load data ====
delegate_data_old <- read.csv(
  "project/data/VR_Data_010217.csv",
  header = T,
  na.strings = '')

delegate_file <- "NEW data delegates 27.04.2017.csv"
delegate_data <- read.csv(file.path(datadir, delegate_file),
  header = T,
  na.strings = ''
)

names(delegate_data_old)
names(delegate_data)

# remove duplicate rows
delegate_data <- delegate_data[!duplicated(delegate_data),]
rownames(delegate_data) <- 1:nrow(delegate_data)
# del_tibble <- read_csv(
#   "project/data/VR_Data_010217.csv"
# )

sponsor_file_old <- "Copy of Sponsor Intel 6 March new.xlsx"
sponsor_data_old <- read.xlsx(file.path(datadir, sponsor_file_old), 
                          sheetIndex = 1,
                          header = T)
sponsor_file <- "New sponsors data 24.04.2017.xls"
sponsor_data <- read.xlsx(file.path(datadir, sponsor_file),
                          sheetIndex = 1,
                          header = T)

names(sponsor_data_old)
names(sponsor_data)
# Clean data ====
# Empty rows in del_data? 
nrow(delegate_data[rowSums(is.na(delegate_data)) == ncol(delegate_data),])
delegate_data <- delegate_data[!rowSums(is.na(delegate_data)) == 
                                 ncol(delegate_data),]
# nrow(del_tibble[rowSums(is.na(del_tibble)) == ncol(del_tibble),])
nrow(sponsor_data[rowSums(is.na(sponsor_data)) == ncol(sponsor_data),])

names(delegate_data_old)[12:19]
names(delegate_data)[11:18]
names(sponsor_data[, 5:10])

targets <- delegate_data[, c(11:18)]
users <- sponsor_data[, 5:10]

head(targets)


# Spread responses ====
targets_spread <- AddUnderscoresPipes(targets) %>% 
  SpreadResponses()
users_spread <- AddUnderscores(users) %>% 
  SpreadResponses()
#rm(targets, users)
targets_spread <- targets_spread[,sort(names(targets_spread))]
users_spread <- users_spread[,sort(names(users_spread))]

names(targets_spread)
names(users_spread)

# Clean up screwy inconsistencies in responses ====
names(users_spread)[!names(users_spread) %in% names(targets_spread)]
CombineSimilarColumns <- function(df, a, b){
  # Takes entries from column b and puts them into col a, then removes
  # col b. Use this when two columns have slightly different names but
  # tell the same information.
  df[[a]][df[[b]] == 1] <- 1
  df <- df[, names(df) != b]
  return(df)
}

a <- "Healthcare_and_Medical"
b <- "Healthcare_&_Medical"
table(users_spread[[a]])
table(users_spread[[b]])
users_spread <- CombineSimilarColumns(users_spread, a, b)
table(users_spread[[a]])
table(users_spread[[b]])
names(users_spread)


a <- "Sports_and_Live_Events"
b <- "Sports_&_Live_Events"
table(users_spread[[a]])
table(users_spread[[b]])
users_spread <- CombineSimilarColumns(users_spread, a, b)
table(users_spread[[a]])
table(users_spread[[b]])
names(users_spread)

names(users_spread)[names(users_spread) == "Videogames_"] <- "Videogames"
names(users_spread)

names(targets_spread)

# Remove the columns that don't overlap ====
names(users_spread)[!names(users_spread) %in% names(targets_spread)]
users_tidy <- users_spread[,names(users_spread) %in% names(targets_spread)]
targets_tidy <- targets_spread[,names(targets_spread) %in% names(users_tidy)]
# rm(targets_spread, users_spread)

# Check to make sure the names match
# for(i in 1:length(names(users_tidy))){
#   print(names(users_tidy)[i])
#   print(names(targets_tidy)[i])
# }

# Create matrix ====
m <- matrix(0, nrow = nrow(users_tidy), ncol = nrow(targets_tidy))
m_users <- as.matrix(users_tidy)
m_targets <- as.matrix(targets_tidy)

# fill m with cosine similarities
for(i in 1:nrow(m_users)) {
  # Go through m row-wise and get cosine distances to each target
  m[i,] <- GetDistancesToTargets(m_users[i,])
}

L <- list()
for(i in 1:nrow(m)) {
  L[[i]] <- RankTargets(m[i,])
}

# L is a list of matches
# Here there is a list of matches. Now get that into suitable output
# This puts the list of names of matches column-wise. Each column is
# a delgate, with the rows being the matches. Not a great output.
Delegates_to_meet <- GetMatches(L, delegate_data, sponsor_data)

# This puts the data into a four-column dataframe, with the list of matches 
# as one \n-separated string in the fourth column.
Matches <- GetCompanyMatchesOutput(delegate_data, sponsor_data, Delegates_to_meet)

write.xlsx(Matches,
           "project/figs/Matches_170430.xlsx",
           row.names = F)
