--------------------------------------------------------
--  Constraints for Table GD_HM_ORTO_AUX
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_HM_ORTO_AUX" MODIFY ("CODIGO" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_HM_ORTO_AUX" ADD CONSTRAINT "HM_ORTO_AUX_PK" PRIMARY KEY ("CODIGO") USING INDEX  ENABLE;
