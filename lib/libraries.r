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

library(openxlsx)
library(gsubfn)
library(tmap)
library(shiny)

options(gsubfn.engine="R")

# Uvozimo funkcije za pobiranje in uvoz zemljevida.
source("lib/uvozi.zemljevid.r", encoding="UTF-8")
