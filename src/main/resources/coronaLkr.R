# Title     : TODO
# Objective : TODO
# Created by: bf
# Created on: 19.10.20
library(dplyr)
library(tidyr)

corona_de <- read.csv("/home/bf/Dokumente/FabLab/Software/corona-rest-api/src/main/resources/RKI_COVID19_1910.csv",header = TRUE)

#Landkreis Miesbach
#corona_mb <- read.csv("/home/bf/Dokumente/InterFace/Data-Science/RKI_COVID19_MB.csv",header = TRUE)
corona_lkr <- corona_de[grepl(landkreisId, corona_de$IdLandkreis),]
corona_lkr_nach_datum <- data.frame()
corona_lkr_nach_datum <- corona_lkr %>% group_by(Refdatum) %>% tally(wt=AnzahlFall)
corona_lkr$Datum <- as.Date(corona_lkr$Refdatum)
# Neue Spalte Datum, die das Meldedatum parst
corona_lkr_nach_datum$Datum <- as.Date(corona_lkr_nach_datum$Refdatum)
# Fehlende Tage in der Serie ergänzen
#corona_mb_nach_datum <- complete(corona_mb_nach_datum, Datum = seq.Date(min(Datum), max(Datum), by="day")) # %>% fill(`Zahl der Fälle`)
#Spalte n nach "Zahl der Fälle" umbenennen
colnames(corona_lkr_nach_datum)[colnames(corona_lkr_nach_datum)=="n"] <- "Zahl der Fälle"
# Alle NAs mit 0 ersetzen
corona_lkr_nach_datum$`Zahl der Fälle`[is.na(corona_lkr_nach_datum$`Zahl der Fälle`)] <- 0

for(i in 1:nrow(corona_lkr_nach_datum)){
  cur_datum <- corona_lkr_nach_datum[i,]
  result$faelleFuerLandkreis$put(as.character(cur_datum$Datum),as.integer(cur_datum$`Zahl der Fälle`))
}
# Tabelle zurückgeben
#corona_landkreis <- data.frame(Datum=as.character(corona_lkr_nach_datum$Datum), Fälle=as.character(corona_lkr_nach_datum$`Zahl der Fälle`))
result