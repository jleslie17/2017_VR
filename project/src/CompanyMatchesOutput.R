library(xlsx)
# This puts the data into a four-column data frame with the lists of matches as
# one \n-separated string in the fourth column

GetCompanyMatchesOutput <- function(delegate_data, sponsor_data, Delegates_to_meet){
        Sponsor_info <- sponsor_data[,c(4, 2)] #FirstName, Surname, email
        CompanyMatchesOutput <- data.frame(matrix(ncol = 3, nrow = nrow(sponsor_data)))
        names(CompanyMatchesOutput) <- c('Name', 'email', 'Matches')
        CompanyMatchesOutput$Name <- Sponsor_info$Contact.name
        CompanyMatchesOutput$email <- Sponsor_info$Email.address
        
        for(i in 1:nrow(CompanyMatchesOutput)){
                Matches <- Delegates_to_meet[,i]
                Matches <- Matches[Matches != '']
                if(length(Matches) != 0){
                        CompanyMatchesOutput$Matches[i] <- paste(Matches, collapse = '\n')
                }
        }
        return(CompanyMatchesOutput)
}
