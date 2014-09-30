--------------------------------------------------------
--  File created - Monday-September-15-2014   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table ORIGIN
--------------------------------------------------------

  CREATE TABLE "C##CS347_HNP248"."ORIGIN" 
   (	"ORIGIN_ID" VARCHAR2(1 BYTE), 
	"ORIGIN_NAME" VARCHAR2(20 BYTE)
   ) ;
REM INSERTING into C##CS347_HNP248.ORIGIN
SET DEFINE OFF;
Insert into C##CS347_HNP248.ORIGIN (ORIGIN_ID,ORIGIN_NAME) values ('1','Not Hispanic');
Insert into C##CS347_HNP248.ORIGIN (ORIGIN_ID,ORIGIN_NAME) values ('0','Total');
Insert into C##CS347_HNP248.ORIGIN (ORIGIN_ID,ORIGIN_NAME) values ('2','Hispanic');
