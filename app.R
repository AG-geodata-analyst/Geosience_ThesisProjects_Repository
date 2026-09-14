####################### PREAMBLE ############################
# Date:              Monday 19th / December 2022
# Author:            Anderson Guaman 
# Description: 
# This code creates an interactive map showing the location of
# thesis sampling zones in the Geoscience faculty.

########################## PACKAGES #################################
library(shiny)
library(tidyverse)
library(sf)
library(leaflet)
library(DT)

########################### CODE ####################################

geo.db = read_csv('data/Thesis_samples.csv', show_col_types = FALSE)

# ---- Load province boundaries ----
provincias <- st_read('data/ecu_adm_adm1_2024_light.geojson', quiet = TRUE)

# Auto-detect the province name column
name_candidates <- c("ADM1_ES", "ADM1_EN", "adm1_name", "NAME_1", "name", "shapeName")
prov_name_col <- name_candidates[name_candidates %in% names(provincias)][1]

if (is.na(prov_name_col)) {
  prov_name_col <- names(provincias)[1]
}

# -------- UI --------
ui = fillPage(
  
  tags$style(HTML("
    html, body {
      height: 100%;
      margin: 0;
      padding: 0;
      background-color: #f0f2f5;
      font-family: 'Segoe UI', Tahoma, sans-serif;
    }

    .app-title {
      background-color: #ffffff;
      padding: 15px 25px;
      border-radius: 10px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.08);
      font-size: 20px;
      font-weight: 600;
      color: #2c3e50;
      box-sizing: border-box;
    }

    .sidebar-band {
      background-color: #ffffff;
      padding: 20px;
      border-radius: 10px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.08);
      overflow-y: auto;
      box-sizing: border-box;
      height: 100%;
      display: flex;
      flex-direction: column;
      justify-content: flex-start;
    }

    .map-panel {
      background-color: #ffffff;
      border-radius: 10px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.08);
      overflow: hidden;
      box-sizing: border-box;
      height: 100%;
      display: flex;
      flex-direction: column;
    }

    .map-panel > .tabbable {
      display: flex;
      flex-direction: column;
      height: 100%;
    }

    .map-panel .nav-tabs {
      border-bottom: 1px solid #e5e7eb;
      background-color: #fafbfc;
      padding: 0 15px;
      flex-shrink: 0;
    }

    .map-panel .nav-tabs > li > a,
    .map-panel .nav-tabs .nav-link {
      border: none !important;
      color: #64748b !important;
      font-weight: 500;
      padding: 12px 20px;
      background: transparent !important;
      border-bottom: 2px solid transparent !important;
      border-radius: 0 !important;
    }

    .map-panel .nav-tabs > li > a:hover,
    .map-panel .nav-tabs .nav-link:hover {
      color: #2c3e50 !important;
      border-bottom-color: #cbd5e1 !important;
    }

    .map-panel .nav-tabs > li.active > a,
    .map-panel .nav-tabs .nav-link.active {
      color: #2c3e50 !important;
      font-weight: 600;
      border-bottom: 2px solid #2c3e50 !important;
    }

    .map-panel .tab-content {
      flex: 1;
      min-height: 0;
      position: relative;
    }

    .map-panel .tab-pane {
      height: 100%;
      position: relative;
    }

    .map-wrapper {
      position: relative;
      width: 100%;
      height: 100%;
    }

    .map-panel .leaflet,
    .map-panel .html-widget,
    .map-panel #map {
      width: 100% !important;
      height: 100% !important;
    }

    .map-panel .tab-pane > .datatables,
    .map-panel .tab-pane > div {
      padding: 15px;
      box-sizing: border-box;
      height: 100%;
      overflow: auto;
    }

    /* Space between filter groups */
    .sidebar-band .form-group { margin-bottom: 22px; }

    /* Style all labels */
    .sidebar-band label {
      font-weight: 500;
      color: #34495e;
    }

    /* Group headers (Kind of work, Subjects, Sample type) */
    .sidebar-band .shiny-input-checkboxgroup > label.control-label {
      display: block;
      margin-bottom: 12px;
      font-weight: 600;
    }

    /* Space between individual checkbox options */
    .sidebar-band .shiny-options-group .checkbox {
      margin-top: 0;
      margin-bottom: 6px;
    }

    /* Remove the last option's bottom margin to keep groups tight */
    .sidebar-band .shiny-options-group .checkbox:last-child {
      margin-bottom: 0;
    }

    /* Floating Default View button - bottom-center of the map */
    .default-view-btn {
      position: absolute;
      bottom: 25px;
      left: 50%;
      transform: translateX(-50%);
      z-index: 1000;
      pointer-events: auto;
    }

    .default-view-btn .btn {
      background-color: #2c3e50;
      color: #ffffff;
      border: none;
      padding: 10px 22px;
      border-radius: 24px;
      font-weight: 600;
      font-size: 14px;
      cursor: pointer;
      box-shadow: 0 2px 8px rgba(0,0,0,0.25);
      transition: background-color 0.15s ease, transform 0.15s ease;
    }

    .default-view-btn .btn:hover {
      background-color: #1a252f;
      color: #ffffff;
      transform: translateY(-1px);
    }

    .default-view-btn .btn:active,
    .default-view-btn .btn:focus {
      background-color: #1a252f;
      color: #ffffff;
      transform: translateY(0);
      outline: none;
    }
  ")),
  
  tags$script(HTML("
    function forceLeafletResize() {
      var el = document.getElementById('map');
      if (el && el._leaflet_id) {
        window.dispatchEvent(new Event('resize'));
      }
    }
    window.addEventListener('load', function() {
      setTimeout(forceLeafletResize, 300);
      setTimeout(forceLeafletResize, 800);
    });
    window.addEventListener('resize', function() {
      setTimeout(forceLeafletResize, 200);
    });
    document.addEventListener('click', function(e) {
      var tabLink = e.target.closest('a[data-toggle=\"tab\"], a[data-bs-toggle=\"tab\"]');
      if (tabLink) {
        setTimeout(forceLeafletResize, 250);
        setTimeout(forceLeafletResize, 600);
      }
    });
  ")),
  
  tags$div(
    style = "padding: 20px; height: 100vh; box-sizing: border-box; 
             display: flex; flex-direction: column; gap: 15px;",
    
    tags$div(class = "app-title", "Research made by the Geoscience career"),
    
    tags$div(
      style = "flex: 1 1 auto; display: grid;
               grid-template-columns: 320px 1fr;
               gap: 20px;
               min-height: 0;",
      
      # ---- Sidebar ----
      tags$div(
        class = "sidebar-band",
        
        sliderInput('years', 'Years',
                    min = min(geo.db$Date_work, na.rm = TRUE),
                    max = max(geo.db$Date_work, na.rm = TRUE),
                    value = c(min(geo.db$Date_work, na.rm = TRUE), 
                              max(geo.db$Date_work, na.rm = TRUE)),
                    step = 1),
        
        # Kind of work as checkboxes (matching the other filters)
        checkboxGroupInput("variableType", "Kind of work:",
                           c("Thesis"  = "Thesis",
                             "Project" = "Project"),
                           selected = c("Thesis", "Project")),
        
        checkboxGroupInput("variableSub", "Subjects to show:",
                           c("Geochemistry"  = "Geochemistry",
                             "Volcanology"   = "Volcanology",
                             "Geophysics"    = "Geophysics",
                             "Sedimentology" = "Sedimentology"),
                           selected = c("Geochemistry", "Volcanology", 
                                        "Geophysics", "Sedimentology")),
        
        checkboxGroupInput("variableSam", "Sample type:",
                           c("Sediments"   = "Sediment",
                             "Rocks"       = "Rock",
                             "Hydrocarbon" = "Hydrocarbon"),
                           selected = c("Sediment", "Rock", "Hydrocarbon"))
      ),
      
      # ---- Main panel with tabs ----
      tags$div(
        class = "map-panel",
        
        tabsetPanel(
          id = "main_tabs",
          
          # ---- Tab 1: Map ----
          tabPanel(
            title = "Map",
            value = "map_tab",
            
            tags$div(
              class = "map-wrapper",
              
              leafletOutput(outputId = 'map', height = "100%", width = "100%"),
              
              tags$div(
                class = "default-view-btn",
                actionButton(
                  inputId = "default_view",
                  label   = "Default View"
                )
              )
            )
          ),
          
          # ---- Tab 2: Table ----
          tabPanel(
            title = "Table",
            value = "table_tab",
            DTOutput("filtered_table")
          )
        )
      )
    )
  )
)

# -------- Server --------
server = function(input, output, session) {
  
  map_df = reactive({
    filtered <- geo.db %>% 
      filter(Date_work >= input$years[1] & Date_work <= input$years[2]) %>%
      filter(Type %in% input$variableType) %>%
      filter(Sample.type %in% input$variableSam) %>%
      filter(str_detect(Subject, paste(input$variableSub, collapse = "|")))
    
    if (nrow(filtered) == 0) return(NULL)
    
    result <- filtered %>%
      mutate(
        Author = Email.adress %>%
          str_extract("^[^@]+") %>%
          str_replace_all("\\.", " ") %>%
          str_to_title()
      ) %>%
      st_as_sf(coords = c('longitude', 'latitude')) %>% 
      st_set_crs(4326)
    
    result
  })
  
  table_df = reactive({
    data <- map_df()
    if (is.null(data) || nrow(data) == 0) return(NULL)
    
    coords <- st_coordinates(data)
    
    data %>%
      st_drop_geometry() %>%
      mutate(
        longitude = round(coords[, 1], 5),
        latitude  = round(coords[, 2], 5)
      ) %>%
      select(
        Author, Type, Title, Subject, Sample.type,
        Date_work, Email.adress, Cellphone,
        longitude, latitude, Link.Thesis
      )
  })
  
  default_bounds <- reactiveVal(NULL)
  
  observeEvent(map_df(), {
    data <- map_df()
    if (!is.null(data) && nrow(data) > 0) {
      bbox <- st_bbox(data)
      default_bounds(list(
        lng1 = as.numeric(bbox[["xmin"]]),
        lat1 = as.numeric(bbox[["ymin"]]),
        lng2 = as.numeric(bbox[["xmax"]]),
        lat2 = as.numeric(bbox[["ymax"]])
      ))
    } else {
      default_bounds(NULL)
    }
  }, ignoreNULL = FALSE)
  
  observeEvent(input$default_view, {
    b <- default_bounds()
    if (!is.null(b)) {
      leafletProxy("map", session) %>%
        fitBounds(
          lng1 = b$lng1, lat1 = b$lat1,
          lng2 = b$lng2, lat2 = b$lat2,
          options = list(padding = c(50, 50))
        )
    }
  })
  
  output$filtered_table <- renderDT({
    df <- table_df()
    
    if (is.null(df) || nrow(df) == 0) {
      return(
        datatable(
          data.frame(Message = "No data matches the current filters."),
          rownames = FALSE,
          options = list(dom = 't', ordering = FALSE)
        )
      )
    }
    
    datatable(
      df,
      rownames = FALSE,
      extensions = 'Buttons',
      options = list(
        pageLength = 15,
        dom = 'Bfrtip',
        buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
        scrollX = TRUE,
        autoWidth = TRUE,
        columnDefs = list(
          list(className = 'dt-center', targets = c('Date_work', 'longitude', 'latitude'))
        )
      ),
      filter = 'top'
    )
  })
  
  output$map = renderLeaflet({
    test_data <- map_df()
    
    base_layers <- function(map) {
      map %>%
        addProviderTiles(providers$OpenStreetMap, group = "Street Map") %>%
        addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>%
        addProviderTiles(providers$OpenTopoMap, group = "Terrain") %>%
        addLayersControl(
          baseGroups = c("Street Map", "Satellite", "Terrain"),
          position   = "topright",
          options    = layersControlOptions(collapsed = TRUE)
        )
    }
    
    if (is.null(test_data) || nrow(test_data) == 0) {
      m <- leaflet() %>%
        base_layers() %>%
        addPolygons(
          data        = provincias,
          fillColor   = "transparent",
          fillOpacity = 0,
          color       = "#2c3e50",
          weight      = 1.5,
          opacity     = 0.7,
          highlightOptions = highlightOptions(
            weight       = 3,
            color        = "#e74c3c",
            fillColor    = "#e74c3c",
            fillOpacity  = 0.1,
            bringToFront = TRUE
          ),
          label = provincias[[prov_name_col]],
          labelOptions = labelOptions(
            style     = list("font-weight" = "normal", padding = "3px 8px"),
            textsize  = "13px",
            direction = "auto"
          )
        ) %>%
        setView(lng = -78.5, lat = -1.5, zoom = 6) %>%
        addControl(
          html = "<b>No data matches the current filters.</b>",
          position = "topright"
        )
      return(m)
    }
    
    popups <- paste0(
      "<div style='font-family: sans-serif; font-size: 13px; min-width: 240px;'>",
      "<b style='font-size: 14px; color: #2c3e50;'>", test_data$Title, "</b>",
      "<hr style='margin: 6px 0; border: none; border-top: 1px solid #ddd;'>",
      "<b>Author:</b> ",  test_data$Author,       "<br>",
      "<b>Sample:</b> ",  test_data$Sample.type,  "<br>",
      "<b>Subject:</b> ", test_data$Subject,      "<br>",
      "<b>Year:</b> ",    test_data$Date_work,    "<br>",
      "<b>Email:</b> ",   test_data$Email.adress, "<br>",
      "<b>Phone:</b> ",   test_data$Cellphone,
      "</div>"
    )
    
    bbox <- st_bbox(test_data)
    
    leaflet() %>%
      base_layers() %>%
      addPolygons(
        data        = provincias,
        fillColor   = "transparent",
        fillOpacity = 0,
        color       = "#2c3e50",
        weight      = 1.5,
        opacity     = 0.7,
        highlightOptions = highlightOptions(
          weight       = 3,
          color        = "#e74c3c",
          fillColor    = "#e74c3c",
          fillOpacity  = 0.1,
          bringToFront = TRUE
        ),
        label = provincias[[prov_name_col]],
        labelOptions = labelOptions(
          style     = list("font-weight" = "normal", padding = "3px 8px"),
          textsize  = "13px",
          direction = "auto"
        )
      ) %>%
      addMarkers(
        data  = test_data,
        popup = popups
      ) %>%
      fitBounds(
        lng1 = bbox[["xmin"]],
        lat1 = bbox[["ymin"]],
        lng2 = bbox[["xmax"]],
        lat2 = bbox[["ymax"]],
        options = list(padding = c(50, 50))
      )
  })
}

shinyApp(ui, server)