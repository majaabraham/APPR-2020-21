# 2. faza: Uvoz podatkov

sl <- locale("sl", decimal_mark=",", grouping_mark=".")

# vektor držav
drzave <- c("European Union" = "EU28",
            "Belgium" = "Belgija",
            "Bulgaria" = "Bolgarija",
            "Czechia" = "Češka",
            "Denmark" = "Danska",
            "Germany" = "Nemčija",
            "Estonia" = "Estonija",
            "Ireland" = "Irska",
            "Greece" = "Grčija",
            "Spain" = "Španija",
            "France" = "Francija",
            "Croatia" = "Hrvaška",
            "Italy" = "Italija",
            "Cyprus" = "Ciper",
            "Latvia" = "Latvija",
            "Lithuania" = "Litva",
            "Luxembourg" = "Luksemburg",
            "Hungary" = "Madžarska",
            "Malta" = "Malta",
            "Netherlands" = "Nizozemska",
            "Austria" = "Avstrija",
            "Poland" = "Poljska",
            "Portugal" = "Portugalska",
            "Romania" = "Romunija",
            "Slovenia" = "Slovenija",
            "Slovakia" = "Slovaška",
            "Finland" = "Finska",
            "Sweden" = "Švedska"
            )

# vektor zadnjih spletnih nakupov
zadnji <- c("in the last 3 months" = "v zadnjih 3. mesecih",
            "between 3 and 12 months ago" = "med 3. in 12. meseci",
            "in the 12 months" = "v zadnjih 12. mesecih",
            "more than a year ago or never" = "pred več kot letom ali nikoli"
            )

# vektor spolov
spol <- c("All Individuals" = "skupaj",
          "Individuals, 16 to 24 years old" = "skupaj",
          "Individuals, 25 to 54 years old" = "skupaj",
          "Individuals, 55 to 74 years old" = "skupaj",
          "Males, 16 to 24 years old" = "moški",
          "Males 25 to 54 years old" = "moški",
          "Males 55 to 74 years old" = "moški",
          "Females, 16 to 24 years old" = "ženske",
          "Females 25 to 54 years old" = "ženske",
          "Females 55 to 74 years old" = "ženske"
)

# vektor starostnih skupin
starost <- c("All Individuals" = "skupaj",
             "Individuals, 16 to 24 years old" = "16-24",
             "Individuals, 25 to 54 years old" = "25-54",
             "Individuals, 55 to 74 years old" = "55-74",
             "Males, 16 to 24 years old" = "16-24",
             "Males 25 to 54 years old" = "25-54",
             "Males 55 to 74 years old" = "55-74",
             "Females, 16 to 24 years old" = "16-24",
             "Females 25 to 54 years old" = "25-54",
             "Females 55 to 74 years old" = "55-74"
)

# vektor pogostosti spletnega nakupovanja
pogosto <- c("1 or 2 times" = "1-2",
               "3 to 5 times" = "3-5",
               "6 times or more" = "6 ali več"
)

# vektor vrst blaga
vrsta <- c("Food/groceries" = "hrana/\nživila",
           "clothes, sports goods" = "oblačila/\nšportna oprema",
           "household goods" = "oprema doma",
           "films/music or books/magazines/e-learning material or computer software" = 
             "filmi/glasba/\nknjige/revije/\ngradiva za e-učenje/\nračunalniška programska oprema",
           "computer hardware" = "računalniška \nstrojna oprema",
           "electronic equipment" = "elektronska \noprema",
           "shares/insurance/other financial services" = "delnice/\nzavarovanje/\ndruge finančne storitve",
           "tickets for events" = "vstopnice \nza prireditve",
           "travel and holiday accommodation" = "potovalne in \npočitniške nastanitve",
           "medecine" = "zdravila",
           "telecom services" = "telekomunikacijske \nstoritve",
           "others" = "drugo"
           )

# vektor težav
tezave <- c("Difficulties concerning guarantees" = "težave s garancijami",
               "Speed of delivery longer than indicated" = 
                 "hitrost dostave daljša od navedene",
               "Delivery costs or final price higher than indicated" = 
                 "stroški dostave ali končna cena višja od navedene",
               "wrong or damaged good/services delivered" = 
                 "napačno ali poškodovano blago / opravljene storitve",
               "problems with fraud" = "težave z goljufijo",
               "Complaints and redress were difficult or no satisfactory response received after complaint" =
                 "Težave s pritožbami in odškodninami / po pritožbi ni bilo zadovoljivega odgovora",
               "Other" = "drugo"
)

# vektor vrednosti spletnih nakupov
vrednosti <- c("less than 50 euro " = "manj kot 50 EUR",
               "between 50 and 99 euro " = "med 50 in 99 EUR",
               "between 100 and 499 euro " = "med 100 in 499 EUR",
               "between 500 and 999 euro " = "med 500 in 999 EUR",
               "1000 euro or more " = "1000 EUR ali več"
)

# vektor prodajalcev na spletu
prodajalci <- c("from national sellers" = "domači",
               "from sellers from other EU countries" = "iz EU",
               "from sellers from the rest of the world (non-EU)" = "iz drugih držav"
)

# vektor regij
regije <- c("Global" = "globalno",
            "Poland" = "Poljska",
            "Europe" = "Evropa",
            "Netherlands" = "Nizozemska",
            "France" = "Francija",
            "Russia" = "Rusija",
            "Germany" = "Nemčija",
            "Eastern Europe" = "Vzhodna Evropa")

# Funkcija, ki uvozi podatke od pogostosti spletnega nakupovanja
uvozi.pogostost <- function() {
  imena1 <- read_xls("podatki/pogostost_nakupovanja.xls", 
                     col_names = TRUE, 
                     skip = 8) %>%
    names() %>% 
    str_remove("\\.\\.\\..+$")
  
  imena2 <- read_xls("podatki/pogostost_nakupovanja.xls", 
                     col_names = TRUE, 
                     skip = 9) %>%
    names() %>% 
    str_remove("Frequency of online purchases in the last 3 months: ") %>% 
    str_remove("\\.\\.\\..+$")
  
  imena <- bind_cols(imena1, imena2) %>% 
    unite("x...1",sep = ",") %>% 
    t() %>% 
    as.vector()
  # podatek o pogostosti pove številčnost spletnih 
  #nakupov posameznikov v obdobju treh mesecev  
  podatki <- read_xls("podatki/pogostost_nakupovanja.xls",
                      col_names = imena,
                      skip = 10,
                      n_max = 337,
                      na = c(""," ", ":")) %>% 
    rename(drzava=`,GEO`, x=`TIME,IND_TYPE/INDIC_IS`) %>%
    pivot_longer(c(-drzava, -x),
                 names_to = "y",
                 values_to = "odstotek") %>%
    filter(!str_detect(x, "less$|more$")) %>%
    separate(y, into = c("leto", "pogostost"), sep = ",") %>% 
    mutate(
      drzava=str_replace(drzava," \\([^)]*\\)$| \\-* .+",""),
      drzava=drzave[drzava],
      spol=spol[x],
      `starostna skupina`=starost[x],
      leto=parse_integer(leto),
      pogostost=pogosto[pogostost]
    ) %>%
    select(-x) %>%
    filter(leto >= 2016)
  podatki <- podatki[c(2,1,6,5,3,4)]
  
}

# Zapišimo in shranimo podatke v razpredelnico pogostost
pogostost <- uvozi.pogostost() %>%
  write_csv("podatki/pogostost.csv", na = "NA", append = FALSE, col_names = TRUE)

# Funkcija, ki uvozi podatke o zadnjem spletnem nakupu
uvozi.zadnji.nakup <- function() {
  podatki <- read_csv("podatki/podatki_po_zadnjem_nakupu.csv",
                      locale = locale(encoding = "cp1250"),
                      na = c(""," ", ":")) %>% 
             select(-UNIT, -`Flag and Footnotes`) %>% 
             rename(
               leto=TIME, 
               drzava=GEO, 
               `zadnji e-nakup`=INDIC_IS, 
               odstotek=Value) %>%
             filter(!str_detect(IND_TYPE, "less$|more$")) %>%
             mutate(
               `zadnji e-nakup`=str_replace(`zadnji e-nakup`,".+: ",""),
               drzava=str_replace(drzava," \\([^)]*\\)$| \\-* .+",""),
               drzava=drzave[drzava],
               `zadnji e-nakup`=zadnji[`zadnji e-nakup`],
               spol=spol[IND_TYPE],
               `starostna skupina`=starost[IND_TYPE]
               ) %>%
             select(-IND_TYPE) %>%
             filter(`zadnji e-nakup` != "v zadnjih 12. mesecih")
  podatki <- podatki[c(1,3,6,5,2,4)]
}

# Zapišimo in shranimo podatke v razpredelnico zadnji.nakup
zadnji.nakup <- uvozi.zadnji.nakup() %>%
  write_csv("podatki/zadnji.csv", na = "NA", append = FALSE, col_names = TRUE)

# Funkcija, ki uvozi podatke o e-nakupih po vrsti blaga
uvozi.vrsta.blaga <- function() {
  imena1 <- read_xls("podatki/nakupi_po_vrsti_blaga.xls", 
                     col_names = TRUE, 
                     skip = 352) %>%
    names() %>% 
    str_remove("\\.\\.\\..+$")
  
  imena2 <- read_xls("podatki/nakupi_po_vrsti_blaga.xls", 
                     col_names = TRUE, 
                     skip = 353) %>%
    names() %>% 
    str_remove("Online purchases: ") %>% 
    str_remove("\\.\\.\\..+$")
  
  imena <- bind_cols(imena1, imena2) %>% 
    unite("x",sep = ";") %>%
    t() %>% 
    as.vector()
  
  podatki <- read_xls("podatki/nakupi_po_vrsti_blaga.xls",
                      col_names = imena,
                      skip = 354,
                      n_max = 337,
                      na = c(""," ", ":")) %>% 
    rename(drzava=`;GEO`, x=`TIME;IND_TYPE/INDIC_IS`) %>% 
    pivot_longer(c(-drzava, -x),
                 names_to = "y",
                 values_to = "odstotek") %>% 
    filter(!str_detect(x, "less$|more$")) %>%
    separate(y, into = c("leto", "vrsta blaga"), sep = ";") %>% 
    mutate(
      drzava=str_replace(drzava," \\([^)]*\\)$| \\-* .+",""),
      drzava=drzave[drzava],
      spol=spol[x],
      `starostna skupina`=starost[x],
      leto=parse_integer(leto),
      `vrsta blaga`=vrsta[`vrsta blaga`]
    ) %>%
    drop_na(`vrsta blaga`) %>%
    select(-x)
  podatki <- podatki[c(2,1,6,5,3,4)]
}

# Zapišimo in shranimo podatke v razpredelnico vrsta.blaga
vrsta.blaga <- uvozi.vrsta.blaga() %>%
  write_csv("podatki/vrsta.csv", na = "NA", append = FALSE, col_names = TRUE)

# Funkcija, ki uvozi podatke o vrednosti spletnih nakupov
uvozi.vrednosti <- function() {
  tipi <- list(col_number(), 
               col_character(), 
               col_character(),
               col_character(),
               col_character(),
               col_number(),
               col_character())
  
  podatki <- read_csv("podatki/podatki_po_vrednosti_nakupov.csv",
                      locale = locale(encoding = "cp1250"),
                      na = c(""," ", ":"),
                      col_types = tipi) %>%
    filter(!UNIT=="Percentage of individuals", 
           TIME >= 2015, 
           !str_detect(IND_TYPE, "less$|more$")) %>% 
    select(-UNIT, -`Flag and Footnotes`) %>%
    rename(
      leto=TIME, 
      drzava=GEO, 
      vrednost=INDIC_IS,
      odstotek=Value
    ) %>% 
    mutate(
      vrednost=str_replace(vrednost,"Online purchases in the last 3 months for ",""),
      vrednost=str_replace(vrednost, "(\\(.+\\))", ""),
      drzava=str_replace(drzava," \\([^)]*\\)$| \\-* .+",""),
      drzava=drzave[drzava],
      vrednost=vrednosti[vrednost],
      spol=spol[IND_TYPE],
      `starostna skupina`=starost[IND_TYPE]
    ) %>% 
    select(-IND_TYPE)
  podatki <- podatki[c(1,3,6,5,2,4)]
}

# Zapišimo in shranimo podatke v razpredelnico vrednosti
vrednosti <- uvozi.vrednosti() %>%
  write_csv("podatki/vrednosti.csv", na = "NA", append = FALSE, col_names = TRUE)

# Funkcija, ki uvozi podatke o težavah, ki se pojavljajo pri spletnem nakupovanju
uvozi.tezave <- function() {
  podatki <- read_csv("podatki/tezave_pri_nakupih.csv",
                      locale = locale(encoding = "cp1250"),
                      na = c(""," ", ":")) %>%
    select(-UNIT, -`Flag and Footnotes`, -IND_TYPE) %>%
    rename(
      leto=TIME, 
      drzava=GEO, 
      tezava=INDIC_IS,
      odstotek=Value
    ) %>% 
    mutate(
      tezava=str_remove(tezava,".+: "),
      drzava=str_replace(drzava," \\([^)]*\\)$| \\-* .+",""),
      drzava=drzave[drzava],
      tezava=tezave[tezava],
    )
}

# Zapišimo in shranimo podatke v razpredelnico tezave
tezave <- uvozi.tezave() %>%
  write_csv("podatki/tezave.csv", na = "NA", append = FALSE, col_names = TRUE)

# Funkcija, ki uvozi podatke o izvoru prodajalca izdelkov
uvozi.izvor <- function() {
  stran <- read_html("podatki/nakupi_po_izvoru_prodajalca.html", encoding = "UTF-8") %>% 
    html_nodes(xpath="//table") %>% 
    .[[5]] %>% 
    html_table()
  
  imena <- stran %>%
    filter(X1 == "TIMEINDIC_ISGEOIND_TYPE") %>% 
    mutate(X1 = str_replace(X1,"TIMEINDIC_ISGEOIND_TYPE","drzava")) %>% 
    pivot_longer(everything(), names_to = "x", values_to = "y") %>%
    select(y) %>% 
    mutate(y = str_replace(y, "(^20..)", "\\1;")) %>%
    t() %>%
    as.vector()
  
  imena1 <- stran %>% names() %>% t() %>% as.vector()
  
  podatki <- stran %>% 
    filter(!X1 == "TIMEINDIC_ISGEOIND_TYPE") %>% 
    rename_at(vars(imena1), ~ imena) %>% 
    rename(x=TIMEINDIC_ISGEOIND_TYPE) %>% 
    pivot_longer(c(-drzava,-x), names_to="y", values_to="odstotek") %>%
    filter(!str_detect(x, "less$|more$")) %>%
    separate(y, into = c("leto","prodajalec"), sep = ";") %>%
    mutate(
      drzava=str_replace(drzava," \\([^)]*\\)$| \\-* .+",""),
      drzava=drzave[drzava],
      spol=spol[x],
      `starostna skupina`=starost[x],
      prodajalec=str_remove(prodajalec,"Online purchases: "),
      prodajalec=prodajalci[prodajalec],
      leto=parse_number(leto),
      odstotek=str_remove(odstotek,"\\(.+\\)"),
      odstotek=parse_number(odstotek)
    ) %>% 
    select(-x) 
  podatki <- podatki[c(2,1,6,5,3,4)]
}

# Zapišimo in shranimo podatke v reazpredelnico izvor
izvor <- uvozi.izvor() %>%
  write_csv("podatki/izvor.csv", na = "NA", append = FALSE, col_names = TRUE)

# Funkcija, ki uvozi tabelo desetih najbolj obiskanih spletnih trgovin s strani evropejcev
uvozi.top10 <- function() {
  podatki <- read_html("https://www.webretailer.com/b/online-marketplaces-europe/", encoding = "UTF-8") %>% 
    html_nodes(xpath="//table") %>%
    .[[1]] %>% 
    html_table() %>%
    select(-1, -2, -5) %>%
    rename(
      ime = Name,
      `regija / drzava`=`Region/Country`,
      `obiski/mesec`=`European Visits/month`
    ) %>%
    mutate(
      `regija / drzava` = regije[`regija / drzava`],
      `obiski/mesec`=str_replace(`obiski/mesec`,"([:upper:])",";\\1")
    ) %>%
    separate(`obiski/mesec`, into = c("obiski/mesec", "enota"), sep = ";") %>%
    mutate(`obiski/mesec` = parse_number(`obiski/mesec`))
}

# Zapišimo in shranimo podatke v razpredelnico top10
top10 <- uvozi.top10() %>%
  write_csv("podatki/top10.csv", na = "NA", append = FALSE, col_names = TRUE)










# Funkcija, ki uvozi občine iz Wikipedije
uvozi.obcine <- function() {
  link <- "http://sl.wikipedia.org/wiki/Seznam_ob%C4%8Din_v_Sloveniji"
  stran <- html_session(link) %>% read_html()
  tabela <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
    .[[1]] %>% html_table(dec=",")
  for (i in 1:ncol(tabela)) {
    if (is.character(tabela[[i]])) {
      Encoding(tabela[[i]]) <- "UTF-8"
    }
  }
  colnames(tabela) <- c("obcina", "povrsina", "prebivalci", "gostota", "naselja",
                        "ustanovitev", "pokrajina", "regija", "odcepitev")
  tabela$obcina <- gsub("Slovenskih", "Slov.", tabela$obcina)
  tabela$obcina[tabela$obcina == "Kanal ob Soči"] <- "Kanal"
  tabela$obcina[tabela$obcina == "Loški potok"] <- "Loški Potok"
  for (col in c("povrsina", "prebivalci", "gostota", "naselja", "ustanovitev")) {
    if (is.character(tabela[[col]])) {
      tabela[[col]] <- parse_number(tabela[[col]], na="-", locale=sl)
    }
  }
  for (col in c("obcina", "pokrajina", "regija")) {
    tabela[[col]] <- factor(tabela[[col]])
  }
  return(tabela)
}

# Funkcija, ki uvozi podatke iz datoteke druzine.csv
uvozi.druzine <- function(obcine) {
  data <- read_csv2("podatki/druzine.csv", col_names=c("obcina", 1:4),
                    locale=locale(encoding="Windows-1250"))
  data$obcina <- data$obcina %>% strapplyc("^([^/]*)") %>% unlist() %>%
    strapplyc("([^ ]+)") %>% sapply(paste, collapse=" ") %>% unlist()
  data$obcina[data$obcina == "Sveti Jurij"] <- iconv("Sveti Jurij ob Ščavnici", to="UTF-8")
  data <- data %>% pivot_longer(`1`:`4`, names_to="velikost.druzine", values_to="stevilo.druzin")
  data$velikost.druzine <- parse_number(data$velikost.druzine)
  data$obcina <- parse_factor(data$obcina, levels=obcine)
  return(data)
}

# Zapišimo podatke v razpredelnico obcine
obcine <- uvozi.obcine()

# Zapišimo podatke v razpredelnico druzine.
druzine <- uvozi.druzine(levels(obcine$obcina))

# Če bi imeli več funkcij za uvoz in nekaterih npr. še ne bi
# potrebovali v 3. fazi, bi bilo smiselno funkcije dati v svojo
# datoteko, tukaj pa bi klicali tiste, ki jih potrebujemo v
# 2. fazi. Seveda bi morali ustrezno datoteko uvoziti v prihodnjih
# fazah.
