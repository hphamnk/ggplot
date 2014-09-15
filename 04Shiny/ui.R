library(shiny)

shinyUI(fluidPage(
	titlePanel("Population Data of the US"),

	sidebarLayout(
		sidebarPanel(
   		  helpText("Display the population allocation of US in 2010 by state")
	      selectInput("var", 
       		 label = "Choose the type of populaiton to display",
       		 choices = list("Total", "White",
	          "Black", "Indian","Asian" , "Hawaiian"),
	        selected = "Total")
	      ),

		mainPanel(
			  plotOutput("distPlot")
			  )
	)


))

