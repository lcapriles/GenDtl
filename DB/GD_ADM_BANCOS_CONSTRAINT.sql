--------------------------------------------------------
--  Constraints for Table GD_ADM_BANCOS
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_ADM_BANCOS" MODIFY ("CODBANCO" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_ADM_BANCOS" MODIFY ("NOMBRE_BANCO" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_ADM_BANCOS" ADD CONSTRAINT "GD_ADM_BANCOS_PK" PRIMARY KEY ("CODBANCO") USING INDEX  ENABLE;
