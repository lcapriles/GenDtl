--------------------------------------------------------
--  Constraints for Table GD_HM_ORTO_PERFILES
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_HM_ORTO_PERFILES" MODIFY ("CODIGO" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_HM_ORTO_PERFILES" ADD CONSTRAINT "GD_HM_ORTO_PERFILES_PK" PRIMARY KEY ("CODIGO") USING INDEX  ENABLE;
