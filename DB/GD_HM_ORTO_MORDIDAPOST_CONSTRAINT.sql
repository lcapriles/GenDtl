--------------------------------------------------------
--  Constraints for Table GD_HM_ORTO_MORDIDAPOST
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_HM_ORTO_MORDIDAPOST" MODIFY ("CODIGO" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_HM_ORTO_MORDIDAPOST" ADD CONSTRAINT "GD_HM_ORTO_MORDIDAPOST_PK" PRIMARY KEY ("CODIGO") USING INDEX  ENABLE;
