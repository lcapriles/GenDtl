--------------------------------------------------------
--  Constraints for Table GD_HM_OD_DIENTES
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_HM_OD_DIENTES" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_HM_OD_DIENTES" MODIFY ("DIENTE" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_HM_OD_DIENTES" ADD CONSTRAINT "GD_HM_DIENTE_PK" PRIMARY KEY ("ID") USING INDEX  ENABLE;
