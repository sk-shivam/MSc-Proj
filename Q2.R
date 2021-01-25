#Q2

library(readr)
library(dplyr)
library(magrittr)
library(ggplot2) 
library(tidyverse)
library(pryr)
library(httr)
library(sqldf)

#loading data and inspecting
mykey<- 'BBQ36UOKEFW8vyaobEvCeNFs28D7OUr5IBwFC3iy'
URL <- "https://api.data.gov/ed/collegescorecard/v1/schools?"
Data <- GET(URL, query=list(api_key=mykey, school.name="Emory University"))
Collegedata<-content(Data)
names(Collegedata$results[[1]])

#Q2.1- summarising data
#Subsetting data
Data2 <- Collegedata$results[[1]][c(as.character(1996:2013))]

# enrolled student per year
enrol <- Data2 %>%
  sapply(function(x) x$student$size) %>% 
  unlist()

#grad students
grad <- Data2 %>%
  sapply(function(x) x$student$grad_students) %>% 
  unlist()

#part-time students
part_time_count <- Data2 %>%
  sapply(function(x) x$student$part_time_share) %>% 
  unlist()

#single data frame for extracted details over the year
explore2<-data.frame(enrol,grad, part_time_count)

#Adding more descriptive columns (converting part time to percentage)
explore2$Year <- rownames(explore2)
explore2$part_time_count<-round((explore2$part_time_count)*enrol,0)

#explorable data
View(explore2)


#Q2.2 Graphical representation of year, enrollment count and graduate student count
graph2<- sqldf("select Year,enrol, grad from explore2 group by Year")
graph2<-melt(graph2)
View(graph2)

qplot(data=graph2, x=Year, y=value, colour=variable, ylab='Student Count')+theme(axis.text.x = element_text(angle = 90, hjust = 0.5))
