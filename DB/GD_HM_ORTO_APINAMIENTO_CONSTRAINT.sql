--------------------------------------------------------
--  Constraints for Table GD_HM_ORTO_APINAMIENTO
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_HM_ORTO_APINAMIENTO" MODIFY ("CODIGO" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_HM_ORTO_APINAMIENTO" ADD CONSTRAINT "GD_HM_ORTO_APINAMIENTO_PK" PRIMARY KEY ("CODIGO") USING INDEX  ENABLE;
