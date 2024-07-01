#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session){
    inter_p <- state_year_data %>% dplyr::select(State_Code, YEAR,RATE, 
                                          State_Name) %>% mutate(t = paste0(State_Name, "\n", RATE))
    
    output$mapPlot <- renderPlotly({
        fontStyle = list(
            family = "DM Sans",
            size = 15,
            color = "black")
        
        label = list(
            bgcolor = "#EEEEEE",
            bordercolor = "transparent",
            font = fontStyle
        )
        
        
        lB_graph <- plot_geo(data=filter(inter_p, YEAR == input$year),
                            locationmode = 'USA-states'
                            #frame = ~YEAR
        ) %>%
            add_trace(locations = ~State_Code,
                      z = ~RATE,
                      zmin = 0,
                      zmax = inter_p$RATE,
                      color = ~RATE,
                      colorscale = 'Electric',
                      text = ~t,
                      hoverinfo = 'text') %>%
            layout(geo = list(scope = 'usa'),
                   font = list(family  = "DM Sans"),
                   title = "Percentage of Low Birth Weight Rate Change in USA\n 2014-2021") %>%
            style(hoverlabel = label) %>%
            config(displayModeBar = FALSE) %>%
            colorbar(ticksuffix = "%")
        lB_graph 
    })
    
    
    selectVar <- reactive({
      x_var <- input$Var_X
      y_var <- input$Var_Y
      
      if(x_var != y_var){
        df <- merged_data_scale[,c(input$Var_X, input$Var_Y)]
        df$pc <- predict(prcomp(~df[[1]] + df[[2]], df))[,1]
        
        correlation_coefficient <- cor(df[[1]], df[[2]])
        cor_text <- paste0("Correlation: ", round(correlation_coefficient, 2))
        
        P <- ggplot(data = df, aes(x = df[[1]] , y = df[[2]], color = pc)) +
          geom_point( shape = 16, size = 3, show.legend = FALSE,alpha = .4) + 
          geom_smooth(method=lm, fullrange=TRUE)+
          #stat_cor(p.accuracy = 0.001, r.accuracy = 0.01)+
          theme_minimal()+
          scale_color_gradient(low = "#0091ff", high = "#f0650e")+
          labs(title = "Two Variables Relationship",
               x = input$Var_X,
               y = input$Var_Y)+
          theme(plot.title = element_text(hjust = 0.5, size = 18), 
                  axis.title = element_text(size = 15), 
                  axis.title.y = element_text(angle = 0, vjust = 0.5), 
                  axis.text = element_text(size = 11),
                  legend.position="none")
        
    
        
        P <- P +
          annotate("text", x = Inf, y = -Inf,hjust = 1.3, vjust = 0, label = cor_text, size = 5, color = "black")
        
        
        return(P)
      } else{
        validate(need(FALSE, "Both variables selected are the same. Please choose different variables."))
        return(NULL)
      }
      
    })
  
    
    output$scatterPlot <- renderPlot({
      p = selectVar()
      p
    })
    
   
})
    

