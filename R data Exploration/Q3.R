#Q3

library(readr)
library(dplyr)
library(magrittr)
library(ggplot2) 
library(tidyverse)
library(pryr)
library(sqldf)

#reading data files (since all are comma separated, using read_csv)
unzip('DublinBusGTFS.zip')
trips <- read_csv("trips.txt")
routes <- read_csv("routes.txt")
stop_times <- read_csv("stop_times.txt", col_types= cols(arrival_time = col_character(), departure_time = col_character()))
shapes<-read_csv("shapes.txt")

#3.1- Shaping data and Exploratory Analysis
MergedData <- stop_times %>% left_join(trips) %>% left_join(routes) %>%
  select(route_id, route_short_name, trip_id, stop_id, service_id, arrival_time, departure_time, direction_id, stop_sequence)

#Number of stops and Trips in routes by direction
stops_in_route<-sqldf("select route_short_name, direction_id, max(stop_sequence) as Number_of_Stops, count(service_id) as Total_Trips from MergedData group by route_short_name, direction_id")
View(stops_in_route)

#3.2- Bus Route-1 More detailed analysis
route1_detail <- MergedData %>% 
  filter(route_short_name == 1)

#mutating for making the time as whole integer
route1_detail <- route1_detail %>% 
  mutate(
    arrival_time = ifelse(
      as.integer(substr(arrival_time, 1, 2)) < 24,
      as.integer(substr(arrival_time, 1, 2)),
      as.integer(substr(arrival_time, 1, 2)) - 24),
    departure_time = ifelse(
      as.integer(substr(departure_time, 1, 2)) < 24,
      as.integer(substr(departure_time, 1, 2)),
      as.integer(substr(departure_time, 1, 2)) -24)
  )

#selecting the number of buses in every hour for every service and every route
buses_route1 <- route1_detail %>% select(route_id,route_short_name, service_id, direction_id, arrival_time)%>%
  group_by(arrival_time,direction_id, service_id) %>% 
  count(arrival_time)

ggplot(data=buses_route1, aes(x= arrival_time, y=n ,fill=interaction(direction_id,service_id)))+geom_bar(stat="identity")+scale_x_continuous(breaks = seq(6, 23, by = 1))
