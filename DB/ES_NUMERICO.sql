--------------------------------------------------------
--  DDL for Function ES_NUMERICO
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "GDCNO"."ES_NUMERICO" (pValor VARCHAR2) RETURN NUMBER IS
   vNumero NUMBER;
BEGIN
   vNumero := TO_NUMBER(pValor);
   RETURN 1;
EXCEPTION
WHEN VALUE_ERROR THEN
   RETURN 0;
END ES_NUMERICO;
