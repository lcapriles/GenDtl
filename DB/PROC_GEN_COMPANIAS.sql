--------------------------------------------------------
--  DDL for Package PROC_GEN_COMPANIAS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "GDCNO"."PROC_GEN_COMPANIAS" 
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
      pCodCompania IN GD_GEN_COMPANIAS.CODCOMPANIA%TYPE)
      RETURN VARCHAR2;
      
   FUNCTION OBTIENE_RIFCOMPANIA (
      pCodCompania IN GD_GEN_COMPANIAS.CODCOMPANIA%TYPE)
      RETURN VARCHAR2; 
      
   FUNCTION OBTIENE_NOMCOMPANIA (
      pCodCompania IN GD_GEN_COMPANIAS.CODCOMPANIA%TYPE)
      RETURN VARCHAR2;           
END PROC_GEN_COMPANIAS;
