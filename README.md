# Interactive-data-visualisation-using-R-shiny

The project has been done as part of the course curriculum. It is a Shiny web app consisting of data visualizations on the [Pedestrian counting system](https://github.com/AshwaniKuSingh/Interactive-data-visualisation-using-R-shiny/tree/master/Pedestrian_Counting_System_PE2) datasets. The aforementioned datasets are simplified versions of the two two datasets that can be found publicly:
* Pedestrian Counting System – Sensor Locations (Exercise 2): This contains the spatial coordinates of pedestrian sensor devices located around the City of Melbourne, retrieved from https://data.melbourne.vic.gov.au/Transport/Pedestrian-Counting-System-Sensor-Locations/h57g-5234
* Pedestrian Counting System – 2019 (Exercise 2): This contains the hourly pedestrian counts of each sensor during 2019, retrieved from https://data.melbourne.vic.gov.au/Transport/Pedestrian-Counting-System-2009-to-Present-counts-/b2ak-trbp

The code uses following R packages:
1. Tidyverse
2. ggplot2
3. Leaflet
4. shiny

The requirement of the assignment was to do the following task:

1. Read both datasets into R
2. Set up your R script to work with Shiny. The UI and Server functions do not have to be in separate files.
3. Create a proportional symbol map and faceted line chart with following specifications and place them side by side.
   1. Create a proportional symbol map using Leaflet that shows the locations of all sensors across Melbourne’s CBD:
      1. Using circle markers, the radius of each sensor’s marker should be proportional to the average hourly count over the entire year of 2019. Use an appropriate scaling factor to ensure no marker is excessively large.
      2. The name of the sensor should be visible in a tooltip when hovered over by mouse.
      3. The output map should be appropriately sized and scaled in the Shiny application to comfortably show all sensors by default.
   2. Create a faceted line chart using ggplot2 that shows the average pedestrian counts throughout each day of the week for the chosen sensor:
      1. The x axis should show the time of day at hourly intervals, that is from 0 (12 am) to 23 (11pm).
      2. The y axis should show the average pedestrian count at the given hour.
      3. The line chart should be faceted by day of the week (i.e., Monday, Tuesday, Wednesday, etc.), and should be ordered appropriately.
      4. Create a Shiny input selection box that includes an option each sensor.
      5. The line chart should update based on the sensor that is chosen in the input selection box.
4. Create interactive linking between the map and line chart. When a marker on the map is clicked, the input selection box should be updated to the relevant sensor and the line chart accordingly.
