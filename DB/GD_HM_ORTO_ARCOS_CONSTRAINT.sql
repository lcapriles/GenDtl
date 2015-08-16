--------------------------------------------------------
--  Constraints for Table GD_HM_ORTO_ARCOS
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_HM_ORTO_ARCOS" MODIFY ("ARCO" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_HM_ORTO_ARCOS" ADD CONSTRAINT "GD_HM_ORTO_ARCOS_PK" PRIMARY KEY ("ARCO") USING INDEX  ENABLE;
