library(tidyr)
library(dplyr)
library(ggplot2)
library(naniar)
library(corrplot)
library(MASS)
library(GGally)
library(factoextra)
library(plotly)
library(tidyverse)
library(corrplot)

library(shiny)

library(shinydashboard)
library(shinydashboardPlus)
library(shinybusy)
library(shinythemes)
library(nloptr)
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


data1 <- readxl::read_xlsx("2023 County Health Rankings Data - v2.xlsx", sheet = 4)

LBW_df <- data1 %>% dplyr::select( FIP = ...1, State = ...2, County = ...3, LowBirthWeight_rate = ...43, LBW_AIAN = ...47, LBW_AISAN = ...50, LBW_BLACK = ...53, LBW_HISPANI = ...56, LBW_WHITE = ...59)
LBW_df <- LBW_df[-1,] %>% drop_na(State, County, LowBirthWeight_rate)

data2 <- readxl::read_xlsx("2023 County Health Rankings Data - v2.xlsx", sheet = 4)

names(data2) <- data2[1,]
ls_data2 <- ls(data2)

attr_df <- data2[-1,c("FIPS",
                      "State",
                      "County",
                      "% Adults Reporting Currently Smoking", 
                      "% Excessive Drinking",
                      "Teen Birth Rate",
                      "Teen Birth Rate (AIAN)",
                      "Teen Birth Rate (Asian)",
                      "Teen Birth Rate (Black)",
                      "Teen Birth Rate (Hispanic)",
                      "Teen Birth Rate (White)",
                      "Chlamydia Rate",
                      "% Uninsured",
                      "Primary Care Physicians Rate",
                      "Mental Health Provider Rate",
                      "% Completed High School",
                      "% Some College",
                      "% Unemployed",
                      "Income Ratio",
                      "Social Association Rate",
                      "Average Daily PM2.5",
                      "Presence of Water Violation",
                      "% Severe Housing Problems",
                      "Severe Housing Cost Burden",
                      "Overcrowding",
                      "Inadequate Facilities"
)] 


data3 <- readxl::read_xlsx("2023 County Health Rankings Data - v2.xlsx", sheet = 6)
names(data3) <- data3[1,]

ls_data3 <- ls(data3)
add_attr <- data3[-1, c("State",
                        "County",
                        "% Food Insecure",
                        "% Insufficient Sleep",
                        #"Health care costs",
                        "Gender Pay Gap",
                        "% Homeowners",
                        "% Frequent Mental Distress",
                        "Median Household Income",
                        "% Black",
                        "% Asian",
                        "% Hispanic",
                        "% Non-Hispanic White",
                        "% Rural")]

# merge data and change var type
merged_data <- LBW_df %>% 
  left_join(attr_df, by = c("State","County")) %>%
  left_join(add_attr, by = c("State","County")) %>%
  mutate_at(vars(4:44), as.numeric)

#check duplicate
merged_data %>% group_by(State,County) %>% filter(n() == 1) 

#check missingness and remove some large missing variables
s_cols <- miss_var_summary(merged_data) %>% filter(pct_miss <= 36) %>% pull(variable)
merged_data <- merged_data[,(names(merged_data) %in% s_cols)]


#correlation 
M <- cor(merged_data %>% dplyr::select(where(is.numeric),-FIPS) %>% drop_na())
corr_p <- corrplot(M, method = 'number', diag = FALSE,
         type = 'upper',
         tl.col = "black",
         addCoef.col = "black",
         tl.cex = 0.75,
         number.digits = 2, 
         number.cex = 0.84,
         cl.cex = 1,
         rect.lwd = 3,
         col = colorRampPalette(c("midnightblue", "white","darkred"))(100)) 



#select features by correlation
## health behaviour: 
### drink, smoking
### chlamydia Rate, teens birth
### food insecurity
### insufficient sleep
## clinic care

##social&economic
### high school, college
### income ratio, median house income, unemployed
##physical environment
## quality of life
### mental distress
## demogrphic
###black



#scale data and drop na to prepare scatter plots
merged_data_scale <- merged_data %>% mutate(across(where(is.numeric),scale)) %>% drop_na() %>% dplyr::select(c("State",
                                                                                                        "LowBirthWeight_rate",
                                                                                                        "% Adults Reporting Currently Smoking",
                                                                                                        "% Completed High School",
                                                                                                        "% Excessive Drinking",
                                                                                                        "% Food Insecure",
                                                                                                        "% Frequent Mental Distress",
                                                                                                        "% Insufficient Sleep",
                                                                                                        "% Some College",
                                                                                                        "% Unemployed",
                                                                                                        "Chlamydia Rate" ,
                                                                                                        "Income Ratio",
                                                                                                        "Median Household Income",
                                                                                                        "Overcrowding",
                                                                                                        "Teen Birth Rate",
                                                                                                        "% Black")
)


#max-min scale

#wide to long



#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

data_year <- read.csv("low birth rate by year.csv")
State_shapes <- sf::st_read("States_shapefile/States_shapefile.shp") %>% mutate_at(vars(6), as.numeric)
names(data_year)[2] = "State_Code"
state_year_data <- dplyr::left_join( data_year ,State_shapes, by = "State_Code") 

 
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------






























