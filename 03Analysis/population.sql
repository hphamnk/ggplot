select sum(CENSUS2010POP) as Total_Pop
  from POPULATION INNER JOIN STATE
    on POPULATION.STATE_ID = STATE.STATE_ID
--  where STATE_NAME = 'Texas' and RACE_ID = 1
;

--total population by states
select s.STATE_NAME, sum(p.CENSUS2010POP)
  from POPULATION p 
    INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
  group by s.STATE_NAME
  order by s.STATE_NAME asc
;

--total population by state, race
select s.STATE_NAME, r.RACE_NAME, sum(p.CENSUS2010POP)
  from POPULATION p
     INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
     INNER JOIN RACE r on  p.RACE_ID = r.RACE_ID
  group by s.STATE_NAME, r.RACE_NAME
  order by s.STATE_NAME asc
;

--total population by division, race
select d.DIVISION_NAME, r.RACE_NAME, sum(p.CENSUS2010POP)
  from POPULATION p
     INNER JOIN DIVISION d on p.DIVISION_ID = d.DIVISION_ID
     INNER JOIN RACE r on  p.RACE_ID = r.RACE_ID
  group by d.DIVISION_NAME, r.RACE_NAME
  order by d.DIVISION_NAME asc
;