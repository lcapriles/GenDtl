--------------------------------------------------------
-- Archivo creado  - viernes-julio-24-2015   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package PROC_GEN_GENERAL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GDCNO"."PROC_GEN_GENERAL" AS
/******************************************************************************
   NAME:       PROC_PRESUPUESTO
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        7/25/2013      Agust�n Botana       1. Created this package.
******************************************************************************/

  PROCEDURE ACTUALIZA_HISTORIA(pPersonaID NUMBER, pCodSede VARCHAR2, pCodServicio VARCHAR2, pCodEspecialidad VARCHAR2, pCodEspecialista VARCHAR2, pNumPresupuesto VARCHAR2, pNumHistoria VARCHAR2); 
  FUNCTION BUSCA_HISTORIA(pPersonaID NUMBER, pCodSede VARCHAR2, pCodServicio VARCHAR2, pCodEspecialidad VARCHAR2, pCodEspecialista VARCHAR2) RETURN VARCHAR2;
  
  --Procedimiento para actualizar la �ltima/pr�xima visita...
  PROCEDURE ACTUALIZA_FECHAS_VISITA (pPersonaID NUMBER, 
                                     pCodSede VARCHAR2, 
                                     pCodServicio VARCHAR2, 
                                     pCodEspecialidad VARCHAR2, 
                                     pCodEspecialista VARCHAR2,  
                                     pNumHistoria VARCHAR2,
                                     pFechaUltimaVisita VARCHAR2,
                                     pFechaProximaVisita VARCHAR2);
                                     
  --Funci�n para devolver un subc�digo a partir de un delimitador...                                  
  FUNCTION SUB_CODIGO (pCodigo VARCHAR2,
                       pDelimitador VARCHAR2,
                       pOrdinal NUMBER)
                       RETURN VARCHAR2;
 
  --Funci�n para retornar todas las descripciones de una seleci�n m�ltiple... 
  FUNCTION DESCRIPCION_MULTIPLE (pTabla VARCHAR2,
                                 pCodigo VARCHAR2,
                                 pDelimitador VARCHAR2)
                                 RETURN VARCHAR2;                        

END PROC_GEN_GENERAL;

/
