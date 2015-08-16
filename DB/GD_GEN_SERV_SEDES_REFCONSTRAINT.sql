--------------------------------------------------------
--  Ref Constraints for Table GD_GEN_SERV_SEDES
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_GEN_SERV_SEDES" ADD CONSTRAINT "GD_SEDES_SERVSEDES_FK" FOREIGN KEY ("CODSEDE") REFERENCES "GDCNO"."GD_GEN_SEDES" ("CODSEDE") ENABLE;
