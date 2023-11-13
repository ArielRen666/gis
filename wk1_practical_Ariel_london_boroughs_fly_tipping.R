install.packages(c("sf", "tmap", "tmaptools", "RSQLite", "tidyverse"), 
                 repos = "https://www.stats.bris.ac.uk/R/")
library(sf)
# change this to your file path!!!
shape<-st_read("D:/CASA_work_Ariel/CASA0005-gis/GIS_homework/week1-231004 GIS practical/001课堂案例 London/statistical-gis-boundaries-london/ESRI/London_Borough_Excluding_MHW.shp")
summary(shape)
plot(shape)
library(sf)
shape %>%
  st_geometry() %>%
  plot()
library(tidyverse)
#this needs to be your file path again
mycsv<-read_csv("D:/CASA_work_Ariel/CASA0005-gis/GIS_homework/week1-231004 GIS practical/fly-tipping-borough_edit1.csv")
mycsv
shape <- shape%>%
  merge(.,
        mycsv,
        by.x="GSS_CODE", 
        by.y="Row Labels")
shape%>%
  head(., n=10)
library(tmap)
tmap_mode("plot")
# change the fill to your column name if different
shape %>%
  qtm(.,fill = "2011-12", fill.breaks=c(0,100,1000,5000,10000,15000,20000))+tm_layout(legend.outside = 1)
tm_legend(legend.title.size = 1.5, legend.text.size = 1.2) # Increase font sizes
tm_layout(legend.width = 1.0) # Increase the width of the legend

shape %>%
  st_write(.,"D:/CASA_work_Ariel/CASA0005-gis/GIS_homework/week1-231004 GIS practical/Rwk1.gpkg",
           "london_boroughs_fly_tipping",
           delete_layer=TRUE)

library(readr)
library(RSQLite)

con <- dbConnect(RSQLite::SQLite(),dbname="D:/CASA_work_Ariel/CASA0005-gis/GIS_homework/week1-231004 GIS practical/Rwk1.gpkg")

con %>%
  dbListTables()

con %>%
  dbWriteTable(.,
               "original_csv",
               mycsv,
               overwrite=TRUE)
# disconnect from it
con %>% 
  dbDisconnect()
