# Geoscience Thesis & Projects Interactive Map (v1.1) 🌍

An R Shiny web application designed to visualize and filter thesis and project sampling locations from the Geoscience bachelor major at Ikiam University (Ecuador). Users can explore sample locations interactively on a map, apply dynamic filters, and download the filtered data as a table.

## 📺 Live Demo

The app is deployed on **Posit Connect Cloud** (free tier):

**https://01a09faf-a564-d2f0-0f1e-9406108b2428.share.connect.posit.cloud**

## ✨ Features

- **Interactive Mapping:** Uses Leaflet to display sample locations with rich popups showing Author, Sample Type, Subject, Year, Email, and Phone.
- **Province Boundaries:** Ecuador's 24 provinces are drawn as reference boundaries with hover tooltips showing province names.
- **Dynamic Filtering:** Users can filter the dataset in real time by:
  - **Year Range:** Slider to select specific years of interest.
  - **Kind of Work:** Checkboxes for "Thesis" or "Project".
  - **Subjects:** Checkboxes for Geochemistry, Volcanology, Geophysics, and Sedimentology.
  - **Sample Type:** Checkboxes for Sediment, Rock, or Hydrocarbon.
- **Auto-Centering Map:** The view automatically fits all visible points based on the current filters.
- **"Default View" Button:** A floating button lets users reset the map to the filter-based perspective after zooming into a specific province.
- **Data Table & Export:** A dynamic DataTable tab that updates with the filters and allows downloading as CSV, Excel, or PDF.
- **Base Map Switcher:** Toggle between Street Map (OSM), Satellite (Esri), and Terrain (OpenTopoMap).

## 🛠️ Technologies Used

- **R** — Core programming language.
- **Shiny** — Web application framework.
- **Leaflet (R)** — Interactive maps.
- **sf (Simple Features)** — Spatial data handling and coordinate transformation.
- **dplyr / tidyverse** — Data manipulation and filtering.
- **stringr** — Text processing (extracting author names from emails).
- **DT** — Interactive HTML tables with export buttons.
- **readr** — Reading CSV data sources.

## 📂 Project Structure

```text
Geosience_ThesisProjects_Repository/
├── app.R                                  # Main Shiny application code (UI & Server)
├── data/
│   ├── Thesis_samples.csv                 # Sample database (CSV, UTF-8)
│   └── ecu_adm_adm1_2024_light.geojson    # Simplified Ecuador province boundaries
├── manifest.json                          # Deployment manifest for Posit Connect Cloud
├── .gitignore                             # Git ignore rules (excludes .xlsx, .Rhistory, etc.)
└── README.md                              # Project documentation