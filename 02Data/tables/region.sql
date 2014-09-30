--------------------------------------------------------
--  File created - Monday-September-15-2014   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table REGION
--------------------------------------------------------

  CREATE TABLE "C##CS347_HNP248"."REGION" 
   (	"REGION_ID" VARCHAR2(1 BYTE), 
	"REGION_NAME" VARCHAR2(20 BYTE)
   ) ;
REM INSERTING into C##CS347_HNP248.REGION
SET DEFINE OFF;
Insert into C##CS347_HNP248.REGION (REGION_ID,REGION_NAME) values ('1','Northeast');
Insert into C##CS347_HNP248.REGION (REGION_ID,REGION_NAME) values ('3','South');
Insert into C##CS347_HNP248.REGION (REGION_ID,REGION_NAME) values ('4','West');
Insert into C##CS347_HNP248.REGION (REGION_ID,REGION_NAME) values ('2','Midwest');
