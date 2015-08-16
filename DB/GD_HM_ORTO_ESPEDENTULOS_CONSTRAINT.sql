--------------------------------------------------------
--  Constraints for Table GD_HM_ORTO_ESPEDENTULOS
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_HM_ORTO_ESPEDENTULOS" MODIFY ("CODIGO" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_HM_ORTO_ESPEDENTULOS" ADD CONSTRAINT "GD_HM_ORTO_ESPEDENTULOS_PK" PRIMARY KEY ("CODIGO") USING INDEX  ENABLE;
