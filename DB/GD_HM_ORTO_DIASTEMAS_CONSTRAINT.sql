--------------------------------------------------------
--  Constraints for Table GD_HM_ORTO_DIASTEMAS
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_HM_ORTO_DIASTEMAS" MODIFY ("CODIGO" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_HM_ORTO_DIASTEMAS" ADD CONSTRAINT "GD_HM_ORTO_DIASTEMAS_PK" PRIMARY KEY ("CODIGO") USING INDEX  ENABLE;
