#Q1

library(readr)
library(dplyr)
library(magrittr)
library(reshape2)
library(ggplot2) 

#Reading Data frame
Climatechange<-read.csv('noaa_aggi_forcing.csv', check.names=FALSE)

#Imputing Missing value
avgAGGI<- mean( as.numeric(Climatechange$`AGGI % change *`) [  !is.na( Climatechange$`AGGI % change *`)])
Climatechange$`AGGI % change *` <- ifelse(is.na(Climatechange$`AGGI % change *`), as.numeric(avgAGGI), Climatechange$`AGGI % change *`)
View(Climatechange)

#selecting required data for plotting
df <- Climatechange %>%
  select(Year, CO2, CH4, N2O, CFC12, CFC11, `15-minor`, Total, `AGGI % change *`) %>% group_by(Year)

meltedClimateChange<-melt(df, id="Year")

#Plot
qplot(data=meltedClimateChange, x=Year, y=value, colour=variable, geom=c('point','smooth'), ylab='% increase in levels')
