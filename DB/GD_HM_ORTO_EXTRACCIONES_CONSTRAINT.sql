--------------------------------------------------------
--  Constraints for Table GD_HM_ORTO_EXTRACCIONES
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_HM_ORTO_EXTRACCIONES" MODIFY ("CODIGO" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_HM_ORTO_EXTRACCIONES" ADD CONSTRAINT "GD_HM_ORTO_EXTRACCIONES_PK" PRIMARY KEY ("CODIGO") USING INDEX  ENABLE;
