# Title     : TODO
# Objective : TODO
# Created by: bf
# Created on: 20.10.20
library(dplyr)
#Liste der Landkreise und IDs
corona_de <- read.csv("/home/bf/Dokumente/InterFace/Data-Science/RKI_COVID19.csv",header = TRUE)
landkreise <- data.frame(name=corona_de$Landkreis,id=corona_de$IdLandkreis)
distinct_landkreise <- distinct(landkreise,name,id)
for(i in 1:nrow(distinct_landkreise)){
  cur_lkr <- distinct_landkreise[i,]
  result$landkreise$put(cur_lkr$id,as.character(cur_lkr$name))
}
result