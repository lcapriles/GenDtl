--------------------------------------------------------
--  Constraints for Table GD_CC_ESTACIONES_LLAMADAS
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_CC_ESTACIONES_LLAMADAS" MODIFY ("ESTACIONID" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_CC_ESTACIONES_LLAMADAS" ADD CONSTRAINT "PK_GD_CC_ESTACIONES_LLAMADAS" PRIMARY KEY ("ESTACIONID") USING INDEX  ENABLE;
