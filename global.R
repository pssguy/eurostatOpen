library(eurostat)
library(dplyr)
library(DT)
library(rgdal)
library(readr)
library(ggplot2)
library(scales)
library(shiny)
library(shinydashboard)
library(leaflet)
library(stringr)

# restricted countries
countries <- read_csv("euCountries.csv")

# standard map data for world
mapData <- readOGR(dsn=".",
                   layer = "ne_50m_admin_0_countries", 
                   encoding = "UTF-8",verbose=FALSE)

