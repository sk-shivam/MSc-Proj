library(readr)
library(dplyr)
library(magrittr)
library(reshape2)
library(ggplot2)
library(readODS)

#getting number of sheets which will be used in loop
sheetnum<-(get_num_sheet_in_ods('Footfall2013.ods'))

#defining two null dataset to capture data of two cameras
Footfall1<-data.frame(NULL)
Footfall2<-data.frame(NULL)

#importing data from both cameras across all weeks into these dataframes
for (i in 1:sheetnum)
{
  weeks1<-read_ods("Footfall2013.ods", sheet=i, range="B7:O30", col_names = F)
  Footfall1<-rbind(Footfall1,weeks1)
  weeks2<-read_ods("Footfall2013.ods", sheet=i, range="B35:O58", col_names = F)
  Footfall2<-rbind(Footfall2,weeks2)
}

#Defining column Names
columns<-c("mon_in", "mon_out", "tue_in", "tue_out", "wed_in", "wed_out","thu_in",
          "thu_out", "fri_in", "fri_out", "sat_in", "sat_out","sun_in", "sun_out")
colnames(Footfall1)<-columns
colnames(Footfall2)<-columns

#coverting the column types to numeric
Footfall1 <- mutate_all(Footfall1, function(x) as.numeric(as.character(x)))
Footfall2 <- mutate_all(Footfall2, function(x) as.numeric(as.character(x)))

#Average footfall for all day
Cam1<-colMeans(Footfall1, na.rm=TRUE)
Cam2<-colMeans(Footfall2, na.rm=TRUE)

RowName<-row.names(as.data.frame(Cam1))
MeanCams<-data.frame(Cam1,Cam2,RowName)

MeanCams<-MeanCams %>% mutate_at(vars(Cam1, Cam2), funs(round(., 0)))

#plotting the average for all days for both cams
MeanCams<-melt(MeanCams)
MeanCams$AverageFootfalls<-MeanCams$value
ggplot(data=MeanCams, aes(x= RowName, y=AverageFootfalls ,fill=variable))+geom_bar(stat="identity", position='dodge')+theme(axis.text.x = element_text(angle = 90, hjust = 0.5))
