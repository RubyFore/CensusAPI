
# ------ Creating a rich SPDF dataset using Tigris and the Census API ---------




# ----- Assembling the URL ----------------------------------------------------

# First we must download data from the Census API
library(stringr)
library(tigris)
library(sp)

# Variable Codes are found in the census summary file at https://www.census.gov/prod/cen2010/doc/sf1.pdf. 
# Variable names can change from year to year and are very similar, so be careful! 

varCodes2010 <- c('P0010001', 'P0030001', 'P0030002', 'P0030003', 'P0030004', 'P0030005', 'P0030006', 'P0030007', 'P0030008', 
                  'P0040001', 'P0040003', 'P0040002', 'P0140001', 'P0100001')

varNames <- c('totPop', 'racePop', 'white', 'black', 'nativeAm', 'asian', 'pacIslander', 'otherRace', 'twoRace', 
              'ethnicityPop', 'hispanic', 'notHispanic', 'popUnder20', 'pop18AndOver')

# Using stringr::str_c to change a vector of strings into a single string seperated by commas
varString2010 <- stringr::str_c(varCodes2010, collapse=',')
base_url_2010 <-'http://api.census.gov/data/2010/sf1'
key <- '049cb3ae750de5c1feb96f5cdf309a864ca435d9'

queryURL2010 <- paste0(base_url_2010, '?get=', varString2010, '&for=county&in=state:*', '&key=', key)

data2010 <- jsonlite::fromJSON(queryURL2010)
data2010 <- as.data.frame(data2010[-1,], stringsAsFactors=FALSE)
names(data2010) <- c(varNames, 'state', 'county')

# Adding a column that corresponds to the unique Geographic region identifiers
# in the tigris dataset
data2010$GEOID <- paste0(data2010$state, data2010$county)

# Changing from characters to factors
data2010$totPop <- as.numeric(data2010$totPop)
data2010$racePop <- as.numeric(data2010$racePop)
data2010$white<- as.numeric(data2010$white)
data2010$black <- as.numeric(data2010$black)
data2010$nativeAm <- as.numeric(data2010$nativeAm)
data2010$asian <- as.numeric(data2010$asian)
data2010$pacIslander <- as.numeric(data2010$pacIslander)
data2010$otherRace <- as.numeric(data2010$otherRace)
data2010$twoRace <- as.numeric(data2010$twoRace)
data2010$ethnicityPop <- as.numeric(data2010$ethnicityPop)
data2010$hispanic <- as.numeric(data2010$hispanic)
data2010$notHispanic <- as.numeric(data2010$notHispanic)
data2010$popUnder20 <- as.numeric(data2010$popUnder20)
data2010$pop18AndOver <- as.numeric(data2010$pop18AndOver)


# Creating new percentage variables
data2010$percentHispanic <- data2010$hispanic/data2010$ethnicityPop
data2010$percentAsian <- data2010$asian/data2010$racePop
data2010$percentBiracial <- data2010$twoRace/data2010$racePop
data2010$percentChildren <- data2010$popUnder20/data2010$totPop



# ----- Using Tigris package to download the Tiger/Line census shape files----

stateCodes <- unique(data2010$state)
stateCodes <- as.character(stateCodes)

# Removing Alaska (02) and Hawaii (15)
stateCodes <- stateCodes[-12]
stateCodes <- stateCodes[-2]

USCounties2010 <- tigris::counties(state=stateCodes)


rownames(data2010) <- data2010$GEOID
reorderedData2010 <- data2010[USCounties2010@data$GEOID,]


# Combining dowloaded and augmented Census dataset with spatial data frame. 
richSpdf2010 <- cbind(USCounties2010, reorderedData2010)

USCounties2010@data <- richSpdf2010


# 
# # plotting
# colors <- RColorBrewer::brewer.pal(7, 'BuGn') 
# breaks <- c(0, .01, .03, .05, .1, .20, .5, 1)
# colorIndices <- .bincode(USCounties2010@data$percentHispanic, breaks=breaks)
# plot(USCounties2010, col=colors[colorIndices], lty=0)







