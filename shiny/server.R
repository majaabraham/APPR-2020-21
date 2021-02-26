library(shiny)

shinyServer(function(input, output) {
  
  rv <- reactiveValues(drzava = "EU28",
                       st_skup = "skupaj",
                       spol= "skupaj")
  
  observeEvent(input$gumb, { rv$drzava <- input$izbira_drzave
                             rv$st_skup <- str_remove(input$starostna_skupina, " let" )
                             rv$spol <- input$spol })
  
  output$pogostost <- renderPlot({
    
    tabela <- pogostost %>% 
      filter(spol == rv$spol, drzava == rv$drzava, `starostna skupina` == rv$st_skup)
    
    ggplot(tabela, aes(x=leto, y=odstotek, fill=pogostost)) +
      geom_col() +
      geom_text(aes(label=odstotek), position = "stack") +
      scale_fill_brewer(palette = "Oranges", name="Št. opravljenih spletnih nakupov \n v treh mesecih") +
      labs(title = "Pogostost spletnega nakupovanja") +
      ylim(0,100)
    })
  
  output$vrsta <- renderPlot({
    
    tabela <- vrsta.blaga %>%
      filter(spol == rv$spol, drzava == rv$drzava, `starostna skupina` == rv$st_skup)
    
    ggplot(tabela, aes(x=leto, y=odstotek, col=`vrsta blaga`)) +
      geom_line() +
      scale_color_brewer(palette = "Paired") +
      labs(title = "Odstotek kupcev, ki so kupili posamezno vrsto blaga po letih") +
      scale_x_continuous(breaks=seq(2010, 2019, 1))
  })
  
  output$vrednosti <-renderPlot({
    
    tabela <- urejene_vrednosti %>%
      filter(spol == rv$spol, drzava == rv$drzava, `starostna skupina` == rv$st_skup)
    
    ggplot(tabela, aes(x=leto, y=odstotek, fill=vrednost)) +
      geom_col(position = "fill") +
      geom_text(aes(label=odstotek), position = "fill") +
      scale_fill_brewer(name= "vrednost (EUR)", palette = "Reds") +
      ylab("delež") +
      labs(title="Vrednosti spletnih nakupov v obdobju treh mesecev")
  })
  
  
  output$izvor <- renderPlot({
    
    tabela <- izvor %>%
      filter(spol == rv$spol, drzava == rv$drzava, `starostna skupina` == rv$st_skup)
    
    ggplot(tabela, aes(x=leto, y=odstotek, col=prodajalec)) + 
      geom_line() +
      scale_x_continuous(breaks=seq(2010, 2019, 1)) +
      labs(title = "Odstotek kupcev, ke je kupoval od posamezne skupine prodajalcev") +
      ylim(0,100)
  })
  
  output$tezave <- renderPlot({
    
    tabela <- tezave %>%
      filter(drzava == rv$drzava)
    
    ggplot(tabela, aes(x=leto, size=odstotek, y=tezava)) + 
      geom_point() + 
      theme(axis.text.x = element_text(angle = 90), legend.position = "top")+
      scale_x_continuous(breaks=seq(2010, 2019, 1)) +
      scale_size_continuous(limits = c(1,37))+
      ylab("težave")
    
  })

})
