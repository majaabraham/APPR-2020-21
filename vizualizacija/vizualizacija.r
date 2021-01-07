# 3. faza: Vizualizacija podatkov

pogostost %>% filter(spol == "skupaj") %>%
  ggplot(aes(x=leto, y=odstotek, fill=pogostost)) +
    geom_col() +
  facet_grid(drzava~`starostna skupina`) +
  geom_text(aes(label=odstotek), position = "stack")

pogostost %>% filter(spol != "skupaj") %>%
  ggplot(aes(y=odstotek, col=spol, x=leto)) +
  geom_point() +
  geom_boxplot(alpha=I(0.5)) +
  facet_grid(.~pogostost)

zadnji.nakup %>% filter(spol == "skupaj") %>% 
  ggplot(aes(x=leto, y=odstotek, fill=`zadnji e-nakup`)) +
  geom_col() +
  facet_grid(drzava~`starostna skupina`) +
  theme(axis.text.x = element_text(angle = 90))

zadnji.nakup %>% filter(spol == "skupaj", `starostna skupina`== "skupaj") %>% 
  ggplot(aes(x=leto, y=odstotek, col=`zadnji e-nakup`)) +
  geom_point(position = "jitter") +
  geom_boxplot(alpha=I(0.5))

zadnji.nakup %>% filter(spol != "skupaj") %>% 
  ggplot(aes(x=`zadnji e-nakup`,y=odstotek, col=spol)) +
  geom_boxplot()

vrsta.blaga %>% filter(spol=="skupaj") %>% 
  ggplot(aes(x=leto, y=odstotek, col=`vrsta blaga`)) +
  geom_line() +
  scale_color_brewer(palette = "Paired") +
  facet_grid(drzava~`starostna skupina`)

vrsta.blaga %>%  filter(spol != "skupaj") %>%
  ggplot(aes(y=odstotek, col=`vrsta blaga`)) +
  geom_boxplot() +
  scale_color_brewer(palette = "Paired") +
  facet_grid(`starostna skupina`~spol) 

urejene_vrednosti <- vrednosti
urejene_vrednosti$vrednost <- factor(urejene_vrednosti$vrednost,
                                     levels = c("49 ali manj", "50 - 99", "100 - 499 ", "500 - 999", "1000 ali več"))

urejene_vrednosti %>% filter(spol=="skupaj") %>% 
  ggplot(aes(x=leto, y=odstotek, fill=vrednost)) +
  geom_col(position = "fill") +
  facet_grid(drzava~`starostna skupina`) +
  theme(axis.text.x = element_text(angle = 90)) +
  scale_fill_discrete(name= "vrednost (EUR)")

urejene_vrednosti %>% filter(spol!="skupaj") %>% 
  ggplot(aes(x=leto, y=odstotek, col=vrednost)) +
  geom_point(alpha=I(0.5)) +
  facet_grid(spol~`starostna skupina`) +
  theme(axis.text.x = element_text(angle = 90)) +
  scale_fill_discrete(name= "vrednost (EUR)")

urejene_vrednosti %>% filter(spol!="skupaj") %>% 
  ggplot(aes(y=odstotek, col=vrednost)) +
  geom_boxplot() +
  facet_grid(`starostna skupina`~spol) +
  scale_fill_discrete(name= "vrednost (EUR)")

izvor %>% filter(spol=="skupaj") %>% 
  ggplot(aes(x=leto, y=odstotek, col=prodajalec)) + 
  geom_line() +
  facet_grid(drzava~`starostna skupina`) +
  theme(axis.text.x = element_text(angle = 90))

izvor %>% filter(spol!="skupaj") %>% 
  ggplot(aes(y=odstotek, col=prodajalec)) + 
  geom_boxplot() +
  facet_grid(`starostna skupina`~ spol) +
  theme(axis.text.x = element_text(angle = 90))

tezave %>% ggplot(aes(x=leto, size=odstotek, y=tezava)) + 
  geom_point() + 
  facet_wrap(drzava~., ncol = 3) + 
  theme(axis.text.x = element_text(angle = 90), legend.position = "top")
  
tezave %>% ggplot(aes(col=tezava, y=odstotek)) + 
  geom_boxplot() + 
  theme(legend.position = "top")
  

# Uvozimo zemljevid.
zemljevid <- uvozi.zemljevid("http://baza.fmf.uni-lj.si/OB.zip", "OB",
                             pot.zemljevida="OB", encoding="Windows-1250")
# Če zemljevid nima nastavljene projekcije, jo ročno določimo
proj4string(zemljevid) <- CRS("+proj=utm +zone=10+datum=WGS84")

levels(zemljevid$OB_UIME) <- levels(zemljevid$OB_UIME) %>%
  { gsub("Slovenskih", "Slov.", .) } %>% { gsub("-", " - ", .) }
zemljevid$OB_UIME <- factor(zemljevid$OB_UIME, levels=levels(obcine$obcina))

# Izračunamo povprečno velikost družine
povprecja <- druzine %>% group_by(obcina) %>%
  summarise(povprecje=sum(velikost.druzine * stevilo.druzin) / sum(stevilo.druzin))
