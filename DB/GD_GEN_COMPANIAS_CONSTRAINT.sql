--------------------------------------------------------
--  Constraints for Table GD_GEN_COMPANIAS
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_GEN_COMPANIAS" MODIFY ("CODCOMPANIA" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_GEN_COMPANIAS" MODIFY ("RIFCOMPANIA" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_GEN_COMPANIAS" MODIFY ("NOMCOMPANIA" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_GEN_COMPANIAS" ADD CONSTRAINT "GD_GEN_COMPANIAS_PK" PRIMARY KEY ("CODCOMPANIA") USING INDEX  ENABLE;