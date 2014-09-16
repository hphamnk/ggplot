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

jdbcDriver <- JDBC(driverClass="oracle.jdbc.OracleDriver", classPath="F:/Program Files/Java/jdk1.8.0_20/ojdbc6.jar")

possibleError <- tryCatch(
  jdbcConnection <- dbConnect(jdbcDriver, "jdbc:oracle:thin:@128.83.138.158:1521:orcl", "C##cs347_hnp248", "orcl_hnp248"),
  error=function(e) e
)
if(!inherits(possibleError, "error")){
  
  #population with state, race, age, sex
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
  
#   #pop by state
#   popState <- dbGetQuery(jdbcConnection, "select s.STATE_NAME as State, sum(p.CENSUS2010POP) as Population
#   from POPULATION p 
#     INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
#   where p.ORIGIN_ID = 0 and p.SEX_ID = 0
#   group by s.STATE_NAME
#   order by s.STATE_NAME asc")
#   
#   #pop by race
#   popRace <- dbGetQuery(jdbcConnection, "select r.RACE_NAME as Race, sum(p.CENSUS2010POP) as Population
#   from POPULATION p 
#     INNER JOIN RACE r on  p.RACE_ID = r.RACE_ID
#   where p.ORIGIN_ID = 0 and p.SEX_ID = 0
#   group by r.RACE_NAME
#   order by r.RACE_NAME asc")
#   
#   #white pop by state
#   whiteState <- dbGetQuery(jdbcConnection, "select s.STATE_NAME as State, r.RACE_NAME as Race, sum(p.CENSUS2010POP) as Population
#   from POPULATION p
#      INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
#      INNER JOIN RACE r on  p.RACE_ID = r.RACE_ID
#   where p.ORIGIN_ID = 0 and p.SEX_ID = 0 and r.RACE_ID = 1
#   group by s.STATE_NAME, r.RACE_NAME
#   order by s.STATE_NAME asc")
#   
#   #black pop by state
#   blackState <- dbGetQuery(jdbcConnection, "select s.STATE_NAME as State, r.RACE_NAME as Race, sum(p.CENSUS2010POP) as Population
#   from POPULATION p
#      INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
#      INNER JOIN RACE r on  p.RACE_ID = r.RACE_ID
#   where p.ORIGIN_ID = 0 and p.SEX_ID = 0 and r.RACE_ID = 2
#   group by s.STATE_NAME, r.RACE_NAME
#   order by s.STATE_NAME asc")
#   
#   #native indian pop by state
#   indianState <- dbGetQuery(jdbcConnection, "select s.STATE_NAME as State, r.RACE_NAME as Race, sum(p.CENSUS2010POP) as Population
#   from POPULATION p
#      INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
#      INNER JOIN RACE r on  p.RACE_ID = r.RACE_ID
#   where p.ORIGIN_ID = 0 and p.SEX_ID = 0 and r.RACE_ID = 3
#   group by s.STATE_NAME, r.RACE_NAME
#   order by s.STATE_NAME asc")
#   
#   #asian pop by state
#   asianState <- dbGetQuery(jdbcConnection, "select s.STATE_NAME as State, r.RACE_NAME as Race, sum(p.CENSUS2010POP) as Population
#   from POPULATION p
#      INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
#      INNER JOIN RACE r on  p.RACE_ID = r.RACE_ID
#   where p.ORIGIN_ID = 0 and p.SEX_ID = 0 and r.RACE_ID = 4
#   group by s.STATE_NAME, r.RACE_NAME
#   order by s.STATE_NAME asc")
#   
#   #hawaii pop by state
#   hawaiiState <- dbGetQuery(jdbcConnection, "select s.STATE_NAME as State, r.RACE_NAME as Race, sum(p.CENSUS2010POP) as Population
#   from POPULATION p
#      INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
#      INNER JOIN RACE r on  p.RACE_ID = r.RACE_ID
#   where p.ORIGIN_ID = 0 and p.SEX_ID = 0 and r.RACE_ID = 5
#   group by s.STATE_NAME, r.RACE_NAME
#   order by s.STATE_NAME asc")
#   
#   #population by state, age, sex
#   popSAS <- dbGetQuery(jdbcConnection, "select s.STATE_NAME as State, p.AGE as Age, s2.SEX_NAME as Sex, sum(p.CENSUS2010POP) as Population
#   from POPULATION p
#      INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
#      INNER JOIN SEX s2 on p.SEX_ID = s2.SEX_ID
#   where p.ORIGIN_ID = 0 and (p.SEX_ID = 1 or p.SEX_ID = 2)
#   group by s.STATE_NAME, p.AGE, s2.SEX_NAME
#   order by s.STATE_NAME, p.AGE, s2.SEX_NAME asc")
# 
#   #total population by state
#   TotalPop <- dbGetQuery(jdbcConnection, "select s.STATE_NAME as State, sum(p.CENSUS2010POP) as TotalPopulation from POPULATION p 
# 	INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
#   where p.SEX_ID = 0
#   group by s.STATE_NAME
#   order by s.STATE_NAME asc")
# 
#   #male population by state
#   MalePop <- dbGetQuery(jdbcConnection, "select s.STATE_NAME as State, sum(p.CENSUS2010POP) as MalePopulation from POPULATION p 
#  	INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
#   where p.SEX_ID = 1
#   group by s.STATE_NAME
#   order by s.STATE_NAME asc")
# 
#   #texas population by different races
#   TexasAges1 <- dbGetQuery(jdbcConnection, "select age, CENSUS2010POP as population from POPULATION
#   where SEX_ID = 0 and Origin_ID = 0 and STATE_ID = 48 and RACE_ID = 1
#   ")
# 
#   TexasAges2 <- dbGetQuery(jdbcConnection, "select age, CENSUS2010POP as population from POPULATION
#   where SEX_ID = 0 and Origin_ID = 0 and STATE_ID = 48 and RACE_ID = 2
#   ")
# 
#   TexasAges3 <- dbGetQuery(jdbcConnection, "select age, CENSUS2010POP as population from POPULATION
#   where SEX_ID = 0 and Origin_ID = 0 and STATE_ID = 48 and RACE_ID = 3
#   ")
# 
# 
#   TexasAges5 <- dbGetQuery(jdbcConnection, "select age, CENSUS2010POP as population from POPULATION
#   where SEX_ID = 0 and Origin_ID = 0 and STATE_ID = 48 and RACE_ID = 5
#   ")
#   
#   
#   
#   # cali population
#   popCali <- dbGetQuery(jdbcConnection, "select p.AGE as Age, s2.SEX_NAME as Sex, sum(p.CENSUS2010POP) as Population
#   from POPULATION p
#      INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
#      INNER JOIN SEX s2 on p.SEX_ID = s2.SEX_ID
#   where p.ORIGIN_ID = 0 and (p.SEX_ID = 1 or p.SEX_ID = 2) and s.STATE_NAME = 'CA'
#   group by  p.AGE, s2.SEX_NAME
#   order by  p.AGE, s2.SEX_NAME asc")
# dbDisconnect(jdbcConnection)
# }

# total population by state
totalPopState <- subset(popAll, SEX == 'Total'& ORIGIN =='Total')
totalPopState <- ddply(totalPopState, 'STATE', numcolwise(sum))

# state chart
statePop <- totalPopState
statePop$STATE2 <- reorder(statePop$STATE, statePop$POPULATION)
ggplot(statePop, aes(y = POPULATION, x = STATE)) + coord_flip() + ggtitle("Population by State") + scale_y_continuous(labels = comma) + geom_bar(aes(x=STATE2, fill=factor(POPULATION)), color = "black", data = statePop , stat = "identity") + guides(fill=FALSE)

#--------------------
#age by state, sex chart
ggplot(data = popSAS, aes(x = AGE, y = POPULATION, fill = SEX)) + geom_bar(stat="identity", position=position_dodge()) + facet_wrap(~STATE, scales = "free")+ ggtitle("Population by State") + scale_y_continuous(labels = comma) + theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5)) 
#--------------------

# race chart
racePop <- subset(popAll, SEX == 'Total'& ORIGIN =='Total')
racePop <- ddply(racePop, 'RACE', numcolwise(sum))
racePop$RACE2 <- reorder(racePop$RACE, racePop$POPULATION)
ggplot(racePop, aes(y = POPULATION, x = RACE)) + coord_flip() + ggtitle("Population by Race") + scale_y_continuous(labels = comma) + geom_bar(aes(x=RACE2, fill = factor(RACE2)), color = "black", data = racePop , stat = "identity") + guides(fill=FALSE) + scale_fill_brewer(palette="Spectral")



#map population by state
mapPopState <- totalPopState
colnames(mapPopState) <- c("region", 'value')
choroplethr(mapPopState, "state", title = 'Population by State')

#map White Population by State
mapWhiteState <- subset(popAll, RACE =='White' & SEX =='Total' & ORIGIN =='Total')
mapWhiteState <- ddply(mapWhiteState, 'STATE', numcolwise(sum))
colnames(mapWhiteState) <- c('region', 'value')
choroplethr(mapWhiteState, "state", title = 'White Population by State', num_buckets=4) + scale_fill_brewer(palette=10)

#map Black or African American Population by State
mapBlackState <- subset(popAll, RACE =='Black or African American' & SEX =='Total' & ORIGIN =='Total')
mapBlackState <- ddply(mapBlackState, 'STATE', numcolwise(sum))
colnames(mapBlackState) <- c('region', 'value')
choroplethr(mapBlackState, "state", title = 'Black or African American Population by State', num_buckets=4)  + scale_fill_brewer(palette=8)

#map American Indian and Alaska Native Population by State
mapIndianState <- subset(popAll, RACE =='American Indian and Alaska Native' & SEX =='Total' & ORIGIN =='Total')
mapIndianState <- ddply(mapIndianState, 'STATE', numcolwise(sum))
colnames(mapIndianState) <- c('region', 'value')
choroplethr(mapIndianState, "state", title = 'American Indian and Alaska Native Population by State', num_buckets=4)  + scale_fill_brewer(palette=15)

#map Asian Population by State
mapAsianState <- subset(popAll, RACE =='Asian' & SEX =='Total' & ORIGIN =='Total')
mapAsianState <- ddply(mapAsianState, 'STATE', numcolwise(sum))
colnames(mapAsianState) <- c('region', 'value')
choroplethr(mapAsianState, "state", title = 'Asian Population by State', num_buckets=4)  + scale_fill_brewer(palette=4)

#map Native Hawaiian and Other Pacific Islander Population by State
mapHawaiiState <- subset(popAll, RACE =='Native Hawaiian and Other Pacific Islander' & SEX =='Total' & ORIGIN =='Total')
mapHawaiiState <- ddply(mapHawaiiState, 'STATE', numcolwise(sum))
colnames(mapHawaiiState) <- c('region', 'value')
choroplethr(mapHawaiiState, "state", title = 'Native Hawaiian and Other Pacific Islander Population by State', num_buckets=4)  + scale_fill_brewer(palette=3)

#map Hispanic Population by State
mapHispanicState <- subset(popAll, SEX =='Total' & ORIGIN =='Hispanic')
mapHispanicState <- ddply(mapHispanicState, 'STATE', numcolwise(sum))
colnames(mapHispanicState) <- c('region', 'value')
choroplethr(mapHispanicState, "state", title = 'Hispanic Population by State', num_buckets=4) + scale_fill_brewer(palette=18)

#male ratio by state
maleRatio <- subset(popAll, SEX == 'Male')
maleRatio <- ddply(maleRatio, 'STATE', numcolwise(sum))
for (i in 1:51)
{
  maleRatio[i,"POPULATION"] <- round(maleRatio[i,"POPULATION"] / totalPopState[i,"POPULATION"], digits = 3 ) 
}
colnames(maleRatio) <- c("region", 'value')
choroplethr(maleRatio, "state", title = 'Male Ratio by State')

#population by age in CA
ageCA <- subset(popAll, STATE =='CA' & SEX =='Total' & ORIGIN =='Total')
ageCA <- ddply(ageCA, 'AGE', numcolwise(sum))
ageCA$POPULATION <- as.numeric(ageCA$POPULATION)
ageCA$AGE <- as.numeric(ageCA$AGE)
ggplot(ageCA, aes(x = AGE, y = POPULATION, fill = factor(POPULATION))) + ggtitle("Total Population by Age in CA") + geom_histogram(stat = "identity") + scale_y_continuous(labels = comma) + guides(fill=FALSE)

#population by age in TX
ageTX <- subset(popAll, STATE =='TX'& SEX =='Total' & ORIGIN =='Total')
ageTX <- ddply(ageTX, 'AGE', numcolwise(sum))
ageTX$POPULATION <- as.numeric(ageTX$POPULATION)
ageTX$AGE <- as.numeric(ageTX$AGE)
ggplot(ageTX, aes(x = AGE, y = POPULATION, fill = factor(POPULATION))) + ggtitle("Total Population by Age in TX") + geom_histogram(stat = "identity") + scale_y_continuous(labels = comma) + guides(fill=FALSE)
