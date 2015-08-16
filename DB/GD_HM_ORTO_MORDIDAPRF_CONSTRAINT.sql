--------------------------------------------------------
--  Constraints for Table GD_HM_ORTO_MORDIDAPRF
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_HM_ORTO_MORDIDAPRF" MODIFY ("CODIGO" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_HM_ORTO_MORDIDAPRF" ADD CONSTRAINT "GD_HM_ORTO_MORDIDAPRF_PK" PRIMARY KEY ("CODIGO") USING INDEX  ENABLE;
