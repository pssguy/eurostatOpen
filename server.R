
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
      filter(na_item==theSelection&unit==theUnit&sector==theSector) %>% 
      mutate(year=str_sub(time,1,4))
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
  
  ## map
  
  output$map <- renderLeaflet({
    
    print("enter map")
    df <- data.frame(info()$df)
    
    pal <- colorQuantile("Reds", NULL, n = 6)
    
    # create popup
#     names(popData)
#     popData$popUp <- paste0("<strong>",popData$Time,"  ", popData$Country, "</strong><br>",
#                             
#                             "<br><strong>Popuation (m): </strong>", popData$PopTotal,
#                             "<br><strong>Density (per sq Km): </strong>", round(popData$PopDensity))
#     
#     popData$densityRange <-cut(popData$PopDensity,c(0,10,50,100,300,1000,30000))
#     
    print(names(df)) #
    print(sort(names(mapData)))
    
#     print(df$geo)
#     print(unique(mapData$name))
    
    df <- data.frame(df) %>% 
      filter(time=="2014-01-01")
    # now merge with map info
    countries2 <- sp::merge(mapData, 
                            df, 
                            by.x = "name", 
                            by.y = "geo",                    
                            sort = FALSE)
    # In .local(x, y, ...) : 9 records in y cannot be matched to x
    
    print("merge done")
    
    labs <- c("0-9","10-50","50-100","100-300","300-1000","1000-30000","NA")
    
    print(sort(names(countries2)))
   # print(countries2$Country)
    
    leaflet(data = countries2) %>%
      addTiles() %>%
       setView(lng=13,lat=56,zoom= 3) %>% 
      addPolygons(fillColor = ~pal(values), 
                  fillOpacity = 0.6, 
                  color = "#BDBDC3", 
                  weight = 1) %>% 
#                   layerId = ~Country,
#                   popup = countries2$popUp) %>% 
      # addLegend(pal=pal, values = ~densityRange) %>% 
      #     addLegend(#colors = c(RColorBrewer::brewer.pal(6, "YlGnBu"), "#808080"),  
      #               colors = c(RColorBrewer::brewer.pal(6, "Reds"), "#808080"), 
      #               bins = 7, 
      #               position = 'bottomright', 
      #               title = "Density Range", 
      #               labels = labs) %>% 
      mapOptions(zoomToLimits="first")
    
  
  })
  
 
})

