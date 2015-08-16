--------------------------------------------------------
--  Constraints for Table GD_HM_ORTO_MORDIDAANT
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_HM_ORTO_MORDIDAANT" MODIFY ("CODIGO" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_HM_ORTO_MORDIDAANT" ADD CONSTRAINT "GD_HM_MORDIDA_ORTO_PK" PRIMARY KEY ("CODIGO") USING INDEX  ENABLE;
