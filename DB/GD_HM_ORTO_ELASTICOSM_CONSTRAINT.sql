--------------------------------------------------------
--  Constraints for Table GD_HM_ORTO_ELASTICOSM
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_HM_ORTO_ELASTICOSM" MODIFY ("CODIGO" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_HM_ORTO_ELASTICOSM" ADD CONSTRAINT "GD_HM_ORTO_ELASTICOSM_PK" PRIMARY KEY ("CODIGO") USING INDEX  ENABLE;
