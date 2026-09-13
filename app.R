####################### PREAMBLE ############################
# 
# Date:              Monday 19th / December 2022
# Author:            Anderson Guamán 
# Description: 
# This code is aimed to create an interactive map showing the 
# the location of the sampling zones of the thesis in the Geo-sciences
# faculty
#

########################## PACKAGES #################################
library(shiny)          # package to build interactive web apps   
library(tidyverse)      # package for data science / data manipulation
library(sf)             # package to encode spatial vector data 
library(leaflet)        # package to interactive maps
library(readxl)         # read xlsx files

########################### CODE ####################################

geo.db = data.frame(read_xlsx('data/Thesis_samples.xlsx'))
# geo.db = read_csv('Thesis_samples.csv')

ui = fluidPage(                                            # app's visual appearance  
  titlePanel("Research made by the Geoscience career"),     # app's title
  sidebarLayout(                                           # layout of the app
    
    sidebarPanel = sidebarPanel(                           # left app's part for inputs
      
      sliderInput('years', 'Years',                        # code to make a slider ranged bar
                  min=2014, max=2023, 
                  value=c(2016, 2020)),
      
      selectInput("select", label=("Kind of work"),        # code to make a select box
                  choices = list("Thesis"="thess", "Project"="proj"),
                  selected = "thess"),

      checkboxGroupInput("variableSub", "Subjects to show:",  # code to make a group of check boxes
                         c("Geochemistry" = "gch",
                           "Volcanology" = "vol",
                           "Geophysics" = "gph",
                           "Sedimentology" = "sed"),
                         selected = c("gch", "vol", "gph", "sed")),

      checkboxGroupInput("variableSam", "Sample type:",  # code to make a group of check boxes
                         c("Sediments" = "qsed",
                           "Rocks" = "rock",
                           "Hydrocarbon" = "hcar"),
                         selected = c("qsed", "rock", "hcar")),
      
    ),                         
    
    mainPanel = mainPanel(                                # right side for outputs
      leafletOutput(outputId = 'map')                     # map created by leaflet
    )                                
    
  )                                          
)                            

server = function(input, output) {                         # interactive logic code 
  
  map_df = reactive({
    geo.db %>% 
      filter(Date_work > input$years[1] & Date_work < input$years[2]) %>%
      st_as_sf(coords = c('longitude', 'latitude')) %>% 
      st_set_crs(4326)
  })
  
  # awesome <- makeAwesomeIcon(
  #   icon = "info",
  #   iconColor = "black",
  #   markerColor = "blue",
  #   library = "fa"
  # )
  
  output$map = renderLeaflet({
    leaflet() %>%
      addTiles()  %>%        # add default OpenStreetMap map tiles 
      addProviderTiles("Esri.WorldImagery", group="ESRI") %>%
      addProviderTiles("Stamen.TerrainBackground", group="Stamen") %>%
      addLayersControl(baseGroups=c("OMS", "ESRI", "Stamen")) %>%
      setView(lng = -78.7000545, lat = -1.419271, zoom = 6) %>%
      addCircleMarkers(data=map_df(), 
                       popup=~as.character(Author))
      # addMarkers(data=map_df(), popup = ~as.character(Author))
      # addAwesomeMarkers(data=map_df(), 
      #                   icon=awesomeIcons(icon='ion-ionic', 
      #                                     library='ion', 
      #                                     markerColor = 'red'))
      # addAwesomeMarkers(data = map_df(), icon = awesome,
      #                   popup = ~as.character(Author))
  })
  
}

shinyApp(ui, server)                                       # command to run the app
