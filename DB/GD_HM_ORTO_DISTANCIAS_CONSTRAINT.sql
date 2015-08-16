--------------------------------------------------------
--  Constraints for Table GD_HM_ORTO_DISTANCIAS
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_HM_ORTO_DISTANCIAS" MODIFY ("CODIGO" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_HM_ORTO_DISTANCIAS" ADD CONSTRAINT "GD_HM_ORTO_DISTANCIAS_PK" PRIMARY KEY ("CODIGO") USING INDEX  ENABLE;
