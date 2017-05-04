source("project/src/test_functions.R")
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

t19 <- AddUnderscoresPipes(
  as.data.frame(delegate_data$I.Would.Like.To.Learn.More.About.The.Following.VR.AR.MR.Opportunities.At.The.Show.)) %>% 
  SpreadResponses()
sort(names(t19))
t18 <- AddUnderscoresPipes(
  as.data.frame(delegate_data$Which.technology.is.of.most.interest.to.you.)) %>% 
  SpreadResponses()
sort(names(t18))

# Why does target 467 always come up at the bottom?
L[[9]]
m[9,467]
m[9,]
# L is wrong. 497 is not the lowest, yet it appears last in L
RankTargets(m[9,])

targets_spread[467,]
users_spread[11,]

# Checking duplicates
for(i in 1:24) {
  print(identical(first[,i], second[,i]))
}
identical(delegate_data[123,], delegate_data[124,])
length(delegate_data[124,])
first <- as.list(delegate_data[171,])
second <- as.list(delegate_data[172,])
identical(first, second)

# Tests 
query <- 1
get_top_match(21, T, F)
get_top_match(21, T, T)

query <- 26
get_top_match(query = query, T, T)
source("project/src/test_functions.R")
get_top_match_LikeToLearn(query = query, T, T)

names(users_spread)[!names(users_spread) %in% names(targets_spread)]
