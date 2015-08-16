--------------------------------------------------------
--  Constraints for Table GD_HM_ORTO_ELASTICOS
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_HM_ORTO_ELASTICOS" MODIFY ("CODIGO" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_HM_ORTO_ELASTICOS" ADD CONSTRAINT "GD_HM_ORTO_ELASTICOS_PK" PRIMARY KEY ("CODIGO") USING INDEX  ENABLE;
