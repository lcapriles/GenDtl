--------------------------------------------------------
--  Constraints for Table GD_GEN_SEDES
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_GEN_SEDES" MODIFY ("CODSEDE" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_GEN_SEDES" MODIFY ("NOMSEDE" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_GEN_SEDES" ADD CONSTRAINT "GD_GEN_SEDES_PK" PRIMARY KEY ("CODSEDE") USING INDEX  ENABLE;
