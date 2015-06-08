

dashboardPage(
  dashboardHeader(title = "Eurostat"),
                   
                  
  dashboardSidebar(
    
    
    sidebarMenu(
      menuItem("Summary", tabName = "summary"),

      menuItem("", icon = icon("twitter-square"),
               href = "https://twitter.com/pssGuy"),
      menuItem("", icon = icon("envelope"),
               href = "mailto:agcur@rogers.com")
      
    )
  ),
  dashboardBody(
    tabItems(
      tabItem("summary",
              fluidRow(
                box(
                  width = 4, status = "info", solidHeader = TRUE,
                  title = "selection",
                  uiOutput("sel_Unit"),
                  uiOutput("sel_Sector"),
                  uiOutput("sel_Item")
                  
                ),
                box(
                  width = 8, status = "info", solidHeader = TRUE,
                  title = "results",
                  plotOutput("gg")
                  
                )
              )
              
      )
              
    ) # tabItems
  ) # body
) # page
