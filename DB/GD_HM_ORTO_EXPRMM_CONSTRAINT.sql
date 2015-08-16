--------------------------------------------------------
--  Constraints for Table GD_HM_ORTO_EXPRMM
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_HM_ORTO_EXPRMM" MODIFY ("CODIGO" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_HM_ORTO_EXPRMM" ADD CONSTRAINT "GD_HM_ORTO_EXPRMM_PK" PRIMARY KEY ("CODIGO") USING INDEX  ENABLE;
