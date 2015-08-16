--------------------------------------------------------
--  Constraints for Table GD_CC_TEXTOS
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_CC_TEXTOS" ADD CONSTRAINT "GD_CC_TEXTOS_UK1" UNIQUE ("NOMBRETEXTO") USING INDEX  ENABLE;
  ALTER TABLE "GDCNO"."GD_CC_TEXTOS" ADD CONSTRAINT "GD_CC_TEXTOS_PK" PRIMARY KEY ("TEXTOID") USING INDEX  ENABLE;
