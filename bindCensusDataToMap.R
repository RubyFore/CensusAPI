
# Bind Census data to a Spatial Polygons Dataframe from tigris package using GEOID as unique identifier. 


bindCensusDataToMap <- function(df, spdf) {
  rownames(df) <- df$GEOID
  reorderedData <- df[spdf@data$GEOID,]
  completeData <- cbind(spdf@data, reorderedData)
  spdf@data <- completeData
  return(spdf)
}

