library(shiny)

library("ggplot2")
options(java.parameters="-Xmx4g")
library(rJava)
library(RJDBC)
library(scales)
library(maps)
library(ggmap)
library(plyr)
library(choroplethr)
library(RColorBrewer)
#runApp('04Shiny')

jdbcDriver <- JDBC(driverClass="oracle.jdbc.OracleDriver", classPath="F:/Program Files/Java/jdk1.8.0_20/ojdbc6.jar")
#jdbcDriver <- JDBC(driverClass="oracle.jdbc.OracleDriver", classPath="C:/Program Files/Java/jdk1.7.0_01/ojdbc6.jar")

possibleError <- tryCatch(
  jdbcConnection <- dbConnect(jdbcDriver, "jdbc:oracle:thin:@128.83.138.158:1521:orcl", "C##cs347_hnp248", "orcl_hnp248"),
  error=function(e) e
)
if(!inherits(possibleError, "error")){
  
  popAll <- dbGetQuery(jdbcConnection, "select s.STATE_NAME as State, r.RACE_NAME as Race, o.ORIGIN_NAME as Origin, p.AGE as Age, s2.SEX_NAME as Sex, sum(p.CENSUS2010POP) as Population
                       from POPULATION p
                       INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
                       INNER JOIN RACE r on  p.RACE_ID = r.RACE_ID
                       INNER JOIN SEX s2 on p.SEX_ID = s2.SEX_ID
                       INNER JOIN ORIGIN o on p.ORIGIN_ID = o.ORIGIN_ID
                       group by s.STATE_NAME, r.RACE_NAME, o.ORIGIN_NAME, p.AGE, s2.SEX_NAME
                       order by s.STATE_NAME, r.RACE_NAME, p.AGE, s2.SEX_NAME asc")
  
  dbDisconnect(jdbcConnection)
  
}


shinyServer(function(input, output) {
  
  output$disPlot <- renderPlot({ 

    if (input$var == "Total")
    {
      mapPopState <- totalPopState
      colnames(mapPopState) <- c("region", 'value')
      choroplethr(mapPopState, "state", title = 'Population by State')
    }
    else if (input$var == "White")
    {
      mapWhiteState <- subset(popAll, RACE =='White' & SEX =='Total' & ORIGIN =='Total')
      mapWhiteState <- ddply(mapWhiteState, 'STATE', numcolwise(sum))
      colnames(mapWhiteState) <- c('region', 'value')
      choroplethr(mapWhiteState, "state", title = 'White Population by State', num_buckets=4) + scale_fill_brewer(palette=10)
      
    }
    else if (input$var == "Black or African American")
    {
      mapBlackState <- subset(popAll, RACE =='Black or African American' & SEX =='Total' & ORIGIN =='Total')
      mapBlackState <- ddply(mapBlackState, 'STATE', numcolwise(sum))
      colnames(mapBlackState) <- c('region', 'value')
      choroplethr(mapBlackState, "state", title = 'Black or African American Population by State', num_buckets=4)  + scale_fill_brewer(palette=8)
      
    }
    else if (input$var == "Indian")
    {
      mapIndianState <- subset(popAll, RACE =='American Indian and Alaska Native' & SEX =='Total' & ORIGIN =='Total')
      mapIndianState <- ddply(mapIndianState, 'STATE', numcolwise(sum))
      colnames(mapIndianState) <- c('region', 'value')
      choroplethr(mapIndianState, "state", title = 'American Indian and Alaska Native Population by State', num_buckets=4)  + scale_fill_brewer(palette=15)
      
    }
    else if (input$var == "Asian")
    {
      mapAsianState <- subset(popAll, RACE =='Asian' & SEX =='Total' & ORIGIN =='Total')
      mapAsianState <- ddply(mapAsianState, 'STATE', numcolwise(sum))
      colnames(mapAsianState) <- c('region', 'value')
      choroplethr(mapAsianState, "state", title = 'Asian Population by State', num_buckets=4)  + scale_fill_brewer(palette=4)
      
    }
    else if (input$var == "Hispanic")
    {
      mapHispanicState <- subset(popAll, SEX =='Total' & ORIGIN =='Hispanic')
      mapHispanicState <- ddply(mapHispanicState, 'STATE', numcolwise(sum))
      colnames(mapHispanicState) <- c('region', 'value')
      choroplethr(mapHispanicState, "state", title = 'Hispanic Population by State', num_buckets=4) + scale_fill_brewer(palette=18)
      
    }
    else if (input$var == "Native Hawaiian and Other Pacific Islander")
    {
      mapHawaiiState <- subset(popAll, RACE =='Native Hawaiian and Other Pacific Islander' & SEX =='Total' & ORIGIN =='Total')
      mapHawaiiState <- ddply(mapHawaiiState, 'STATE', numcolwise(sum))
      colnames(mapHawaiiState) <- c('region', 'value')
      choroplethr(mapHawaiiState, "state", title = 'Native Hawaiian and Other Pacific Islander Population by State', num_buckets=4)  + scale_fill_brewer(palette=3)
      
    }
  })
  
  
}
)



