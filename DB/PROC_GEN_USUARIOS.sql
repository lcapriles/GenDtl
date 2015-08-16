--------------------------------------------------------
--  DDL for Package PROC_GEN_USUARIOS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "GDCNO"."PROC_GEN_USUARIOS" AS
/******************************************************************************
   NAME:       PROC_GEN_USUARIOS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        24-04-2014      Agustín       1. Created this package.
******************************************************************************/
    FUNCTION VALIDA_USUARIO (pCODCOMPANIA out GD_GEN_USUARIOS.CODCOMPANIA%TYPE,
                             pCODSEDE out GD_GEN_USUARIOS.CODSEDE%TYPE) 
                             RETURN VARCHAR2;
    
END PROC_GEN_USUARIOS;
