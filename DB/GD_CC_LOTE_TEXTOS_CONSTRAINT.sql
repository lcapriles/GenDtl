--------------------------------------------------------
--  Constraints for Table GD_CC_LOTE_TEXTOS
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_CC_LOTE_TEXTOS" MODIFY ("LOTETEXTOID" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_CC_LOTE_TEXTOS" ADD CONSTRAINT "PK_GD_CC_ENVIO_TEXTOS" PRIMARY KEY ("LOTETEXTOID") USING INDEX  ENABLE;
