# This function takes a list of lists, corresponding to possible matches for 
# each delegate. It returns a dataframe with delegate names as columns with each
# row corresponding to a different match. The lengths of the columns will be 
# different, corresponding to different numbers of suitable matches per 
# delegate.
# 
# It takes the arguments of L (the list generated from the matrix matching) and 
# Data, which is the original dataset. Data should have the first four columns 
# of: names(Data)[c(4:6, 8)] <- [1] "Title"      "First.Name" "Surname" 
# "Company"
# 
# New version for VR_2917 takes three arguments: L (list generated from the 
# matrix matching), delegate data and sponsor data. For sponsor data: 
# > names(sponsor_data)[c(4,3)] gives [1] "Contact.name" "Company.name"



GetMatches <- function(L, delegate_data, sponsor_data){
        
        # Put list into a dataframe
        CompaniesToMeet <- data.frame(matrix(0, nrow = length(L), ncol = length(L)))
        for(i in 1:length(L)){
                for(j in 1:length(L[[i]])){
                        CompaniesToMeet[j,i] <- L[[i]][j]
                }
        }
        
        # Trim off the blank rows
        # CompaniesToMeet <- CompaniesToMeet[rowSums(CompaniesToMeet) > 0,]
        
        # Info on the Delegates
        DelegatesToMeet <- data.frame(matrix(as.character(''), nrow = nrow(CompaniesToMeet),
                                             ncol = ncol(CompaniesToMeet)), stringsAsFactors = F)
        
        # Substitute sponsor names into column names
        Sponsors <- sponsor_data[, c(4, 3)]
        names(DelegatesToMeet) <- Sponsors[,1]
        
        # Put the Delegates and affilations into a character vector
        Delegates <- delegate_data[, c(3, 4, 23)]
        DelegatesList <- character()
        for(i in 1:nrow(Delegates)){
                DelegatesList[i] <- paste(Delegates[i,1], #removed title
                                          Delegates[i,2],
                                          ',',
                                          Delegates[i,3])
                DelegatesList[i] <- gsub(' , ', ', ', DelegatesList[i])
        }
        

        # Grab the names of deligate targets and fill into dataframe
        for(i in 1:ncol(CompaniesToMeet)){
                for(j in 1:length(CompaniesToMeet[,i])){
                        if(CompaniesToMeet[j,i] > 0){
                                Person <- CompaniesToMeet[j,i]
                                DelegatesToMeet[j,i] <- DelegatesList[Person]
                        }
                }
        }
        return(DelegatesToMeet)
}