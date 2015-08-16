--------------------------------------------------------
--  DDL for Package PROC_PRESUPUESTO
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "GDCNO"."PROC_PRESUPUESTO" AS
/******************************************************************************
   NAME:       PROC_PRESUPUESTO
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        7/25/2013      Agustín Botana       1. Created this package.
******************************************************************************/

  PROCEDURE APROBAR_PRESUPUESTO (pCodSede VARCHAR2, pNUMPRESUPUESTO VARCHAR2); 
  FUNCTION BUSCA_CONTADOR(pCodCompania VARCHAR2, pFechaPpto DATE) RETURN NUMBER;

END PROC_PRESUPUESTO;
