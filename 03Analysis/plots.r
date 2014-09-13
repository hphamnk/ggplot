library("ggplot2")
options(java.parameters="-Xmx2g")
library(rJava)
library(RJDBC)
library(scales)

jdbcDriver <- JDBC(driverClass="oracle.jdbc.OracleDriver", classPath="F:/Program Files/Java/jdk1.8.0_20/ojdbc6.jar")

# In the following, use your username and password instead of "CS347_prof", "orcl_prof" once you have an Oracle account
possibleError <- tryCatch(
  jdbcConnection <- dbConnect(jdbcDriver, "jdbc:oracle:thin:@128.83.138.158:1521:orcl", "C##cs347_hnp248", "orcl_hnp248"),
  error=function(e) e
)
if(!inherits(possibleError, "error")){
  population <- dbGetQuery(jdbcConnection, "select * from POPULATION")
  diamonds <- dbGetQuery(jdbcConnection, "select * from diamonds")
  popState <- dbGetQuery(jdbcConnection, "select s.STATE_NAME as State, sum(p.CENSUS2010POP) as Population
  from POPULATION p 
    INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
  where p.ORIGIN_ID = 0 and p.SEX_ID = 0
  group by s.STATE_NAME
  order by s.STATE_NAME asc")
  popStateRace <- dbGetQuery(jdbcConnection, "select s.STATE_NAME as State, r.RACE_NAME as Race, sum(p.CENSUS2010POP) as Population
  from POPULATION p
     INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
     INNER JOIN RACE r on  p.RACE_ID = r.RACE_ID
  where p.ORIGIN_ID = 0 and p.SEX_ID = 0
  group by s.STATE_NAME, r.RACE_NAME
  order by s.STATE_NAME asc")
  dbDisconnect(jdbcConnection)
}
#head(population)
#head(diamonds)'
head(popState)
#ggplot(popState, aes(y = POPULATION, x = STATE)) + geom_bar(stat = "identity") 
#ggplot(popState, aes(y = POPULATION, x = STATE)) + geom_bar(stat = "identity") + theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5)) 
#ggplot(popState, aes(y = POPULATION, x = STATE)) + geom_bar(stat = "identity") + theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))  + coord_flip() + ggtitle("Population by State")
gpopState <- ggplot(popState, aes(y = POPULATION, x = STATE)) + coord_flip() + ggtitle("Population by State") + scale_y_continuous(labels = comma)
popState$STATE2 <-reorder(popState$STATE, popState$POPULATION)
gpopState + geom_bar(aes(x=STATE2), data = popState , stat = "identity")

head(popStateRace)


ggplot(data = diamonds) + geom_histogram(aes(x = carat))
ggplot(data = diamonds) + geom_density(aes(x = carat, fill = "gray50"))
ggplot(diamonds, aes(x = carat, y = price)) + geom_point()
p <- ggplot(diamonds, aes(x = carat, y = price)) + geom_point(aes(color = color))
p + facet_wrap(~color) # For ~, see http://stat.ethz.ch/R-manual/R-patched/library/base/html/tilde.html and http://stat.ethz.ch/R-manual/R-patched/library/stats/html/formula.html
p + facet_grid(cut ~ clarity)
p <- ggplot(diamonds, aes(x = carat)) + geom_histogram(aes(color = color), binwidth = max(diamonds$carat)/30)
p + facet_wrap(~color) 
p + facet_grid(cut ~ clarity)


