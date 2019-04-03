library(tidyverse)
library(ggplot2)
#devtools::install_github("dkahle/ggmap")
library(ggmap)


### PRIVATE ###
API_key <- "key" #stored in text file for security
register_google(key = API_key, write = TRUE)


#Set working drive
setwd("C:/github/quadcopter_gps")

#Read in data csv from QX7
gps <- read.csv("super_g-2019-03-29.csv", as.is=T, na.strings=c("","NA"))

#Split GPS string into lat and lon
gps <- gps %>% separate(GPS, c("lat", "lon"), " ", extra = "merge")

#Remove NA GPS points
gps <- gps[!is.na(gps$lat), ]

#Convert coords to numeric
gps$lat <- as.numeric(gps$lat)
gps$lon <- as.numeric(gps$lon)

write.csv(gps, "gps_from_R.csv")

#Map GPS path
base_map <- get_map(location = c(median(gps$lon), median(gps$lat)),
  maptype = "satellite", source = "google", zoom = 15)
ggmap(base_map) + geom_path(data = gps, color="red")
