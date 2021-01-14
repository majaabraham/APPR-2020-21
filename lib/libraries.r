library(readxl)
library(dplyr)
library(readr)
library(tidyr)
library(rvest)
library(stringr)
library(ggplot2)
library(scales)
library(emojifont)
library(knitr)
library(spdplyr)
library(tmap)
library(rmapshaper)
library(tmaptools)
library(sf)

library(gsubfn) 
library(shiny)

options(gsubfn.engine="R")

# Uvozimo funkcije za pobiranje in uvoz zemljevida.
source("lib/uvozi.zemljevid.r", encoding="UTF-8")
