# 2. faza: Uvoz podatkov

sl <- locale("sl", decimal_mark=",", grouping_mark=".")

# Uvoz pojmov za prevod podatkov
source("uvoz/pojmi.r", encoding="UTF-8")

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
      drzava=str_replace_all(drzava, drzave),
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
      drzava=str_replace_all(drzava, drzave),
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
      drzava=str_replace_all(drzava, drzave),
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
