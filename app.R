rm(list = ls())
library(httr)
library(jsonlite)
library(lubridate)
library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = HTML(paste("NASA Photo",'   ',icon("space-shuttle")))
  ),
  dashboardSidebar( 
    sidebarMenu(
      dateInput("date", label = h3("Select Date:"), value = Sys.Date()),
      actionButton("go","Lift Off")
    )
  ),
  dashboardBody(
    tabName = "dashboard",
    fluidRow(
      column(5,h3(uiOutput("title")))),
    fluidRow(column(2,uiOutput("picture")),
             br()
    ),
    fluidRow(column(10,p(uiOutput("explanation"))))
  )
)



#Server logic
server <- function(input, output, session) { 

  #today = Sys.Date()
  date <- eventReactive(input$go,{
    input$date
  })
  
  output$title <- renderText({
    url  <- paste('https://api.nasa.gov/planetary/apod?date=',date(),'&api_key=myapikey',sep='')
    response <- GET(url)
    body<-content(response,'text', encoding = "UTF-8")
    body<-fromJSON(body)
    mytitle <- body$title
    mytitle
  })
  output$picture <-  renderUI({
    url  <- paste('https://api.nasa.gov/planetary/apod?date=',date(),'&api_key=myapikey',sep='')
    response <- GET(url)
    body<-content(response,'text', encoding = "UTF-8")
    body<-fromJSON(body)
    myimage <- body$url
    tags$img(src = myimage)
  })
  output$explanation <- renderText({
    url  <- paste('https://api.nasa.gov/planetary/apod?date=',date(),'&api_key=myapikey',sep='')
    response <- GET(url)
    body<-content(response,'text', encoding = "UTF-8")
    body<-fromJSON(body)
    myexplanation <- body$explanation
    myexplanation
  })
 
}

# Run the app ----
shinyApp(ui = ui, server = server)



