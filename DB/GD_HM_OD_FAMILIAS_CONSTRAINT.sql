--------------------------------------------------------
--  Constraints for Table GD_HM_OD_FAMILIAS
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_HM_OD_FAMILIAS" MODIFY ("FAMILIA" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_HM_OD_FAMILIAS" ADD CONSTRAINT "GD_HM_OD_FAMILIAS_PK" PRIMARY KEY ("FAMILIA") USING INDEX  ENABLE;
