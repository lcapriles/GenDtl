--------------------------------------------------------
--  Constraints for Table GD_CJA_CAJAS
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_CJA_CAJAS" MODIFY ("CODSEDE" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_CJA_CAJAS" ADD CONSTRAINT "GD_CJA_CJS_PK" PRIMARY KEY ("CAJA_NUMERO", "CODSEDE") USING INDEX  ENABLE;
