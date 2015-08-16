--------------------------------------------------------
--  Constraints for Table GD_HM_ORTO_APSP
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_HM_ORTO_APSP" MODIFY ("CODIGO" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_HM_ORTO_APSP" ADD CONSTRAINT "GD_HM_ORTO_APSP_PK" PRIMARY KEY ("CODIGO") USING INDEX  ENABLE;
