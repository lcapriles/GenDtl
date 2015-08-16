--------------------------------------------------------
--  Constraints for Table GD_HM_ORTO_TUBOS
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_HM_ORTO_TUBOS" MODIFY ("CODIGO" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_HM_ORTO_TUBOS" ADD CONSTRAINT "GD_HM_ORTO_TUBOS_PK" PRIMARY KEY ("CODIGO") USING INDEX  ENABLE;
