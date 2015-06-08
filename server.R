
shinyServer(function(input, output,session) {
  
  # hard code initially
  data <- label_eurostat_vars(get_eurostat("gov_10dd_edpt1"))
  
  data$unit <- as.character(data$unit)
  data$sector <- as.character(data$sector)
  data$na_item <- as.character(data$na_item)
 # print(glimpse(data))
  
  # create selection options
  output$sel_Unit <- renderUI({
    unitOptions <- sort(unique(data$unit))
    
    selectInput("unit","unit",unitOptions)
  })
  output$sel_Sector <- renderUI({
    sectorOptions <- sort(unique(data$sector))
    
    selectInput("sector","sector",sectorOptions)
  })
  output$sel_Item <- renderUI({
    itemOptions <- sort(unique(data$na_item))
    
    selectInput("item","item",itemOptions)
  })
 
   
  
  info <- reactive({
    theSelection <- input$item
    theUnit <- input$unit
    theSector <- input$sector
    
    df <- data %>% 
      filter(na_item==theSelection&unit==theUnit&sector==theSector) #680 values
    print(glimpse(df))
    
    info=list(df=df,theSelection=theSelection,theUnit=theUnit,theSector=theSector)
    return(info)
  })
  
  ## faceted ggplot
  output$gg <- renderPlot({
   
    # await selection - rob better way
    if(is.null(input$item)) return()
   
    theSelection <- info()$theSelection
    theUnit <- info()$theUnit
    theSector <- info()$theSector
    
#     df <- data %>% 
#       filter(na_item==theSelection&unit==theUnit&sector==theSector) #680 values
#     print(glimpse(df))
    
     info()$df %>% 
      filter(geo %in% countries$country)    %>%
      ggplot(.,aes(x=time,y=values)) + 
      geom_line()+
      ylab(theUnit)+
      facet_wrap(~geo,nrow=4) +
      ggtitle(theSelection) +
      xlab('Year') +
    #  geom_hline(yintercept=60,colour='red') + #only useful if no selection
      scale_x_date(
        breaks=c(as.Date("2000-01-01"),as.Date("2010-01-01") )
        ,labels = date_format("%Y"))
    
    
    
  })
  
  ## datatable
  
  output$table <- DT::renderDataTable({
    print("enter table")
    if(is.null(input$item)) return()
    print(glimpse(info()$df))
    
   info()$df %>% 
    DT::datatable()
  })
  
 
})

