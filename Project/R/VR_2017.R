library(lsa)
library(tidyverse)

path_to_scripts <- file.path("project/src")
datadir <- file.path("project/data")
codedir <- file.path("/project/code")
Rdir <- file.path("/project/R")

source(file.path(path_to_scripts, "AddUnderscores.R"))
source(file.path(path_to_scripts, "AddUnderscoresPipes.R"))
source(file.path(path_to_scripts, "SpreadResponses.R"))
source(file.path(path_to_scripts, "GetMatches.R"))
source(file.path(path_to_scripts, "CompanyMatchesOutput.R"))

# Load data ====
delegate_data <- read.csv(
  "project/data/VR_Data_010217.csv",
  header = T,
  na.strings = '')
head(delegate_data)

# del_tibble <- read_csv(
#   "project/data/VR_Data_010217.csv"
# )

sponsor_file <- "Copy of Sponsor Intel 6 March new.xlsx"
sponsor_data <- read.xlsx(file.path(datadir, sponsor_file), 
                          sheetIndex = 1,
                          header = T)
# Clean data ====
# Empty rows in del_data? No!
nrow(delegate_data[rowSums(is.na(delegate_data)) == ncol(delegate_data),])
# nrow(del_tibble[rowSums(is.na(del_tibble)) == ncol(del_tibble),])
nrow(sponsor_data[rowSums(is.na(sponsor_data)) == ncol(sponsor_data),])

targets <- delegate_data[, c(12:19)]

names(sponsor_data)
users <- sponsor_data[, 5:10]

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

sort(names(tarSpread))
sort(names(usersSpread))
table(names(tarSpread) %in% names(usersSpread))
table(names(usersSpread) %in% names(tarSpread))
names(usersSpread[!names(usersSpread) %in% names(tarSpread)])
names(tarSpread[!names(tarSpread) %in% names(usersSpread)])

# Figure out where the matches go ====
head(delegate_data)
names(delegate_data)
levels(delegate_data$I.Am.An.End.User.With.An.Interest.In.The.Following.VR.AR.MR.Applications.)
levels(delegate_data$I.Represent.A.Technology.Provider.Best.Described.As.The.Following.)
levels(delegate_data$Which.technology.is.of.most.interest.to.you.)
levels(delegate_data$I.Would.Like.To.Learn.More.About.The.Following.VR.AR.MR.Opportunities.At.The.Show.)
t19 <- SpreadResponses(
  as.data.frame(delegate_data$I.Would.Like.To.Learn.More.About.The.Following.VR.AR.MR.Opportunities.At.The.Show.))
names(t19)
t19 <- AddUnderscoresPipes(
  as.data.frame(delegate_data$I.Would.Like.To.Learn.More.About.The.Following.VR.AR.MR.Opportunities.At.The.Show.)) %>% 
  SpreadResponses()
names(t19)
