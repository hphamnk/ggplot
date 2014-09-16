library(shiny)

shinyUI(fluidPage(
	titlePanel("Population Data of the US"),

	sidebarLayout(position = "left",
    
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

	),
	sidebarLayout(position = "left",
	              
	              sidebarPanel(
	                
	                
	                helpText("Display age distribution of different state"),
	                selectInput("var2", 
	                            label = "Choose the state to display",
	                            choices = list("TX", "CA", "ND", "SD", "WA", "VT", "KS", "WY", "NY", "IL", "FL"),
	                            selected = "TX")
	                
	              ),
	              
	              mainPanel(
	                plotOutput("disPlot2")
	              )    
	              
	)

  


))

