--------------------------------------------------------
--  DDL for Trigger VALIDA_LINEA
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "GDCNO"."VALIDA_LINEA" 
BEFORE INSERT ON GD_ADM_FACTURAS_RENG  
FOR EACH ROW
BEGIN
  IF :NEW.NUMERO_LINEA > 5 THEN 
     RAISE_APPLICATION_ERROR(-20201,'Este renglón excede el máximo de 5 lineas por factura');
  END IF;
END;
ALTER TRIGGER "GDCNO"."VALIDA_LINEA" DISABLE
