--------------------------------------------------------
--  Constraints for Table GD_CC_ENCUESTA_REALIZADA
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_CC_ENCUESTA_REALIZADA" MODIFY ("ENCREALIZADAID" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_CC_ENCUESTA_REALIZADA" MODIFY ("LLAMADAID" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_CC_ENCUESTA_REALIZADA" MODIFY ("ENCUESTAID" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_CC_ENCUESTA_REALIZADA" ADD CONSTRAINT "PK_GD_CC_ENCUESTA_REALIZADA" PRIMARY KEY ("ENCREALIZADAID") USING INDEX  ENABLE;