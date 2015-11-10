# ----- create a clean dataset from the Census API using a URL generated in a previous function

createCleanCensusDF <- function(url, varNames='', tracts=FALSE) {
  data <- jsonlite::fromJSON(url)
  data <- as.data.frame(data[-1,], stringsAsFactors=FALSE)
  
  if (tracts == FALSE) {
    names(data) <- c(varNames, 'state', 'county')
    for (i in 1:(ncol(data)-2)) {
      data[[i]] <- as.numeric(data[[i]])
    }
    # Adding a column that corresponds to the unique Geographic region identifiers
    # in the tigris dataset
    data$GEOID <- paste0(data$state, data$county)
  } else {
    names(data) <- c(varNames, 'state', 'county', 'tract')
    for (i in 1:(ncol(data) -3)) {
      data[[i]] <- as.numeric(data[[i]])
    }
    data$GEOID <- paste0(data$state, data$county, data$tract)
  }
  return(data)
}


