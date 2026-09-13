# Thesis Samples Interactive Map (v1.0) 🌍

An R Shiny web application designed to visualize and filter both thesis and projects developed in the Geoscience bachelor major at Ikiam University. This app allows users to explore sample locations interactively on a map and view the underlying data in a downloadable table.

## 📺 Live Demo (Coming Soon)
*Note: R Shiny apps require a server to run. A live deployment link (e.g., via Hugging Face Spaces) will be added here soon.*

## ✨ Features

*   **Interactive Mapping:** Uses Leaflet to display sample locations with popups showing Author, Sample Type, and Table ID.
*   **Dynamic Filtering:** Users can filter the dataset in real-time by:
    *   **Year Range:** A slider to select specific years of interest.
    *   **Kind of Work:** Checkboxes for "Thesis" or "Project".
    *   **Sample Type:** Checkboxes for "Sediment", "Rock", or "Hydrocarbon".
*   **Data Table & Export:** A dynamic DataTable tab that updates based on filters and allows downloading the filtered data as CSV, Excel, or PDF.
*   **Base Map Options:** Switch between OpenStreetMap, ESRI World Imagery, and Stamen Terrain.

## 🛠️ Technologies Used

*   **R** - Core programming language.
*   **Shiny** - Web application framework.
*   **Leaflet (R)** - Interactive maps.
*   **sf (Simple Features)** - Spatial data handling and coordinate transformation.
*   **dplyr (tidyverse)** - Data manipulation and filtering.
*   **DT** - Interactive HTML tables with export buttons.
*   **readxl** - Reading Excel data sources.

## 📂 Project Structure

```text
Geosience_ThesisProjects_Repository/
├── app.R                  # Main Shiny application code (UI & Server)
├── data/
│   └── Thesis_samples_02.xlsx # The database of thesis samples (if included)
├── .gitignore             # Git ignore rules for R files
└── README.md              # Project documentation