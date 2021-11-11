f1_line <- f1 %>% 
  st_as_sf(coords = c("location.long", "location.lat"),
           crs = 4326) %>% 
  group_by(hour(timestamp)) %>% 
  summarise(do_union = FALSE) %>% 
  st_cast("LINESTRING")

mapview(f1_line)

##Expected function inputs. 
##Data frame and individual.local.identifier "60F1"

##Expected outputs. 
##A plot with all gps locations of "60F1"