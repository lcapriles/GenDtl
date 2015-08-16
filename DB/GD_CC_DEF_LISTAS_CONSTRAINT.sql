--------------------------------------------------------
--  Constraints for Table GD_CC_DEF_LISTAS
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_CC_DEF_LISTAS" MODIFY ("LISTAID" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_CC_DEF_LISTAS" ADD CONSTRAINT "PK_GD_CC_LISTAS" PRIMARY KEY ("LISTAID") USING INDEX  ENABLE;
