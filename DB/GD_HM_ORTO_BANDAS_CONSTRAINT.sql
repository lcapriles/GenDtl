--------------------------------------------------------
--  Constraints for Table GD_HM_ORTO_BANDAS
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_HM_ORTO_BANDAS" MODIFY ("BANDA" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_HM_ORTO_BANDAS" ADD CONSTRAINT "GD_HM_ORTO_BANDAS_PK" PRIMARY KEY ("BANDA") USING INDEX  ENABLE;
