--------------------------------------------------------
--  DDL for Package PROC_UTIL
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "GDCNO"."PROC_UTIL" AS
/******************************************************************************
   NAME:       PROC_UTIL
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        15-05-2014      Agustín       1. Created this package.
******************************************************************************/
    TYPE vOpciones IS RECORD
            (ID NUMBER(3),
             PID NUMBER(3),
             LINK VARCHAR2(40),
             LEVEL NUMBER(1)
            );                   
    TYPE vTablaOpciones IS TABLE OF vOpciones INDEX BY PLS_INTEGER;    
    vMatrizOpciones         vTablaOpciones;     
    vCantOpciones           NUMBER(3) := 0;

    FUNCTION CONTADORES_SEDES (pCodSede VARCHAR2, pContador VARCHAR2 DEFAULT 'HISTORIA') RETURN VARCHAR2;
    PROCEDURE CARGA_OPCIONES_MENU;
    FUNCTION GENERA_RIF (pLetraID VARCHAR2, pNumeroID VARCHAR2) RETURN VARCHAR2;
    FUNCTION VERIFICA_SEGURIDAD(pPagina VARCHAR2,
                                pUserID VARCHAR2,
                                pSecurityGroupID NUMBER
                                ) RETURN BOOLEAN;

END PROC_UTIL;
