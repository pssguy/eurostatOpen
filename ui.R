

dashboardPage(
  dashboardHeader(title = "Eurostat"),
                   
                  
  dashboardSidebar(
    
    
    sidebarMenu(
      uiOutput("sel_Item"),
      uiOutput("sel_Sector"),
      uiOutput("sel_Unit"),
      
      menuItem("Faceted Plot", tabName = "facet"),
      menuItem("Table", tabName = "table"),

      menuItem("", icon = icon("twitter-square"),
               href = "https://twitter.com/pssGuy"),
      menuItem("", icon = icon("envelope"),
               href = "mailto:agcur@rogers.com")
      
    )
  ),
  dashboardBody(
    tabItems(
      tabItem("facet",
               fluidRow(column(width=10,offset=1,
                box(
                  width=12,status = "info", solidHeader = FALSE,
                  
                  plotOutput("gg")
                  
                )
              )
    )),
    tabItem("table",
            fluidRow(column(width=10,offset=1,
                            box(
                              width=12,status = "info", solidHeader = FALSE,
                              
                              DT::dataTableOutput("table")
                              
                            )
            )
            ))
      
              
    ) # tabItems
  ) # body
) # page
