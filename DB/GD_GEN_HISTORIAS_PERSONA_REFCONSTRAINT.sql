--------------------------------------------------------
--  Ref Constraints for Table GD_GEN_HISTORIAS_PERSONA
--------------------------------------------------------

  ALTER TABLE "GDCNO"."GD_GEN_HISTORIAS_PERSONA" ADD CONSTRAINT "FK_HISTORIAS_PERSONA_GD_GEN_PE" FOREIGN KEY ("NUMHISTORIA") REFERENCES "GDCNO"."GD_GEN_PERSONAS" ("NUMHISTORIA") DISABLE;
