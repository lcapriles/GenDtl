--------------------------------------------------------
--  Constraints for Table GD_HM_ORTO_ANGULOS
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_HM_ORTO_ANGULOS" MODIFY ("CODIGO" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_HM_ORTO_ANGULOS" ADD CONSTRAINT "GD_HM_ORTO_ANGULOS_PK" PRIMARY KEY ("CODIGO") USING INDEX  ENABLE;
