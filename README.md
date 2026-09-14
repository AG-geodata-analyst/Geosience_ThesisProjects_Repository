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

    Geosience_ThesisProjects_Repository/
    ├── app.R                                  # Main Shiny application code (UI & Server)
    ├── data/
    │   ├── Thesis_samples.csv                 # Sample database (CSV, UTF-8)
    │   └── ecu_adm_adm1_2024_light.geojson    # Simplified Ecuador province boundaries
    ├── manifest.json                          # Deployment manifest for Posit Connect Cloud
    ├── .gitignore                             # Git ignore rules (excludes .xlsx, .Rhistory, etc.)
    └── README.md                              # Project documentation

## 💻 How to Run Locally

To run this application on your own machine, you need **R** and **RStudio** installed.

1. Clone this repository:

        git clone https://github.com/AG-geodata-analyst/Geosience_ThesisProjects_Repository.git

2. Open the project folder in RStudio (or set it as your working directory).

3. Install the required R packages (only needed the first time):

        install.packages(c("shiny", "tidyverse", "sf", "leaflet", "DT"))

4. Open `app.R` in RStudio and click the **"Run App"** button at the top of the editor.

## 🗺️ Data Notes

- The sample data is stored as **CSV** (not Excel) to keep it Git-friendly, portable, and free from Excel's hidden formatting quirks.
- The province boundaries are a **simplified** version of Ecuador's admin-level-1 GeoJSON (originally from HDX). The original file was ~4.5 MB; the light version is ~200 KB, making the app load approximately **20× faster**.
- Author names in the popups are derived at runtime from the email column (e.g., `josue.ponce@est.ikiam.edu.ec` → "Josue Ponce").

## 🚀 Deployment

This app is deployed on **Posit Connect Cloud** (free tier), linked to this GitHub repository.

To deploy or update:

1. Ensure the `main` branch is up to date on GitHub.

2. If R packages have changed, regenerate the manifest:

        rsconnect::writeManifest()

3. Commit and push — Posit Connect Cloud auto-redeploys on push.

## 👤 Author

**Anderson Guaman**

- GitHub: [@AG-geodata-analyst](https://github.com/AG-geodata-analyst)

## 📝 License

This project is licensed under the **MIT License** — you are free to use, modify, and distribute it with attribution.