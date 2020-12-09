# Analiza podatkov s programom R, 2020/21
**Maja Abraham**

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2020/21

* [![Shiny](http://mybinder.org/badge.svg)](http://mybinder.org/v2/gh/majaabraham/APPR-2020-21/master?urlpath=shiny/APPR-2020-21/projekt.Rmd) Shiny
* [![RStudio](http://mybinder.org/badge.svg)](http://mybinder.org/v2/gh/majaabraham/APPR-2020-21/master?urlpath=rstudio) RStudio

## Analiza spletnih nakupov posameznikov v EU

Nakupovanje v spletnih trgovinah postaja vedno bolj priljubljeno, zato sem se odločila za analizo podatkov o spletnem nakupovanju v državah EU. Zanimajo me predvsem pogostost omenjenega načina nakupovanja v posameznih državah EU, nakupovalne navade posameznikov, ki kupujejo/ naročajo na spletu ter težave, ki se pojavijo pri spletnih nakupih. Pozorna bom tudi na gibanje opazovanih podatkov skozi čas ter morebitne povezave, ki se pojavijo med njimi npr. kako so povezani pogostost spletnega nakupovanja in številčnost težav, ki se pri tem pojavijo, katere starostne skupine kupujejo več in katere izdelke... 

Večino podatkov sem pridobila iz spletne strani [Eurostat](https://ec.europa.eu/eurostat). Izvozila sem podatke v različnih formatih (CSV, HTML, XLS). Pri tem sem uporabila naslednje tabele:

* Spletni nakupi posameznikov: https://ec.europa.eu/eurostat/databrowser/view/isoc_ec_ibuy/default/table?lang=en
* Težave, s katerimi se srečujejo posamezniki pri nakupu / naročilu prek interneta: https://ec.europa.eu/eurostat/databrowser/view/isoc_ec_iprb/default/table?lang=en

Na spletni strani https://www.webretailer.com/b/online-marketplaces-europe/ se nahaja tabela o najbolj priljubljenih spletnih trgovinah v Evropi.


**Tabele:**
1. tabela: Podatki o zadnjem spletnem nakupu za posamezno leto, v odstotkih populacije
* leto, država, spol, starostna skupina, zadnji spletni nakup, odstotek

2. tabela: Pogostost nakupovanja po spletu, obdobje 3. mesecev, v odstotkih populacije
* leto, država, spol, starostna skupina, pogostost nakupa, odstotek

3. tabela: Podatki o vrstah blaga/storitve spletnih nakupov, v odstotkih kupcev
* leto, država, starostna skupina, vrsta blaga/ storitve, odstotek

4. tabela: Vrednosti spletnih nakupov, v odstotkih kupcev
* leto, država, spol, starostna skupina, vrednost, odstotek

5. tabela: Podatki o spletnih nakupih glede na izvor prodajalca, v odstotkih kupcev
* leto, država, spol, starostna skupina, izvor prodajalca, odstotek

6. tabela: Pogostost težav, ki jih imajo kupci pri spletnem nakupovanju, v odstotkih kupcev
* leto, država, težava, odstotek

8. tabela: Najbolj priljubljene spletne trgovine v evropi
* trgovina, regija/država, št. obiskov/mesec, enota

## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`.
Ko ga prevedemo, se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`.
Podatkovni viri so v mapi `podatki/`.
Zemljevidi v obliki SHP, ki jih program pobere,
se shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `rgdal` - za uvoz zemljevidov
* `rgeos` - za podporo zemljevidom
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `readr` - za branje podatkov
* `rvest` - za pobiranje spletnih strani
* `tidyr` - za preoblikovanje podatkov v obliko *tidy data*
* `dplyr` - za delo s podatki
* `gsubfn` - za delo z nizi (čiščenje podatkov)
* `ggplot2` - za izrisovanje grafov
* `mosaic` - za pretvorbo zemljevidov v obliko za risanje z `ggplot2`
* `maptools` - za delo z zemljevidi
* `tmap` - za izrisovanje zemljevidov
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)

## Binder

Zgornje [povezave](#analiza-podatkov-s-programom-r-202021)
omogočajo poganjanje projekta na spletu z orodjem [Binder](https://mybinder.org/).
V ta namen je bila pripravljena slika za [Docker](https://www.docker.com/),
ki vsebuje večino paketov, ki jih boste potrebovali za svoj projekt.

Če se izkaže, da katerega od paketov, ki ji potrebujete, ni v sliki,
lahko za sprotno namestitev poskrbite tako,
da jih v datoteki [`install.R`](install.R) namestite z ukazom `install.packages`.
Te datoteke (ali ukaza `install.packages`) **ne vključujte** v svoj program -
gre samo za navodilo za Binder, katere pakete naj namesti pred poganjanjem vašega projekta.

Tako nameščanje paketov se bo izvedlo pred vsakim poganjanjem v Binderju.
Če se izkaže, da je to preveč zamudno,
lahko pripravite [lastno sliko](https://github.com/jaanos/APPR-docker) z želenimi paketi.

Če želite v Binderju delati z git,
v datoteki `gitconfig` nastavite svoje ime in priimek ter e-poštni naslov
(odkomentirajte vzorec in zamenjajte s svojimi podatki) -
ob naslednjem zagonu bo mogoče delati commite.
Te podatke lahko nastavite tudi z `git config --global` v konzoli
(vendar bodo veljale le v trenutni seji).
