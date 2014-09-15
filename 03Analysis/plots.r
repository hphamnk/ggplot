library("ggplot2")
options(java.parameters="-Xmx4g")
library(rJava)
library(RJDBC)
library(scales)
library(maps)
library(ggmap)
library(choroplethr)

jdbcDriver <- JDBC(driverClass="oracle.jdbc.OracleDriver", classPath="F:/Program Files/Java/jdk1.8.0_20/ojdbc6.jar")

# In the following, use your username and password instead of "CS347_prof", "orcl_prof" once you have an Oracle account
possibleError <- tryCatch(
  jdbcConnection <- dbConnect(jdbcDriver, "jdbc:oracle:thin:@128.83.138.158:1521:orcl", "C##cs347_hnp248", "orcl_hnp248"),
  error=function(e) e
)
if(!inherits(possibleError, "error")){
  #population <- dbGetQuery(jdbcConnection, "select * from POPULATION")
  #diamonds <- dbGetQuery(jdbcConnection, "select * from diamonds")
  
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
  
  #population by state, age, sex
  popSAS <- dbGetQuery(jdbcConnection, "select s.STATE_NAME as State, p.AGE as Age, s2.SEX_NAME as Sex, sum(p.CENSUS2010POP) as Population
  from POPULATION p
     INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
     INNER JOIN SEX s2 on p.SEX_ID = s2.SEX_ID
  where p.ORIGIN_ID = 0 and (p.SEX_ID = 1 or p.SEX_ID = 2)
  group by s.STATE_NAME, p.AGE, s2.SEX_NAME
  order by s.STATE_NAME, p.AGE, s2.SEX_NAME asc"

  #total population by state
  TotalPop <- dbGetQuery(jdbcConnection, "select s.STATE_NAME as State, sum(p.CENSUS2010POP) as TotalPopulation from POPULATION p 
	INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
  where p.SEX_ID = 0
  group by s.STATE_NAME
  order by s.STATE_NAME asc")

  #male population by state
  MalePop <- dbGetQuery(jdbcConnection, "select s.STATE_NAME as State, sum(p.CENSUS2010POP) as MalePopulation from POPULATION p 
 	INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
  where p.SEX_ID = 1
  group by s.STATE_NAME
  order by s.STATE_NAME asc")

  #texas population by different races
  TexasAges1 <- dbGetQuery(jdbcConnection, "select age, CENSUS2010POP as population from POPULATION
  where SEX_ID = 0 and Origin_ID = 0 and STATE_ID = 48 and RACE_ID = 1
  ")

  TexasAges2 <- dbGetQuery(jdbcConnection, "select age, CENSUS2010POP as population from POPULATION
  where SEX_ID = 0 and Origin_ID = 0 and STATE_ID = 48 and RACE_ID = 2
  ")

  TexasAges3 <- dbGetQuery(jdbcConnection, "select age, CENSUS2010POP as population from POPULATION
  where SEX_ID = 0 and Origin_ID = 0 and STATE_ID = 48 and RACE_ID = 3
  ")


  TexasAges5 <- dbGetQuery(jdbcConnection, "select age, CENSUS2010POP as population from POPULATION
  where SEX_ID = 0 and Origin_ID = 0 and STATE_ID = 48 and RACE_ID = 5
  ")
  
  )
  
#   popAll <- dbGetQuery(jdbcConnection, "select s.STATE_NAME as State, r.RACE_NAME as Race, p.AGE as Age, s2.SEX_NAME as Sex, sum(p.CENSUS2010POP) as Population
#   from POPULATION p
#      INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
#      INNER JOIN RACE r on  p.RACE_ID = r.RACE_ID
#      INNER JOIN SEX s2 on p.SEX_ID = s2.SEX_ID
#   where p.ORIGIN_ID = 0 and (p.SEX_ID = 1 or p.SEX_ID = 2)
#   group by s.STATE_NAME, r.RACE_NAME, p.AGE, s2.SEX_NAME
#   order by s.STATE_NAME, r.RACE_NAME, p.AGE, s2.SEX_NAME asc")
  
  # cali population
  popCali <- dbGetQuery(jdbcConnection, "select p.AGE as Age, s2.SEX_NAME as Sex, sum(p.CENSUS2010POP) as Population
  from POPULATION p
     INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
     INNER JOIN SEX s2 on p.SEX_ID = s2.SEX_ID
  where p.ORIGIN_ID = 0 and (p.SEX_ID = 1 or p.SEX_ID = 2) and s.STATE_NAME = 'CA'
  group by  p.AGE, s2.SEX_NAME
  order by  p.AGE, s2.SEX_NAME asc")
  
  
#   #pop by state, race
#   popStateRace <- dbGetQuery(jdbcConnection, "select s.STATE_NAME as State, r.RACE_NAME as Race, sum(p.CENSUS2010POP) as Population
#   from POPULATION p
#      INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
#      INNER JOIN RACE r on  p.RACE_ID = r.RACE_ID
#   where p.ORIGIN_ID = 0 and p.SEX_ID = 0
#   group by s.STATE_NAME, r.RACE_NAME
#   order by s.STATE_NAME asc")
  dbDisconnect(jdbcConnection)
}


#ggplot(popState, aes(y = POPULATION, x = STATE)) + geom_bar(stat = "identity") 
#ggplot(popState, aes(y = POPULATION, x = STATE)) + geom_bar(stat = "identity") + theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5)) 
#ggplot(popState, aes(y = POPULATION, x = STATE)) + geom_bar(stat = "identity") + theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))  + coord_flip() + ggtitle("Population by State")

#state chart
gpopState <- ggplot(popState, aes(y = POPULATION, x = STATE)) + coord_flip() + ggtitle("Population by State") + scale_y_continuous(labels = comma)
popState$STATE2 <-reorder(popState$STATE, popState$POPULATION)
gpopState + geom_bar(aes(x=STATE2, fill=POPULATION), color = "black", data = popState , stat = "identity") + guides(fill=FALSE)

#age by state, sex chart
ggplot(data = popSAS, aes(x = AGE, y = POPULATION, fill = SEX)) + geom_bar(stat="identity", position=position_dodge()) + facet_wrap(~STATE, scales = "free")+ ggtitle("Population by State") + scale_y_continuous(labels = comma) + theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5)) 

# ggplot(data = popCali, aes(x = AGE, y = POPULATION, fill = SEX)) + geom_histogram(stat="identity") + scale_y_continuous(labels = comma) + theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))
# ggplot(data = popCali, aes(x = AGE, y = POPULATION, fill = SEX)) + geom_bar(stat="identity", position=position_dodge()) + scale_y_continuous(labels = comma) + theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))

#state map
colnames(popState) <- c("region", 'value')
choroplethr(popState, "state")

#race chart
gpopRace <- ggplot(popRace, aes(y = POPULATION, x = RACE)) + coord_flip() + ggtitle("Population by Race") + scale_y_continuous(labels = comma)
popRace$RACE2 <- reorder(popRace$RACE, popRace$POPULATION)
gpopRace + geom_bar(aes(x=RACE2, fill=POPULATION), color = "black", data = popRace , stat = "identity") + guides(fill=FALSE)
#gpopRace + geom_bar(aes(x=RACE2), data = popRace , stat = "identity") + geom_text(aes(label = POPULATION))

#state map
colnames(popState) <- c("region", 'value')
colnames(whiteState) <- c('region', 'race', 'value')
colnames(blackState) <- c('region', 'race', 'value')
colnames(indianState) <- c('region', 'race', 'value')
colnames(asianState) <- c('region', 'race', 'value')
colnames(hawaiiState) <- c('region', 'race', 'value')
choroplethr(popState, "state", title = 'Population by State', num_buckets=4)
choroplethr(whiteState, "state", title = 'White Population by State', num_buckets=4)
choroplethr(blackState, "state", title = 'Black Population by State', num_buckets=4)
choroplethr(indianState, "state", title = 'American Indian and Alaska Native Population by State', num_buckets=4)
choroplethr(asianState, "state", title = 'Asian by State', num_buckets=4)
choroplethr(hawaiiState, "state", title = 'Native Hawaiian and Other Pacific Islander Population by State', num_buckets=4)


#male ratio in US by state
MaleRatio <- MalePop
TotalPop[c("col")] <- NA

colnames(MaleRatio) <- c("state", "MALE RATIO")

for (i in 1:50)
{
	MaleRatio[i,"MALE RATIO"] <- round(MalePop[i,MalePopulation] / TotalPop[i,TotalPopulation], digits = 3 ) 
}

colnames(MaleRatio) <- c("region", 'value')
choroplethr(MaleRatio, "state", title = 'Male Ratio by State')

#population in age by state
TexasAgesT <- TexasAges1

TexasAgesT$POPULATION <- as.numeric(TexasAgesT$POPULATION)
TexasAgesT$AGE <- as.numeric(TexasAgesT$AGE)

for(i in 1:86)
{
	TexasAgesT[i,"POPULATION"] <- strtoi(TexasAges1[i,"POPULATION"]) + strtoi(TexasAges2[i,"POPULATION"]) + strtoi(TexasAges3[i,"POPULATION"])  + strtoi(TexasAges5[i,"POPULATION"])
}



ggplot(TexasAgesT, aes(x = AGE, y = POPULATION)) + ggtitle("Total Population by Age in Texas") + geom_histogram(stat = "identity")

