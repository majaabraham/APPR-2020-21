# 3. faza: Vizualizacija podatkov

# pomožne vizualizacije

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

EU <- uvozi.zemljevid("https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                      "ne_50m_admin_0_countries",
                      encoding = "UTF-8")
eu <- c("Belgium",
        "Bulgaria",
        "Czechia",
        "Denmark",
        "Germany",
        "Estonia",
        "Ireland",
        "Greece",
        "Spain",
        "France",
        "Croatia",
        "Italy",
        "Cyprus",
        "Latvia",
        "Lithuania",
        "Luxembourg",
        "Hungary",
        "Malta",
        "Netherlands",
        "Austria",
        "Poland",
        "Portugal",
        "Romania",
        "Slovenia",
        "Slovakia",
        "Finland",
        "Sweden"
)


vsi.nakupi <- pogostost %>%
  filter(drzava !="EU28", spol == "skupaj", `starostna skupina` == "skupaj", leto == 2019) %>%
  group_by(drzava) %>% 
  summarise(skupaj.kupci = sum(odstotek)) 

intervali <- quantile(vsi.nakupi$skupaj.kupci, seq(0,1,1/5))

nakupi <- vsi.nakupi%>%
  mutate(
    delitev = factor(findInterval(skupaj.kupci, intervali, all.inside = TRUE))
  )
  
legenda <- paste(as.integer(intervali[1:5]) + c(0,1,0,1,1), as.integer(intervali[2:6]) + c(0,-1,0,0,0), sep = " - ")

paleta1 <- brewer_pal(type = "seq", palette = "Oranges") (5)

url <- "https://sl.wikipedia.org/wiki/Seznam_glavnih_mest_dr%C5%BEav"
stran <- read_html(url, encoding = "UTF-8")

imena.EU <- tezave %>% 
  filter(drzava !="EU28", leto == 2019, tezava == "drugo") %>%
  select(drzava)

glavna.mesta <- stran %>%
  html_nodes(xpath="//table") %>%
  .[[1]] %>%
  html_table(fill = TRUE) %>%
  rename(drzava = 1, 
         mesto = 2
         ) %>% 
  select(drzava, mesto) %>%
  right_join(imena.EU)

#koordinate <- geocode_OSM(glavna.mesta$mesto)

#mesta <- koordinate %>%
#  rename(mesto = 1) %>%
#  select(mesto, lon, lat)
#
#mestaSP <- st_as_sf(mesta,
#                    coords = c("lon", "lat"),
#                    crs = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"
#                    )
#
prevladujoc <- izvor %>% 
  filter(drzava !="EU28", spol == "skupaj", `starostna skupina` == "skupaj", leto == 2019) %>%
  group_by(drzava) %>% summarise(odstotek1=max(odstotek))

zdruzen.prevladujoc <- izvor %>% 
  filter(drzava !="EU28", spol == "skupaj", `starostna skupina` == "skupaj", leto == 2019) %>%
  full_join(prevladujoc)
  
barvanje <- zdruzen.prevladujoc %>%
  mutate(
    razlika = odstotek1 -odstotek
  ) %>% 
  filter(razlika <= 15) %>%
  group_by(drzava) %>% summarise(skupina = str_c(prodajalec, collapse = " in "))

paleta2 <- brewer_pal(type = "div", palette = 9) (4)

