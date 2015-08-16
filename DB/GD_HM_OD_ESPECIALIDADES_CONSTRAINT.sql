--------------------------------------------------------
--  Constraints for Table GD_HM_OD_ESPECIALIDADES
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_HM_OD_ESPECIALIDADES" MODIFY ("ESPECIALIDAD" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_HM_OD_ESPECIALIDADES" ADD CONSTRAINT "GD_HM_OD_ESPECIALIDADES_PK" PRIMARY KEY ("ESPECIALIDAD") USING INDEX  ENABLE;
