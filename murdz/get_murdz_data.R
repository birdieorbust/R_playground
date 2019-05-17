library(httr)
library(jsonlite)

#set filepath
filepath<-"data/sse_results.csv"

#initalize empty results
if(file.exists(filepath)){
  results<-read.csv(filepath)
} else {
  results<-data.frame()
}
  
#create function
get_data_for_murdz<-function(results,filepath){
  t<-fromJSON("https://www.ssen.co.uk/Sse_Components/Views/Controls/FormControls/Handlers/ActiveNetworkManagementHandler.ashx?action=graph&contentId=14973")
  
  labels<-t$data$datasets[,1]
  data<-unlist(t$data$datasets$data)
  data<-data[data!=0]
  datetime<-Sys.time()
  t<-data.frame(labels,data,datetime)
  
  results<-rbind(t,results)
  write.csv(results,filepath,row.names = F)
  return(results)
}

#run this script using cron or scheduler to run every second
get_data_for_murdz(results,filepath)
