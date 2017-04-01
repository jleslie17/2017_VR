# These are the functions for the matrix opperations

GetDistancesToTargets <- function(user, targets = m_targets, outcome = "") {
  # Puts the distances from a querried user to each target
  distances <- numeric()
  for(i in 1:nrow(targets)) {
    distances[i] <- cosine(user, targets[i,])
  }
  distances[is.na(distances)] <- 0
  if (outcome == "bin") {
    distances[distances > 0] <- 1
  }
  return(distances)
}

RankTargets <- function(user) {
  # Takes a user and returns a df of ranked similarities to targets
  tempDF <- data.frame(target = 1:length(user),
                       distance = user)
  # returns only the target ID in ranked order, not the score
  tempDF <- tempDF[order(tempDF[,2], decreasing = T),1]
  return(tempDF[1:25]) # to trim it to 25 matches
}

