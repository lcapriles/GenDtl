--------------------------------------------------------
--  DDL for Package PROC_CAJAS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "GDCNO"."PROC_CAJAS" AS 

   --Procedimiento para facturar...
    FUNCTION FACTURAR (pSESSION_ID NUMBER,
                       pP7030_ERRORES_CARRITO VARCHAR2,
                       pP7030_ESPECIALIDAD VARCHAR2,
                       pP7030_ESPECIALIDADII VARCHAR2,
                       pP7030_ESPECIALISTA VARCHAR2,
                       pP7030_FACTURA1 IN OUT VARCHAR2,
                       pP7030_FACTURA2 IN OUT VARCHAR2,
                       pP7030_NUMERO_CONTROL IN OUT VARCHAR2,
                       pP7030_NRO_CONTROL2 IN OUT VARCHAR2,
                       pP7030_NUMERO_FACTURA2 IN OUT VARCHAR2,
                       pP7030_PRESUPUESTO VARCHAR2,
                       pP7030_CAJA_NUMERO VARCHAR2,
                       pP7030_NAC_RPAGO VARCHAR2,
                       pP7030_RESPONSABLE_PAGO_CI VARCHAR2, 
                       pP7030_RESPONSABLE_PAGO_NOMBRE VARCHAR2,
                       pP7030_TABULADOR VARCHAR2,
                       pGLOBALsede VARCHAR2,
                       pGLOBALcompania VARCHAR2)
                       RETURN NUMBER;
                       
    --Procedimiento para ajustar la factura...
    FUNCTION AJUSTAR_FACTURA (pSESSION_ID NUMBER,
                              pGLOBALsede VARCHAR2,
                              pGLOBALcompania VARCHAR2)
                              RETURN NUMBER;
                       
END PROC_CAJAS;
