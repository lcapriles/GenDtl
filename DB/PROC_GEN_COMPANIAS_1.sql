--------------------------------------------------------
--  DDL for Package Body PROC_GEN_COMPANIAS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "GDCNO"."PROC_GEN_COMPANIAS" 
AS
   /******************************************************************************
      NAME:       PROC_GEN_COMPANIAS
      PURPOSE:

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        24-04-2014      Agustín       1. Created this package.
   ******************************************************************************/
   FUNCTION OBTIENE_DIRECCIONFISCAL (
      pCodCompania GD_GEN_COMPANIAS.CODCOMPANIA%TYPE)
      RETURN VARCHAR2
   IS
    vVar VARCHAR2(1000);
    BEGIN           
        BEGIN
            SELECT DireccionFiscal
            INTO vVar 
            FROM GD_GEN_COMPANIAS
            WHERE CodCompania = pCodCompania;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            vVar := 'Compañia '||pCodCompania||' NO EXISTE';
        END;
    RETURN vVar;
    END;                        

   FUNCTION OBTIENE_RIFCOMPANIA (
      pCodCompania GD_GEN_COMPANIAS.CODCOMPANIA%TYPE)
      RETURN VARCHAR2
   IS
    vVar VARCHAR2(20);
    BEGIN           
        BEGIN
            SELECT RIFCOMPANIA
            INTO vVar 
            FROM GD_GEN_COMPANIAS
            WHERE CodCompania = pCodCompania;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            vVar := '****';
        END;
    RETURN vVar;
    END;             

   FUNCTION OBTIENE_NOMCOMPANIA (
      pCodCompania GD_GEN_COMPANIAS.CODCOMPANIA%TYPE)
      RETURN VARCHAR2
   IS
    vVar VARCHAR2(120);
    BEGIN           
        BEGIN
            SELECT NomCompania
            INTO vVar 
            FROM GD_GEN_COMPANIAS
            WHERE CodCompania = pCodCompania;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            vVar := 'Compañia '||pCodCompania||' NO EXISTE';
        END;
    RETURN vVar;
    END;                 
END   PROC_GEN_COMPANIAS;
