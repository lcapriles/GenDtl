--------------------------------------------------------
--  Constraints for Table GD_HM_ORTO_CLASIFICACION
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_HM_ORTO_CLASIFICACION" MODIFY ("CODIGO" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_HM_ORTO_CLASIFICACION" ADD CONSTRAINT "GD_HM_ORTO_CLASUFICACION_PK" PRIMARY KEY ("CODIGO") USING INDEX  ENABLE;
