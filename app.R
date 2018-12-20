rm(list = ls())
library(httr)
library(jsonlite)
library(lubridate)
library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = HTML(paste("NASA Photo",'   ',icon("space-shuttle"))),
                  dropdownMenuOutput("messageMenu")
  ),
  dashboardSidebar( 
    sidebarMenu(
      dateInput("date", label = h3("Select Date:"), value = Sys.Date()),
      actionButton("go","Lift Off")
    )
  ),
  dashboardBody(
    #tabItems(
    # First tab content
    #tabItem(
    tabName = "dashboard",
    fluidRow(
      column(5,h3(uiOutput("title")))),
    fluidRow(column(2,uiOutput("picture")),
             br()
             
             #box(
             #title = "Controls",
             #sliderInput("slider", "Number of observations:", 1, 100, 50)
             #)
    ),
    fluidRow(column(10,p(uiOutput("explanation"))))
    # )
    #)
  )
)



#Server logic
server <- function(input, output, session) { 

  #today = Sys.Date()
  date <- eventReactive(input$go,{
    input$date
  })


  
  output$title <- renderText({
    url  <- paste('https://api.nasa.gov/planetary/apod?date=',date(),'&api_key=EYkE3mXri28G7MVbslzACgDkcMtQIDoTq4jA6c6K',sep='')
    #path <- "eurlex/directory_code"
    response <- GET(url)
    body<-content(response,'text', encoding = "UTF-8")
    body<-fromJSON(body)
    mytitle <- body$title
    myexplanation <- body$explanation
    myimage <- body$url
    mytitle
  })
  output$picture <-  renderUI({
    url  <- paste('https://api.nasa.gov/planetary/apod?date=',date(),'&api_key=EYkE3mXri28G7MVbslzACgDkcMtQIDoTq4jA6c6K',sep='')
    #path <- "eurlex/directory_code"
    response <- GET(url)
    body<-content(response,'text', encoding = "UTF-8")
    body<-fromJSON(body)
    mytitle <- body$title
    myexplanation <- body$explanation
    myimage <- body$url
    tags$img(src = myimage)
  })
  output$explanation <- renderText({
    url  <- paste('https://api.nasa.gov/planetary/apod?date=',date(),'&api_key=EYkE3mXri28G7MVbslzACgDkcMtQIDoTq4jA6c6K',sep='')
    #path <- "eurlex/directory_code"
    response <- GET(url)
    body<-content(response,'text', encoding = "UTF-8")
    body<-fromJSON(body)
    mytitle <- body$title
    myexplanation <- body$explanation
    myimage <- body$url
    myexplanation
  })
 
}

# Run the app ----
shinyApp(ui = ui, server = server)



