--------------------------------------------------------
--  Constraints for Table GD_HM_ORTO_CLASIFICACIONESQ
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_HM_ORTO_CLASIFICACIONESQ" MODIFY ("CODIGO" NOT NULL ENABLE);
  ALTER TABLE "GDCNO"."GD_HM_ORTO_CLASIFICACIONESQ" ADD CONSTRAINT "GD_HM_ORTO_CLASIFICACIONES_PK" PRIMARY KEY ("CODIGO") USING INDEX  ENABLE;
