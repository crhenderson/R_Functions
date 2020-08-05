sql.query <- function(filename, odbc.connection.name, silent = TRUE) {
  #Read SQL File
  #Found here: http://stackoverflow.com/a/21344426
  q <- scan(filename, what = 'character', fileEncoding = "UTF-16", sep="\n", quiet = TRUE)
  q <- q[!grepl(pattern = "^\\s*--", x = q)] # remove full-line comments
  q <- sub(pattern = "--.*", replacement="", x = q) # remove midline comments
  q <- paste(q, collapse = " ")
  q <- paste("SET NOCOUNT ON;",q)
  
  #Check for RODBC package.  If not installed, install it.
  if(!"RODBC" %in% installed.packages()[,1]) {
    install.packages("RODBC")
  }
  
  #call RODBC Package
  ## suppressMessages(require(RODBC))  # Removed this part.
  
  #Connect to ODBC connection specified
  obdc.con <- RODBC::odbcConnect(odbc.connection.name)
  
  #Query odbc connection
  data <- RODBC::sqlQuery(obdc.con,q)
  
  #Close odbc connection
  RODBC::close(obdc.con)
  
  #return resulting dataset
  return(data)
  
}
