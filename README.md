# Interactive-data-visualisation-using-R-shiny

Your task in this assignment is to:

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

The project has been done as part of the course curriculum. It is a Shiny web app consisting of data visualizations on the dataset europe.csv. The code uses:



The project has been done as part of the course curriculum. It is a Shiny web app consisting of data visualizations on the dataset europe.csv. The code uses:

1. R
2. GoogleCharts

The code is not very clean or crisp, but is fully functional. It consists of the following things:

Interactive bubble chart with k means clustering
World map
Bar plots based on overall mean
Interactive grouped bar plots
2D and 3D Scatter plots which interact between each other unidirectionally
Interactive Datatable which refreshes with change of slider values
