# Flag map

library(tidyverse) ; library(flagon) ; library(ggpattern) 

africa <- map_data("world") |> 
  filter(region %in% c("Algeria", "Angola", "Benin", "Botswana", "Burkina Faso", 
                       "Burundi", "Cameroon", "Central African Republic", "Chad", 
                       "Comoros", "Democratic Republic of the Congo", "Djibouti", 
                       "Egypt", "Equatorial Guinea", "Eritrea", "Ethiopia", "Gabon", 
                       "Gambia", "Ghana", "Guinea", "Guinea-Bissau", "Ivory Coast", 
                       "Kenya", "Lesotho", "Liberia", "Libya", "Madagascar", "Malawi", 
                       "Mali", "Mauritania", "Mauritius", "Morocco", "Mozambique", 
                       "Namibia", "Niger", "Nigeria", "Republic of Congo", "Rwanda", 
                       "Sao Tome and Principe", "Senegal", "Seychelles", "Sierra Leone", 
                       "Somalia", "South Africa", "South Sudan", "Sudan", "Swaziland", 
                       "Tanzania", "Togo", "Tunisia", "Uganda", "Western Sahara", 
                       "Zambia", "Zimbabwe"))

countries <- filter(africa, region %in% c("Egypt","Mozambique","Ethiopia","Namibia","Algeria","Madagascar"))

flags <- country_codes %>%
  select(country, ccode) %>%
  mutate(flag = flags(ccode)) 

countries %>%
  left_join(flags, by = c("region" = "country")) %>%
  filter(!is.na(flag)) %>%
  ggplot() +
  geom_polygon(data = africa, aes(x = long, y = lat, group = group),
               colour = "#212121", fill = "#FFFFFF", linewidth = 0.1) +
  geom_map_pattern(
    map = countries,
    aes(map_id = region, pattern_type = region, pattern_filename = I(flag)), 
    pattern = "image", pattern_type = "expand",
    color = "#212121", linewidth = 0.1) +
  coord_sf(crs = "+proj=cea +lon_0=0 +x_0=0 +y_0=0 +lat_ts=45 +ellps=WGS84 +datum=WGS84 +units=m +no_defs") +
  theme_void()

ggsave("map.png", dpi = 300, scale = 1)
