rm(list=ls())
library(ggplot2)
library(shiny)
library(tidyverse)
library(leaflet)

# Reading Sensor Locations csv file
sl <- read.csv('Pedestrian_Counting_System_PE2/Pedestrian_Counting_System_-_Sensor_Locations (Exercise 2).csv')
# Reading Pedestrian counting csv file
pcs <- read.csv('Pedestrian_Counting_System_PE2/Pedestrian_Counting_System_2019 (Exercise 2).csv')

# All the avilable sensor locations sl data frame
sl_Name <- unique(sl[['sensor_name']])
# All the available unique sensor locations in pcs data frame
pcs_Sl_Name <- unique(pcs[['Sensor_Name']])

# To check wether all the sensors in pcs_Sl_Name are there in sl_Nameor not
print(setdiff(pcs_Sl_Name,sl_Name))
# To check wether all the sensors in sl_Name are there in pcs_Sl_Name or not
print(setdiff(sl_Name,pcs_Sl_Name))

#Since the setdiff of above two is not zero, so when the user select any location and if there is no data.
# Then there will be nothing to display, so updating sensors location in sl and pcs data frame.

# Changing "Pelham St (S)" to "Pelham St (South)" in pcs data frame
pcs$Sensor_Name <- lapply(pcs$Sensor_Name, gsub,pattern = "Pelham St (S)",
                          replacement = "Pelham St (South)", fixed = TRUE)

# Changing "Lincoln-Swanston(West)" to "Lincoln-Swanston (West)" in pcs data frame
pcs$Sensor_Name <- lapply(pcs$Sensor_Name, gsub,pattern = "Lincoln-Swanston(West)",
                          replacement = "Lincoln-Swanston (West)", fixed = TRUE)

# Changing "Swanston St - RMIT Building 80" to "Building 80 RMIT" in pcs data frame
pcs$Sensor_Name <- lapply(pcs$Sensor_Name, gsub,pattern = "Swanston St - RMIT Building 80",
                          replacement = "Building 80 RMIT", fixed = TRUE)

# Changing "Swanston St - RMIT Building 14" to "RMIT Building 14" in pcs data frame
pcs$Sensor_Name <- lapply(pcs$Sensor_Name, gsub, 
                          pattern = "Swanston St - RMIT Building 14", 
                          replacement = "RMIT Building 14", fixed = TRUE)

# Changing "Collins St (North)" to "Collins Street (North)" in pcs data frame
pcs$Sensor_Name <- lapply(pcs$Sensor_Name, gsub, 
                          pattern = "Collins St (North)", 
                          replacement = "Collins Street (North)", fixed = TRUE)

# Changing "Spencer St-Collins Street (North)" to "Spencer St-Collins St (North)" in pcs data frame
pcs$Sensor_Name <- lapply(pcs$Sensor_Name, gsub,pattern = "Spencer St-Collins Street (North)",
                          replacement = "Spencer St-Collins St (North)", fixed = TRUE)

# Changing "Flinders La - Swanston St (West) Temp"
#to "Flinders La - Swanston St (West) Temporary" in pcs data frame
pcs$Sensor_Name <- lapply(pcs$Sensor_Name, gsub, 
                          pattern = "Flinders La - Swanston St (West) Temp", 
                          replacement = "Flinders La - Swanston St (West) Temporary", fixed = TRUE)

# Changing "Flinders la - Swanston St (West) Temp" 
#to "Flinders La - Swanston St (West) Temporary" in pcs data frame
pcs$Sensor_Name <- lapply(pcs$Sensor_Name, gsub, 
                          pattern = "Flinders la - Swanston St (West) Temp", 
                          replacement = "Flinders La - Swanston St (West) Temporary", fixed = TRUE)

# Changing "Melbourne Central-Elizabeth St (East)Melbourne Central-Elizabeth St (East)" 
# to "Melbourne Central-Elizabeth St (East)" in sl data frame
sl$sensor_name <- lapply(sl$sensor_name, gsub, 
                         pattern = "Melbourne Central-Elizabeth St (East)Melbourne Central-Elizabeth St (East)", 
                         replacement = "Melbourne Central-Elizabeth St (East)", fixed = TRUE)

# Updated sensor locations in sl_Name
sl_Name <- unique(sl[['sensor_name']])
# Updated sensor locations in pcs_Sl_Name
pcs_Sl_Name <- unique(pcs[['Sensor_Name']])

# After wrangling also there are some sensors which in not common in sl and pcs data frame.
# So, I removing those sensors data.
sl <- sl %>%filter(sensor_name %in% setdiff(sl_Name,setdiff(sl_Name,pcs_Sl_Name)))

# Converting Sensor_Name in pcs to character data type
pcs$Sensor_Name <- as.character(pcs$Sensor_Name)
# Converting sensor_name in sl to character data type
sl$sensor_name <- as.character(sl$sensor_name)

# We don't need the two below list, so I'm removing these lists
rm(list = c('pcs_Sl_Name','sl_Name'))

# Creating a new data frame from pcs and sl data frame, this new data frame has 4 columns, 1. Sensor_Name
# 2. Avr_hr_count 3. latitude and 4. Longitude
map_data <- data.frame(pcs %>% group_by(Sensor_Name) %>% summarise(Avg_hr_count = mean(Hourly_Counts)) %>% 
                         inner_join(sl,by=c('Sensor_Name'='sensor_name')))

# Adjusting the Avg_hr_count in the map_data to ensure no sensor's marker is excessively large
map_data <- map_data %>% mutate(Avg_hr_count = (Avg_hr_count/max(Avg_hr_count))*12)


# UI of the app
ui <- fluidPage(
  titlePanel(h1("Melbourne's pedestrian count sensor dhashboard", align = "center")),
  fluidRow(splitLayout(plotOutput('plot2',height = "400px"),
                       leafletOutput("map", height = "400px"))),
  fluidRow(
    sidebarPanel(selectInput("sensor_location","Choose a sensor location or click on the map:",
                             choices = map_data$Sensor_Name,selected = NULL)))
)

# Server side function of the app
server <- function(input,output,session){
  
  dta <- reactive({
    dat <- pcs %>% filter(Sensor_Name==input$sensor_location)
    dat <- dat %>% group_by(Day,Time) %>% summarise(mean = mean(Hourly_Counts))
    dat$Day <- ordered(dat$Day, levels=c("Monday", "Tuesday", 
                                         "Wednesday", "Thursday","Friday", "Saturday", "Sunday"))
    dat
  })
  output$plot2 <- renderPlot({
    ggplot(dta(),aes(Time,mean)) + geom_line()+facet_grid(~Day) +
      labs(title= "average pedestrian counts throughout each day of the week for the chosen sensor",
           y="average pedestrian count at the given hour throughout the year", 
           x = "Time in format 0 (12 am) to 23 (11pm)")+
      theme(plot.title = element_text(hjust = 0.5)) + theme(text  = element_text(size=14))
    
  })
  output$map <- renderLeaflet({
    leaflet(data = map_data)%>%
      addTiles() %>%
      addCircleMarkers(lng = ~longitude, lat = ~latitude,radius = ~Avg_hr_count, 
                       label = ~Sensor_Name,fillColor = 
                         'green',opacity = 0.5,color = 'red',fillOpacity = 1)
  })
  
  observeEvent(input$sensor_location,{
    updateSelectInput(session, "sensor_location", "Choose a sensor location or click on the map:")
  })
  observeEvent(input$map_marker_click, {
    click <- input$map_marker_click
    sensor_location <- map_data[which(map_data$latitude == click$lat & map_data$longitude == click$lng), ]$Sensor_Name
    updateSelectInput(session, "sensor_location", "Choose a sensor location or click on the map:", 
                      choices = map_data$Sensor_Name,selected=sensor_location)
  })
  
}

shinyApp(ui = ui, server = server)

