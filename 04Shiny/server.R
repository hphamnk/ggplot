library(shiny)

library(ggplot2)
options(java.parameters="-Xmx4g")
library(rJava)
library(RJDBC)
library(scales)
library(maps)
library(ggmap)
library(choroplethr)

jdbcDriver <- JDBC(driverClass="oracle.jdbc.OracleDriver", classPath="F:/Program Files/Java/jdk1.8.0_20/ojdbc6.jar")
#jdbcDriver <- JDBC(driverClass="oracle.jdbc.OracleDriver", classPath="C:/Program Files/Java/jdk1.7.0_01/ojdbc6.jar")

possibleError <- tryCatch(
  jdbcConnection <- dbConnect(jdbcDriver, "jdbc:oracle:thin:@128.83.138.158:1521:orcl", "C##cs347_hnp248", "orcl_hnp248"),
  error=function(e) e
)
if(!inherits(possibleError, "error")){
  
  #pop by state
  popState <- dbGetQuery(jdbcConnection, "select s.STATE_NAME as State, sum(p.CENSUS2010POP) as Population
  from POPULATION p 
    INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
  where p.ORIGIN_ID = 0 and p.SEX_ID = 0
  group by s.STATE_NAME
  order by s.STATE_NAME asc")
  
  #pop by race
  popRace <- dbGetQuery(jdbcConnection, "select r.RACE_NAME as Race, sum(p.CENSUS2010POP) as Population
  from POPULATION p 
    INNER JOIN RACE r on  p.RACE_ID = r.RACE_ID
  where p.ORIGIN_ID = 0 and p.SEX_ID = 0
  group by r.RACE_NAME
  order by r.RACE_NAME asc")
  
  #white pop by state
  whiteState <- dbGetQuery(jdbcConnection, "select s.STATE_NAME as State, r.RACE_NAME as Race, sum(p.CENSUS2010POP) as Population
  from POPULATION p
     INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
     INNER JOIN RACE r on  p.RACE_ID = r.RACE_ID
  where p.ORIGIN_ID = 0 and p.SEX_ID = 0 and r.RACE_ID = 1
  group by s.STATE_NAME, r.RACE_NAME
  order by s.STATE_NAME asc")
  
  #black pop by state
  blackState <- dbGetQuery(jdbcConnection, "select s.STATE_NAME as State, r.RACE_NAME as Race, sum(p.CENSUS2010POP) as Population
  from POPULATION p
     INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
     INNER JOIN RACE r on  p.RACE_ID = r.RACE_ID
  where p.ORIGIN_ID = 0 and p.SEX_ID = 0 and r.RACE_ID = 2
  group by s.STATE_NAME, r.RACE_NAME
  order by s.STATE_NAME asc")
  
  #native indian pop by state
  indianState <- dbGetQuery(jdbcConnection, "select s.STATE_NAME as State, r.RACE_NAME as Race, sum(p.CENSUS2010POP) as Population
  from POPULATION p
     INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
     INNER JOIN RACE r on  p.RACE_ID = r.RACE_ID
  where p.ORIGIN_ID = 0 and p.SEX_ID = 0 and r.RACE_ID = 3
  group by s.STATE_NAME, r.RACE_NAME
  order by s.STATE_NAME asc")
  
  #asian pop by state
  asianState <- dbGetQuery(jdbcConnection, "select s.STATE_NAME as State, r.RACE_NAME as Race, sum(p.CENSUS2010POP) as Population
  from POPULATION p
     INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
     INNER JOIN RACE r on  p.RACE_ID = r.RACE_ID
  where p.ORIGIN_ID = 0 and p.SEX_ID = 0 and r.RACE_ID = 4
  group by s.STATE_NAME, r.RACE_NAME
  order by s.STATE_NAME asc")
  
  #hawaii pop by state
  hawaiiState <- dbGetQuery(jdbcConnection, "select s.STATE_NAME as State, r.RACE_NAME as Race, sum(p.CENSUS2010POP) as Population
  from POPULATION p
     INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
     INNER JOIN RACE r on  p.RACE_ID = r.RACE_ID
  where p.ORIGIN_ID = 0 and p.SEX_ID = 0 and r.RACE_ID = 5
  group by s.STATE_NAME, r.RACE_NAME
  order by s.STATE_NAME asc")

  dbDisconnect(jdbcConnection)
 
}

colnames(popState) <- c("region", 'value')
colnames(whiteState) <- c('region', 'race', 'value')
colnames(blackState) <- c('region', 'race', 'value')
colnames(indianState) <- c('region', 'race', 'value')
colnames(asianState) <- c('region', 'race', 'value')
colnames(hawaiiState) <- c('region', 'race', 'value')


shinyServer(function(input, output) {

     output$disPlot <- renderPlot({ 
       
       s <- "str"
       g <- popState
       if (input$var == "Total")
       {
         s <- "Population by State"
         g <- popState
       }
       else if (input$var == "White")
       {
         s <- "White Population by State"
         g <- whiteState
       }
       else if (input$var == "Black")
       {
         s <- "Black Population by State"
         g <-blackState
       }
       else if (input$var == "Indian")
       {
         s <- "American Indian and Alaska Native Population by State"
         g <- indianState
       }
       else if (input$var == "Asian")
       {
         s <- "Asian by State"
         g <-asianState
       }
       else
       {
         s <- 'Native Hawaiian and Other Pacific Islander Population by State'
         g <- hawaiiState
       }
       
      	choroplethr(g, "state", title = s, num_buckets=4)
    })
  

  }
)


