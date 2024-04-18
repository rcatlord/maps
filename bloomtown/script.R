# Bloomtown map
# Source: National Trust and others
# URL: https://www.google.com/maps/d/u/0/edit?mid=1sXQ8uV2UsZU5Zgiaab0emr-bilxw0Xo

library(tidyverse) ; library(sf) ; library(leaflet) ; library(htmlwidgets)

sf <- st_read("data/Blossom Bloomtown Map 2024.kml") |>
  st_zm(sf) |>
  filter(!str_detect(Name, "trail")) |>
  mutate(Blossom = str_extract(Description, "(?<=Blossom: ).*(?=<br><br>Look out for:)"),
         Image = str_extract(Description, '(?<=src=").*(?=" height)')) |>
  select(Name, Blossom, Image)

leaflet() |>
  addProviderTiles(providers$CartoDB.Positron) |>
  addCircleMarkers(data = sf, 
                   color = "#ffb7c5", stroke = TRUE, opacity = 0.8,
                   popup = ~paste("<img src='", Image, "' width = 2000/><br><strong>", Name, "</strong>", "<br>", Blossom)) |>
  addControl(paste0("<strong>Manchester Bloomtown 2024</strong><br>Source: <a href='https://www.google.com/maps/d/u/0/edit?mid=1sXQ8uV2UsZU5Zgiaab0emr-bilxw0Xo'>National Trust and others</a>"), position = 'topright') |>
  onRender(paste0("function(el, x) {$('head').append(","\'<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, viewport-fit=cover\">\'",");}"))
