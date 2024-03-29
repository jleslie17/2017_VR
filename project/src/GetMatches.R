# This function takes a list of lists, corresponding to possible matches for 
# each delegate. It returns a dataframe with user names as columns with each
# row corresponding to a different match. The lengths of the columns will be 
# different, corresponding to different numbers of suitable matches per 
# delegate.
# 
# 
# New version for VR_2017 takes three arguments: L (list generated from the 
# matrix matching), delegate data and sponsor data. For sponsor data: 
# > names(sponsor_data)[c(4,3)] gives [1] "Contact.name" "Company.name"
# > names(delegate_data[c(3, 4, 23)]) gives [1] "First.Name" "Surname"    "Company" 
# In new 30/04/17 data, want columns 4, 5, 8 from delegates data!!!!!!!!!!!! 

# In newer 4/5/17, matching only on the "like to learn" field, I will include 
# job title, company, and size of company. In total, this is columns 4, 5, 7, 8,
# 10. So: 
# > names(delegate_data)[c(4, 5, 7, 8, 10)]
# [1] "FirstName"           "Surname"             "Job.Title"           "Company"             "Number.of.Employees"




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
        Delegates <- delegate_data[, c(4, 5, 7, 8, 10)]
        DelegatesList <- character()
        for(i in 1:nrow(Delegates)){
                DelegatesList[i] <- paste(Delegates[i,1], #First Name
                                          " ",
                                          Delegates[i,2], #Surname
                                          ', ',
                                          Delegates[i,3], #Job title
                                          ', ',
                                          Delegates[i,4], #Company
                                          paste(' (', Delegates[i,5], ")", sep = ''),
                                          sep = '') 
        }
        

        # Grab the names of deligate targets and fill into dataframe
        for(i in 1:ncol(CompaniesToMeet)){ # Index each user
                for(j in 1:length(CompaniesToMeet[,i])){ # Index each target
                        if(CompaniesToMeet[j,i] > 0){
                                Person <- CompaniesToMeet[j,i]
                                DelegatesToMeet[j,i] <- DelegatesList[Person]
                        }
                }
        }
        return(DelegatesToMeet)
}