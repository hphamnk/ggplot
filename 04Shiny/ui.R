library(shiny)

shinyUI(fluidPage(
	titlePanel("Population Data of the US"),

	sidebarLayout(
    
		sidebarPanel(
   		  helpText("Display the population allocation of US in 2010 by state"),
	      selectInput("var", 
       		 label = "Choose the type of populaiton to display",
       		 choices = list("Total", "White", "Black or African American", "American Indian and Alaska Native", "Asian", "Hispanic", "Native Hawaiian and Other Pacific Islander"),
	        selected = "Total")
      ),
    
		mainPanel(
		  plotOutput("disPlot")        
		)    

	)


))

