RankTargets_For_Testing <- function(user) {
  # Takes a user and returns a df of ranked similarities to targets
  tempDF <- data.frame(target = 1:length(user),
                       distance = user)
  # returns only the target ID in ranked order, not the score
  tempDF <- tempDF[order(tempDF[,2], decreasing = T),]
  return(tempDF[1:25,]) # to trim it to 25 matches
}

see_matching_fields <- function() {
  top_match <- delegate_data[delegate_data$First.Name == first_name &
                               delegate_data$Surname == surname, ]
  top_match_fields <- AddUnderscoresPipes(top_match[1,]) %>% 
    SpreadResponses()
  print("Number of matching fields: ")
  print(length(which(names(querry_fields) %in% names(top_match_fields) == T)))
  print("Querry names that appear in target fields: ")
  print(names(querry_fields)[names(querry_fields) %in% names(top_match_fields)])
  print("All match fields: ")
  print(cat(names(top_match_fields), sep = "\n"))
}

get_top_match <- function() {
  query_info <- sponsor_data[query,]
  print("Name of query: ")
  print(query_info$Contact.name)
  query_fields <- AddUnderscores(query_info) %>% 
    SpreadResponses()
  print("Table of cosine scores: ")
  print(table(m[query,]))
  
  best_targets <- RankTargets_For_Testing(m[query,])
  top_target <- best_targets$target[1]
  target_25 <- best_targets$target[25]
  print("Best matches with scores: ")
  print(best_targets)
  print("cosine distance for best match: ")
  print(cosine(m_users[query,], m_targets[top_target,]))
  print("cosine distance for 25th match: ")
  print(cosine(m_users[query,], m_targets[target_25,]))
  df <- data.frame(user = m_users[query,],
                   top_target = m_targets[top_target,],
                   target_25 = m_targets[target_25,])
  print(df)
}