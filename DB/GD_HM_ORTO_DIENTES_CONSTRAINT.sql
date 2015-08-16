--------------------------------------------------------
--  Constraints for Table GD_HM_ORTO_DIENTES
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_HM_ORTO_DIENTES" MODIFY ("DIENTE" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_HM_ORTO_DIENTES" ADD CONSTRAINT "GD_HM_ORTO_DIENTES_PK" PRIMARY KEY ("DIENTE") USING INDEX  ENABLE;
