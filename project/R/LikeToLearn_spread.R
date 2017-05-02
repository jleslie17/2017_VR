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

# # remove duplicate rows
# delegate_data <- delegate_data[!duplicated(delegate_data),]
# rownames(delegate_data) <- 1:nrow(delegate_data)
# 
# # Clean data ====
# # Empty rows in del_data? 
nrow(delegate_data[rowSums(is.na(delegate_data)) == ncol(delegate_data),])
delegate_data <- delegate_data[!rowSums(is.na(delegate_data)) ==
                                 ncol(delegate_data),]
table(duplicated(delegate_data))

targets <- data.frame(delegate_data$Like.to.learn.)
names(targets) <- "Like.to.learn"

head(targets)


# Spread responses ====
targets_spread <- AddUnderscoresPipes(targets) %>% 
  SpreadResponses()

#rm(targets, users)
targets_spread <- targets_spread[,sort(names(targets_spread))]

names(targets_spread)
head(targets_spread)

# Export all in one sheet with names
all_spread <- cbind(delegate_data$FirstName,
                    delegate_data$Surname,
                    delegate_data$Job.Title,
                    delegate_data$Company,
                    targets_spread)
names(all_spread)[1:4] <- c("First Name", "Surname",
                            "Job Title", "Company")
head(all_spread)
write.xlsx(all_spread,
           file = "project/figs/all_in_one_sheet.xlsx",
           row.names = F)


# export the data ====
# if (file.exists("project/figs/test.xlsx")) {
#   file.remove("project/figs/test.xlsx")
# }
# 
# for(i in 1:ncol(targets_spread)) {
#   write.xlsx(targets_spread[,c(i)], 
#              file = "project/figs/responses_on_tabs.xlsx", 
#              sheetName = names(targets_spread)[i],
#              row.names = F,
#              col.names = F,
#              append = T)
# }

# Try something faster:
# wb <- createWorkbook()
# for (i in names(targets_spread)) {
#   print(i)
#   sheet <- createSheet(wb, i)
#   addDataFrame(targets_spread[[i]],
#                sheet = sheet,
#                row.names = F,
#                col.names = F)
# }
# saveWorkbook(wb, "project/figs/responses_on_tabs.xlsx")

# Just names in tabs:
wb <- createWorkbook()
for (i in names(all_spread)[-c(1:4)]) {
  print(i)
  sheet <- createSheet(wb, i)
  tempdf <- all_spread[,1:4]
  tempdf <- cbind(tempdf, targets_spread[[i]])
  tempdf <- tempdf[tempdf[,5] == 1, 1:4]
  addDataFrame(tempdf,
               sheet = sheet,
               row.names = F,
               col.names = T)
}
saveWorkbook(wb, "project/figs/responses_on_tabs_170502.xlsx")



# compare speeds: ====
# system.time({
#   for(i in 1:ncol(targets_spread)) {
#     write.xlsx(targets_spread[,c(i)],
#                file = "project/figs/test.xlsx",
#                sheetName = names(targets_spread)[i],
#                row.names = F,
#                col.names = F,
#                append = T)
#   }
# 
# }) # ~30 seconds
# 
# system.time({
#   wb <- createWorkbook()
#   for (i in names(targets_spread)) {
#     print(i)
#     sheet <- createSheet(wb, i)
#     addDataFrame(targets_spread[[i]],
#                  sheet = sheet,
#                  row.names = F,
#                  col.names = F)
#   }
#   saveWorkbook(wb, "project/figs/test2.xlsx")
# }) # ~0.7 seconds!
# 
# test1 <- read.xlsx("project/figs/test.xlsx",
#                    sheetIndex = 10)
# test2 <- read.xlsx("project/figs/test2.xlsx",
#                    sheetIndex = 10)
# identical(test1, test2)



