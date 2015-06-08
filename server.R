
shinyServer(function(input, output,session) {
  
  data <- label_eurostat_vars(get_eurostat("gov_10dd_edpt1"))
  
  data$unit <- as.character(data$unit)
  data$sector <- as.character(data$sector)
  data$na_item <- as.character(data$na_item)
  print(glimpse(data))
  
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
 
 
})

