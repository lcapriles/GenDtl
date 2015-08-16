--------------------------------------------------------
--  Constraints for Table GD_HM_ODONTOPEDIATRIA
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_HM_ODONTOPEDIATRIA" ADD CONSTRAINT "GD_HM_ODONTOPEDIATRIA_PK" PRIMARY KEY ("TRATAMIENTOID") USING INDEX  ENABLE
  ALTER TABLE "GDCNO"."GD_HM_ODONTOPEDIATRIA" MODIFY ("TRATAMIENTOID" NOT NULL ENABLE)
