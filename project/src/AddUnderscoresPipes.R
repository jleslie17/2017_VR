# This is a function to put underscores between words in all
# variables. The second line puts a space back in the case of 
# preceeding pipe character.

AddUnderscoresPipes <- function(x){
        for(i in names(x)){
                x[,i] <- gsub(" ", "_", x[,i])
                x[,i] <- gsub("_\\|_", ", ", x[,i])
        }
        return(x)
}

