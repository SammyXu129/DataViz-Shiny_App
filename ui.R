#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#Plot


# Define UI for application that draws a histogram
shinyUI(fluidPage(
    navbarPage("DATA5002 Shiny",theme = shinytheme("united"),
               tabPanel( "Guide", icon = icon("glasses"), value = 2,
                         div(style='width:1400px; height:300px',
                             titlePanel("Welcome to Low Birth Weight Health Factor Dashboard"),
                             h3("Why is Low Birth Weight a serve health problem?"),
                             
                             HTML("<p>
                             Low birth weight babies, defined as those born weighing less than 5.5 pounds (2.5 kilograms), are more vulnerable and less resilient compared to babies born at a healthy weight. 
                                   Babies with low birth weight often have underdeveloped organs, especially the lungs, which can lead to respiratory difficulties and other health challenges.
                                  Their immune systems may not be fully developed, making them more susceptible to infections and illnesses.
                                   Low birth weight babies may struggle with maintaining body temperature, leading to an increased risk of hypothermia.
                                  There are many preventable measures before and during pregency and it is vital for policy makers to implement evidence-based policies and interventions 
                                  to make a positive impact on the lives of families and communities affected by low birth weight. "),
                             
                             h3("Who is this dashboard designed for"),
                             
                             HTML("<p>
                             The target audience of this dashboard is policy makers. It aims to provide insights into the prevalence of the health issue, low birth weight, across nations and the various factors influencing it. 
                             By understanding these elements, policy makers can formulate effective strategies to improve public health"),
                             
                             h3("Datasets in Dashboard"),
                             
                             HTML("<p>
                             The datasets utilised in this project from https://www.countyhealthrankings.org/: This dataset summarizes low birth weight data from 2014 to 2021. It includes various attributes that might impact health issues and provides the low birth weight rate across states in the USA from 2014 to 2021."),
                      
                              h3("Navigator of this dashboard"),
                             HTML("The Geology Distribution shows the distribution of low birth weight rates across the USA over the years. The Factor Analysis allows users to select two desired elements to understand their relationships.")
                         )
               ),
               tabPanel("Geology Distribution", icon = icon("globe"),
                       sidebarLayout(
                         sidebarPanel(
                           sliderInput("year", labe = "YEAR", min = 2014, sep = "",
                                       max = 2021, value = 2014, 
                                       animate = animationOptions(interval = 500, loop = TRUE)),
                           HTML("The plot shows the distribution of low birth rates across states in the USA from 2014 to 2021.")
                           ),
                         mainPanel(
                           plotlyOutput("mapPlot", height = "600px")
                         )
                         )
                ),
               tabPanel("Factor Analysis", icon = icon("atom"),
                        sidebarLayout(
                          sidebarPanel(
                            selectInput(inputId = "Var_X",
                                        label = "Choose factor 1",
                                        choices = list(
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
                                             "% Black")),
                            selectInput(inputId = "Var_Y",
                                        label = "Choose factor 2",
                                        choices = list(
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
                                          "% Black"
                                        )),
                            HTML("As different variables contain different units, in order to bring all the variables to a common level and have comparable magnitudes, 
                            I ransform numerical variables in a dataset to a standard scale or range. As there are substantive attributes in the dataset, I filter out least correlated features.  
                            <p>
                            <p>The scatter plot illustrates the relationship between two variables, aiming to understand the factors associated with low birth weight and how these factors are interrelated.")
                            ),
                            mainPanel(
                              plotOutput("scatterPlot", height = "600px")
                            )
                        )
                 
               )
               
                        )
    ))
               #navbarMenu("Factor", icon = icon("eye"), 
                          #tabPanel(""
                            
                          #)
                   
               
    
                    
##1. map的颜色 2.map下面加一个top6 state的bar chart 和pie chart 3. modelling


