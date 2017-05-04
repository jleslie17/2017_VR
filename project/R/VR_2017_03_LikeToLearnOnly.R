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
delegate_file <- "NEW data delegates 27.04.2017.csv"
delegate_data <- read.csv(file.path(datadir, delegate_file),
  header = T,
  na.strings = ''
)

names(delegate_data)

# remove duplicate rows
delegate_data <- delegate_data[!duplicated(delegate_data),]
# rownames(delegate_data) <- 1:nrow(delegate_data)

sponsor_file <- "New sponsors data 24.04.2017.xls"
sponsor_data <- read.xlsx(file.path(datadir, sponsor_file),
                          sheetIndex = 1,
                          header = T)

names(sponsor_data)
# Clean data ====
# Empty rows in del_data? 
nrow(delegate_data[rowSums(is.na(delegate_data)) == ncol(delegate_data),])
delegate_data <- delegate_data[!rowSums(is.na(delegate_data)) == 
                                 ncol(delegate_data),]
nrow(sponsor_data[rowSums(is.na(sponsor_data)) == ncol(sponsor_data),])

names(delegate_data)[11:18]
names(sponsor_data[, 5:10])

targets <- data.frame(delegate_data$Like.to.learn.)
names(targets) <- "Like.to.learn"

users <- data.frame(sponsor_data$We.would.be.interested.in.meeting.attendees.who.requested.more.information.on.the.below)


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
names(targets_spread)[!names(targets_spread) %in% names(users_spread)]
names(users_spread)[!names(users_spread) %in% names(targets_spread)]

names(users_spread)[names(users_spread) == "Healthcare_&_Medical"] <- 
  "Healthcare_and_Medical"
names(users_spread)[names(users_spread) == "Sports_&_Live_Events"] <- 
  "Sports_and_Live_Events"

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

Delegates <- delegate_data[, c(4, 5, 7, 8, 10)]
wb <- createWorkbook()
for (i in 1:length(names(Delegates_to_meet))) {
  print(i)
  print(names(Delegates_to_meet)[i])
  sheet <- createSheet(wb, names(Delegates_to_meet)[i])
  tempdf <- Delegates[order(m[i,], decreasing = T), ]
  addDataFrame(tempdf,
               sheet = sheet,
               row.names = F,
               col.names = T)
}
saveWorkbook(wb, "project/figs/test3.xlsx")

# Sys.Date()
# output_name <- paste("project/figs/Matches_", Sys.Date(), ".xlsx", sep = '')
# 
# if (file.exists(output_name)) {
#   x <- readline("File exists. Overwrite? (Y or N): ")
#   if (x == "Y" | x == "y") {
#     write.xlsx(Matches,
#                output_name,
#                row.names = F)
#     
#   }
# }

# Problem: targets that have all of the right items ticket PLUS other are
# penalised compared to those that only have all of the right options ticked.

