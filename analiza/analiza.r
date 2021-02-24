# 4. faza: Analiza podatkov

# priprava tabel

priprava.podatkov <- function(tabela, stolpec) {
  tabela %>%
    filter(
      drzava !="EU28", 
      spol == "skupaj", 
      `starostna skupina` == "skupaj",
      leto == 2019
    ) %>% 
    select(-`starostna skupina`, -spol, -leto) %>% 
    pivot_wider(names_from = stolpec, values_from = odstotek)
}

pogostost.razvrscanje <- priprava.podatkov(pogostost, "pogostost")

vrednosti.razvrscanje <- priprava.podatkov(vrednosti, "vrednost")

izvor.razvrscanje <- priprava.podatkov(izvor, "prodajalec")
  

podatki.razvrscanje <- pogostost.razvrscanje %>%
  inner_join(vrednosti.razvrscanje) %>%
  inner_join(izvor.razvrscanje) %>%
  select(-drzava) %>% 
  scale()

fviz_nbclust(podatki.razvrscanje, FUN = hcut, method = "wss")
fviz_nbclust(podatki.razvrscanje, FUN = hcut, method = "silhouette")
fviz_nbclust(podatki.razvrscanje, FUN = hcut, method = "gap_stat", nstart=25, nboot=300)

D <- dist(podatki.razvrscanje)
model <- hclust(D)

dnd <- as.dendrogram(model) %>% 
  set("labels",pogostost.razvrscanje$drzava[model$order]) %>% 
  set("leaves_pch", 19) %>%  
  set("leaves_cex", 2) %>%  
  set("leaves_col", "black") %>% 
  set("branches_k_color", 
      value = c("red", "blue"), k = 2) %>% 
  as.ggdend()

dnd$labels$label <- paste(pogostost.razvrscanje$drzava[model$order])
dnd$labels$drzava <- pogostost.razvrscanje$drzava[model$order]








