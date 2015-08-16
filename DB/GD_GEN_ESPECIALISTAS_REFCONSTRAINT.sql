--------------------------------------------------------
--  Ref Constraints for Table GD_GEN_ESPECIALISTAS
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_GEN_ESPECIALISTAS" ADD CONSTRAINT "GD_GEN_ESPECIALISTAS_GD_G_FK1" FOREIGN KEY ("CODSEDE", "CODSERVICIO") REFERENCES "GDCNO"."GD_GEN_SERV_SEDES" ("CODSEDE", "CODSERVICIO") DISABLE;
