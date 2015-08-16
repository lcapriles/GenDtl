--------------------------------------------------------
--  DDL for Table GD_GEN_SEDES
--------------------------------------------------------

  CREATE TABLE "GDCNO"."GD_GEN_SEDES" ("CODSEDE" VARCHAR2(6 BYTE), "NOMSEDE" VARCHAR2(120 BYTE), "NUMHISTORIA" NUMBER(6,0) DEFAULT 0, "LETRAHISTORIA" VARCHAR2(4 BYTE)) ;

   COMMENT ON COLUMN "GDCNO"."GD_GEN_SEDES"."NUMHISTORIA" IS 'Número de la última Historia registrada en la Sede';
