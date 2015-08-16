--------------------------------------------------------
--  DDL for Table GD_GEN_COMPANIAS
--------------------------------------------------------

  CREATE TABLE "GDCNO"."GD_GEN_COMPANIAS" ("CODCOMPANIA" VARCHAR2(6 BYTE), "RIFCOMPANIA" VARCHAR2(16 BYTE), "NOMCOMPANIA" VARCHAR2(120 BYTE), "DIRECCIONFISCAL" VARCHAR2(1000 BYTE)) ;

   COMMENT ON COLUMN "GDCNO"."GD_GEN_COMPANIAS"."DIRECCIONFISCAL" IS 'Dirección fiscal de la Compañia (sello de encabezado en reportes)';
