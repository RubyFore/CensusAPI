

# ----- Creating API URL ------------------------------------------------------
# TODO: make functional for other data files besides the decennial census, 
# TODO: such as ACS, etc. 



# Year is an option of 1990, 2000 or 2010. Vars can be a single variable name or a vector
# variable names, but must come from the official Census variable name list. Level must 
# be 'county' or 'tract' in quotes. Tract, county and state are default to all which will 
# return either all states, all counties or all tracts depending on which level is specified. 
# Otherwise, must be specific FIPS codes. 


CreateCensusURl <- function(year, vars, tract=all, county=all, state=all, level='county', key){
  query_url <- ''
  varstring <- stringr::str_c(vars, collapse = ',')
  if (tract==all){tract <- '*'} else {tract <- stringr::str_c(tract, collapse','}
  if (county==all){county <- '*'} else {county <- stringr::str_c(county, collapse=','}
  if (state==all){state <- '*'} else {state <- state}
  query_url <- paste0('http://api.census.gov/data/', year, '/sf1?get=', varstring, '&for=', level, '&in=state:', state, '&in=county:', county '&key=', key)
  return(query_url)
}