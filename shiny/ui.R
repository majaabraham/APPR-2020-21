library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Spletni nakupi posameznikov v državah EU"),
  
  
  fluidRow(
    
    column(3, 
           wellPanel(
             selectInput(inputId = "izbira_drzave",
                         label = "Država",
                         choices = append("EU28", as.vector(t(imena.EU)))),
             
             conditionalPanel(condition = "input.tabs != 'tez'",
                              
                              radioButtons(inputId = "starostna_skupina",
                                           label = "Starostna skupina",
                                           choices = c("skupaj", "16-24 let", "25-54 let", "55-74 let")),
                              
                              conditionalPanel(condition = "input.starostna_skupina != 'skupaj'",
                                               radioButtons(inputId = "spol",
                                                            label = "Spol",
                                                            choices = c("skupaj", "moški", "ženske"))
                                               )),
             
             
               actionButton(inputId = "gumb", 
                            label = "Osveži")
             
           )),
    column(9,
           tabsetPanel(
             id = "tabs",
             
             tabPanel("Pogostostost e-nakupovanja",
                      value = "pog",
                      plotOutput("pogostost")),
             
             tabPanel("Vrste blaga/storitev",
                      value = "vrs",
                      plotOutput("vrsta")),
             
             tabPanel("Vrednosti spletnih nakupov",
                      value = "vre",
                      plotOutput("vrednosti")),
             
             tabPanel("Izvor prodajalcev",
                      value = "izv",
                      plotOutput("izvor")),
             
             tabPanel("Težave pri e-nakupovanju",
                      value = "tez",
                      plotOutput("tezave"))
             
           ))
    
  )
))
