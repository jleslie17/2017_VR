library(lsa)
library(tidyverse)

path <- getwd()
datadir <- paste(path, '/data/', sep = '')
codedir <- paste(path, '/code/', sep = '')

source(paste(codedir, 'AddUnderscores.R', sep = ''))
source(paste(codedir, 'SpreadResponses.R', sep = ''))
source(paste(codedir, 'GetMatches.R', sep = ''))
source(paste(codedir, 'CompanyMatchesOutput.R', sep = ''))

# Load data
Data <- read.csv(
  "data/VR_Data_010217.csv",
  header = T,
  na.strings = '')
head(Data)

DataTib <- read_csv(
  "data/VR_Data_010217.csv"
)
DataTib

names(DataTib)
str(DataTib)
