# ----- Example uses for the states of WA and RI, year 2010, with graphs. 

source('~/Projects/CensusAPI/bindCensusDataToMap.R')
source('~/Projects/CensusAPI/createCensusURL.R')
source('~/Projects/CensusAPI/createCleanCensusDF.R')


varCodes2010 <- c('P0010001', 'P0030001', 'P0030002', 'P0030003', 'P0030004', 'P0030005', 'P0030006', 'P0030007', 'P0030008', 
                  'P0040001', 'P0040003', 'P0040002', 'P0140001', 'P0100001')

varNames <- c('totPop', 'racePop', 'white', 'black', 'nativeAm', 'asian', 'pacIslander', 'otherRace', 'twoRace', 
              'ethnicityPop', 'hispanic', 'notHispanic', 'popUnder20', 'pop18AndOver')


# This is my personal US Census API key
key <- '049cb3ae750de5c1feb96f5cdf309a864ca435d9'


# Looking at Rhode Island 
RItracts2010URL <- createCensusURL(2010, varCodes2010, state='44', level='tract', key=key )

RItracts2010 <- createCleanCensusDF(RItracts2010URL, varNames=varNames, tracts=TRUE)
RItracts2010$percentHispanic <- RItracts2010$hispanic/RItracts2010$totPop
RItracts2010$percentUnder20 <- RItracts2010$popUnder20/RItracts2010$totPop

RISpdf <- tigris::tracts('44')

RISpdf <- bindCensusDataToMap(RItracts2010, RISpdf)

# Looking at Washington
  
WAtractsURL <- createCensusURL(2010, varCodes2010, state='53', level='tract', key=key)

WAtracts2010 <- createCleanCensusDF(WAtractsURL, varNames=varNames, tracts=T)
WAtracts2010$percentHispanic <- WAtracts2010$hispanic/WAtracts2010$totPop
WAtracts2010$percentUnder20 <- WAtracts2010$popUnder20/WAtracts2010$totPop

WASpdf <- tigris::tracts('53')

WASpdf <- bindCensusDataToMap(WAtracts2010, WASpdf)


# Plotting scripts
colors <- RColorBrewer::brewer.pal(4, 'BuGn') 
breaks <- quantile(RISpdf@data$percentHispanic, na.rm=T)
colorIndices <- .bincode(RISpdf@data$percentHispanic, breaks=breaks)
plot(RISpdf, col=colors[colorIndices], lty=0)
title('Rhode Island, population by percent Hispanic')

colors <- RColorBrewer::brewer.pal(4, 'BuGn') 
breaks <- quantile(WASpdf@data$percentUnder20, na.rm=T)
colorIndices <- .bincode(WASpdf@data$percentUnder20, breaks=breaks)
plot(WASpdf, col=colors[colorIndices], lty=0)
title('Percent of Population under 20, in quantiles')

colors <- RColorBrewer::brewer.pal(4, 'BuGn') 
breaks <- quantile(WASpdf@data$percentHispanic, na.rm=T)
colorIndices <- .bincode(WASpdf@data$percentHispanic, breaks=breaks)
plot(WASpdf, col=colors[colorIndices], lty=0)
title('Percent population Hispanic, in quantiles')
