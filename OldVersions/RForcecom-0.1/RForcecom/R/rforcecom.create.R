rforcecom.create <-
function(session, objectName, fields){
 # Create XML
 xmlElem <- ""
 for(i in 1:length(fields)){
  fieldValue <- iconv(fields[i], from="", to="UTF-8")
  xmlElem <- paste(xmlElem, "<", names(fields[i]), ">",fieldValue ,"</", names(fields[i]), ">",sep="")
 }
 xmlBody <- paste("<?xml version=\"1.0\" encoding=\"UTF-8\"?><root>", xmlElem, "</root>", sep="")
 
 # Send records
 h <- basicTextGatherer()
 endpointPath <- rforcecom.api.getObjectEndpoint(session['apiVersion'], objectName)
 URL <- paste(session['instanceURL'], endpointPath, sep="")
 OAuthString <- paste("OAuth", session['sessionID'])
 httpHeader <- c("Authorization"=OAuthString, "Accept"="application/xml", 'Content-Type'="application/xml")
 curlPerform(url=URL, httpheader=httpHeader, writefunction = h$update, ssl.verifypeer=F, postfields=xmlBody)
 
 # Parse XML
 xdf <- xmlToDataFrame(getNodeSet(xmlParse(h$value()),'//Result'))
 return(xdf)
}

