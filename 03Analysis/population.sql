-- Total Pop: 316,428,186
select sum(CENSUS2010POP) as Total_Pop
  from POPULATION --INNER JOIN STATE
    -- on POPULATION.STATE_ID = STATE.STATE_ID
  where ORIGIN_ID = 0 and SEX_ID = 0
;

select sum(CENSUS2010POP) as Total_Pop
  from POPULATION
  where (ORIGIN_ID = 1 or ORIGIN_ID = 2) and (SEX_ID = 1 or SEX_ID = 2)
;

-- Origin Non Hispanic: 264,369,462
select sum(CENSUS2010POP) as Total_Pop
  from POPULATION
  where ORIGIN_ID = 1 and SEX_ID = 0
;

-- Origin Hispanic = 52,058,724
select sum(CENSUS2010POP) as Total_Pop
  from POPULATION
  where ORIGIN_ID = 2 and SEX_ID = 0
;

----------------------------------------------------------------------------------

--total population by age
select p.AGE as Age, sum(p.CENSUS2010POP) as Population
  from POPULATION p 
  where p.ORIGIN_ID = 0 and p.SEX_ID = 0
  group by p.AGE
  order by p.AGE asc
;



----------------------------------------------------------------------------------

--total population by race
select r.RACE_NAME as Race, sum(p.CENSUS2010POP) as Population
  from POPULATION p 
    INNER JOIN RACE r on  p.RACE_ID = r.RACE_ID
  where p.ORIGIN_ID = 0 and p.SEX_ID = 0
  group by r.RACE_NAME
  order by r.RACE_NAME asc
;

----------------------------------------------------------------------------------

--total population by state, age
select s.STATE_NAME as State, p.AGE as Age, sum(p.CENSUS2010POP) as Population
  from POPULATION p 
    INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
  where p.ORIGIN_ID = 0 and p.SEX_ID = 0
  group by s.STATE_NAME, p.AGE
  order by s.STATE_NAME, p.AGE asc
;

--total population by state = Cali, age, sex
select p.AGE as Age, s2.SEX_NAME as Sex, sum(p.CENSUS2010POP) as Population
  from POPULATION p
     INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
     INNER JOIN SEX s2 on p.SEX_ID = s2.SEX_ID
  where p.ORIGIN_ID = 0 and (p.SEX_ID = 1 or p.SEX_ID = 2) and s.STATE_NAME = 'CA'
  group by  p.AGE, s2.SEX_NAME
  order by  p.AGE, s2.SEX_NAME asc
;

--total population by state, age, sex
select s.STATE_NAME as State, p.AGE as Age, s2.SEX_NAME as Sex, sum(p.CENSUS2010POP) as Population
  from POPULATION p
     INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
     INNER JOIN SEX s2 on p.SEX_ID = s2.SEX_ID
  where p.ORIGIN_ID = 0 and (p.SEX_ID = 1 or p.SEX_ID = 2)
  group by s.STATE_NAME, p.AGE, s2.SEX_NAME
  order by s.STATE_NAME, p.AGE, s2.SEX_NAME asc
;
--------

--total population by state, race, age, sex
select s.STATE_NAME as State, r.RACE_NAME as Race, p.AGE as Age, s2.SEX_NAME as Sex, sum(p.CENSUS2010POP) as Population
  from POPULATION p
     INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
     INNER JOIN RACE r on  p.RACE_ID = r.RACE_ID
     INNER JOIN SEX s2 on p.SEX_ID = s2.SEX_ID
  where p.ORIGIN_ID = 0 and (p.SEX_ID = 1 or p.SEX_ID = 2)
  group by s.STATE_NAME, r.RACE_NAME, p.AGE, s2.SEX_NAME
  order by s.STATE_NAME, r.RACE_NAME, p.AGE, s2.SEX_NAME asc
;
----------------------------------------------------------------------------------

--total population by state, race
select s.STATE_NAME as State, r.RACE_NAME as Race, sum(p.CENSUS2010POP) as Population
  from POPULATION p
     INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
     INNER JOIN RACE r on  p.RACE_ID = r.RACE_ID
  where p.ORIGIN_ID = 0 and p.SEX_ID = 0
  group by s.STATE_NAME, r.RACE_NAME
  order by s.STATE_NAME asc
;

--total population by state, race = white
select s.STATE_NAME as State, r.RACE_NAME as Race, sum(p.CENSUS2010POP) as Population
  from POPULATION p
     INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
     INNER JOIN RACE r on  p.RACE_ID = r.RACE_ID
  where p.ORIGIN_ID = 0 and p.SEX_ID = 0 and r.RACE_ID = 1
  group by s.STATE_NAME, r.RACE_NAME
  order by s.STATE_NAME asc
;

--total population by state, race = black
select s.STATE_NAME as State, r.RACE_NAME as Race, sum(p.CENSUS2010POP) as Population
  from POPULATION p
     INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
     INNER JOIN RACE r on  p.RACE_ID = r.RACE_ID
  where p.ORIGIN_ID = 0 and p.SEX_ID = 0 and r.RACE_ID = 2
  group by s.STATE_NAME, r.RACE_NAME
  order by s.STATE_NAME asc
;

--total population by state, race = Native Indian
select s.STATE_NAME as State, r.RACE_NAME as Race, sum(p.CENSUS2010POP) as Population
  from POPULATION p
     INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
     INNER JOIN RACE r on  p.RACE_ID = r.RACE_ID
  where p.ORIGIN_ID = 0 and p.SEX_ID = 0 and r.RACE_ID = 3
  group by s.STATE_NAME, r.RACE_NAME
  order by s.STATE_NAME asc
;

--total population by state, race = asian
select s.STATE_NAME as State, r.RACE_NAME as Race, sum(p.CENSUS2010POP) as Population
  from POPULATION p
     INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
     INNER JOIN RACE r on  p.RACE_ID = r.RACE_ID
  where p.ORIGIN_ID = 0 and p.SEX_ID = 0 and r.RACE_ID = 4
  group by s.STATE_NAME, r.RACE_NAME
  order by s.STATE_NAME asc
;

--total population by state, race = Pacific Islander
select s.STATE_NAME as State, r.RACE_NAME as Race, sum(p.CENSUS2010POP) as Population
  from POPULATION p
     INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
     INNER JOIN RACE r on  p.RACE_ID = r.RACE_ID
  where p.ORIGIN_ID = 0 and p.SEX_ID = 0 and r.RACE_ID = 5
  group by s.STATE_NAME, r.RACE_NAME
  order by s.STATE_NAME asc
;


--total population by origin, state, race
select o.ORIGIN_NAME as Origin, s.STATE_NAME as State, r.RACE_NAME as Race, sum(p.CENSUS2010POP) as Population
  from POPULATION p
     INNER JOIN STATE s on p.STATE_ID = s.STATE_ID
     INNER JOIN RACE r on  p.RACE_ID = r.RACE_ID
     INNER JOIN ORIGIN o on  p.ORIGIN_ID = o.ORIGIN_ID
  where p.SEX_ID = 0
  group by s.STATE_NAME, r.RACE_NAME, o.ORIGIN_NAME
  order by s.STATE_NAME asc
;

--total population by sex, race
select s.SEX_NAME as Sex, r.RACE_NAME as Race, sum(p.CENSUS2010POP) as Population
  from POPULATION p
     INNER JOIN SEX s on p.SEX_ID = s.SEX_ID
     INNER JOIN RACE r on  p.RACE_ID = r.RACE_ID
  where p.ORIGIN_ID = 0
  group by s.SEX_NAME, r.RACE_NAME
  order by r.RACE_NAME asc
;

--total population by division, race
select d.DIVISION_NAME as Division, r.RACE_NAME as Race, sum(p.CENSUS2010POP) as Population
  from POPULATION p
     INNER JOIN DIVISION d on p.DIVISION_ID = d.DIVISION_ID
     INNER JOIN RACE r on  p.RACE_ID = r.RACE_ID
  where p.ORIGIN_ID = 0 and p.SEX_ID = 0
  group by d.DIVISION_NAME, r.RACE_NAME
  order by d.DIVISION_NAME asc
;

