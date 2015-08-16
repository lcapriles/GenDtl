--------------------------------------------------------
--  Constraints for Table GD_HM_OD_AREAS
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_HM_OD_AREAS" MODIFY ("AREA" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_HM_OD_AREAS" ADD CONSTRAINT "GD_HM_OD_AREA_DIENTE_PK" PRIMARY KEY ("AREA") USING INDEX  ENABLE;
