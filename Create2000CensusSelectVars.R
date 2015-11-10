
# ------ Creating a rich SPDF dataset using Tigris and the Census API ---------

# explain what this script performs. 


# ----- Assembling the URL ----------------------------------------------------

# First we must download data from the Census API
library(stringr)
library(tigris)
library(sp)

# Variable Codes are found in the census summary file at https://www.census.gov/prod/cen2000/doc/sf1.pdf. 
# Variable names can change from year to year and are very similar, so be careful! 

# TODO Explain what these variables are. 

varCodes2000 <- c('P001001', 'P003001', 'P003003', 'P003004', 'P003005', 'P003006', 'P003007', 'P003008', 'P003009', 
                  'P004001', 'P004002', 'P004003', 'P014001', 'P005001')
varNames <- c('totPop', 'racePop', 'white', 'black', 'nativeAm', 'asian', 'pacIslander', 'otherRace', 'twoRace', 
              'ethnicityPop', 'hispanic', 'notHispanic', 'popUnder20', 'pop18AndOver')

# Using stringr::str_c to change a vector of strings into a single string seperated by commas
varString2000 <- stringr::str_c(varCodes2000, collapse=',')
base_url_2000 <-'http://api.census.gov/data/2000/sf1'
key <- '049cb3ae750de5c1feb96f5cdf309a864ca435d9'

queryURL2000 <- paste0(base_url_2000, '?get=', varString2000, '&for=county&in=state:*', '&key=', key)

# Dowloading data from online and using jsonlite package to read into R
data2000 <- jsonlite::fromJSON(queryURL2000)
data2000 <- as.data.frame(data2000[-1,], stringsAsFactors=FALSE)
names(data2000) <- c(varNames, 'state', 'county')

# Adding a column that corresponds to the unique Geographic region identifiers
# in the tigris dataset
data2000$GEOID <- paste0(data2000$state, data2000$county)

# Changing from characters to factors
data2000$totPop <- as.numeric(data2000$totPop)
data2000$racePop <- as.numeric(data2000$racePop)
data2000$white<- as.numeric(data2000$white)
data2000$black <- as.numeric(data2000$black)
data2000$nativeAm <- as.numeric(data2000$nativeAm)
data2000$asian <- as.numeric(data2000$asian)
data2000$pacIslander <- as.numeric(data2000$pacIslander)
data2000$otherRace <- as.numeric(data2000$otherRace)
data2000$twoRace <- as.numeric(data2000$twoRace)
data2000$ethnicityPop <- as.numeric(data2000$ethnicityPop)
data2000$hispanic <- as.numeric(data2000$hispanic)
data2000$notHispanic <- as.numeric(data2000$notHispanic)
data2000$popUnder20 <- as.numeric(data2000$popUnder20)
data2000$pop18AndOver <- as.numeric(data2000$pop18AndOver)


# Creating new percentage variables
data2000$percentHispanic <- data2000$hispanic/data2000$ethnicityPop
data2000$percentAsian <- data2000$asian/data2000$racePop
data2000$percentBiracial <- data2000$twoRace/data2000$racePop
data2000$percentChildren <- data2000$popUnder20/data2000$totPop



# ----- Using Tigris package to download the Tiger/Line census shape files----

stateCodes <- unique(data2000$state)
stateCodes <- as.character(stateCodes)

# Removing Alaska (02) and Hawaii (15)
stateCodes <- stateCodes[-12]
stateCodes <- stateCodes[-2]

USCounties2000 <- tigris::counties(state=stateCodes)


rownames(data2000) <- data2000$GEOID
reorderedData2000 <- data2000[USCounties2000@data$GEOID,]


# Combining dowloaded and augmented Census dataset with spatial data frame. 
richSpdf2000 <- cbind(USCounties2000, reorderedData2000)

USCounties2000@data <- richSpdf2000



# plotting
colors <- RColorBrewer::brewer.pal(7, 'BuGn') 
breaks <- c(0, .01, .03, .05, .1, .20, .5, 1)
colorIndices <- .bincode(USCounties2000@data$percentHispanic, breaks=breaks)
plot(USCounties2000, col=colors[colorIndices], lty=0)



