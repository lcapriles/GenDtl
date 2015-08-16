--------------------------------------------------------
--  Constraints for Table GD_HM_OD_HALLAZGOS_AREAS
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_HM_OD_HALLAZGOS_AREAS" MODIFY ("HALLAZGO" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_HM_OD_HALLAZGOS_AREAS" MODIFY ("AREA" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_HM_OD_HALLAZGOS_AREAS" ADD CONSTRAINT "GD_HM_OD_HALLAZGOS_AREAS_PK" PRIMARY KEY ("HALLAZGO", "AREA") USING INDEX  ENABLE;