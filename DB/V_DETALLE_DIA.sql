--------------------------------------------------------
--  DDL for View V_DETALLE_DIA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "GDCNO"."V_DETALLE_DIA" ("CODCOMPANIA", "DESCRIPCION_ESPECIALIDAD", "FECHA_FACTURA", "CANTIDAD", "TOTAL", "EFECTIVO", "CREDITO", "DEBITO", "CHEQUE", "DEPOSITO") AS SELECT CODCOMPANIA,
       SC.NOMSERVICIO,
            TRUNC (T.FECHA_FACTURA),
            SUM (CANTIDAD) CANTIDAD,
            SUM (TOTAL) TOTAL,
            SUM (EFECTIVO) EFECTIVO,
            SUM (CREDITO) CREDITO,
            SUM (DEBITO) DEBITO,
            SUM (CHEQUE) CHEQUE,
            SUM (DEPOSITO) DEPOSITO
       FROM GD_GEN_SERVICIOS_CLINICOS SC,
            (                                                         -- TOTAL
             SELECT  F.CODCOMPANIA,
                     F.CODSERVICIO,
                     F.FECHA_FACTURA,
                     1 CANTIDAD,
                     RC.MONTO_INSTRUMENTO * -1 TOTAL,
                     0 EFECTIVO,
                     0 CREDITO,
                     0 DEBITO,
                     0 CHEQUE,
                     0 DEPOSITO
                FROM GD_ADM_FACTURAS F, 
                     GD_ADM_COBROS_RENG RC
               WHERE RC.NUMERO_FACTURA = F.NUMERO_FACTURA
             --
             UNION ALL
             --
             -- EFECTIVO
             SELECT F.CODCOMPANIA,
                    F.CODSERVICIO,
                    F.FECHA_FACTURA,
                    0 CANTIDAD,
                    0 TOTAL,
                    RC.MONTO_INSTRUMENTO * -1 EFECTIVO,
                    0 CREDITO,
                    0 DEBITO,
                    0 CHEQUE,
                    0 DEPOSITO
               FROM GD_ADM_FACTURAS F, 
                    GD_ADM_COBROS_RENG RC
              WHERE RC.NUMERO_FACTURA = F.NUMERO_FACTURA
                    AND RC.TIPO_INSTRUMENTO = 'EF'
             --
             UNION ALL
             --
             -- CREDITO
             SELECT F.CODCOMPANIA,
                    F.CODSERVICIO,
                    F.FECHA_FACTURA,
                    0 CANTIDAD,
                    0 TOTAL,
                    0 EFECTIVO,
                    RC.MONTO_INSTRUMENTO * -1 CREDITO,
                    0 DEBITO,
                    0 CHEQUE,
                    0 DEPOSITO
               FROM GD_ADM_FACTURAS F, 
                    GD_ADM_COBROS_RENG RC
              WHERE RC.NUMERO_FACTURA = F.NUMERO_FACTURA
                    AND RC.TIPO_INSTRUMENTO = 'TC'
             --
             UNION ALL
             --
             -- DEBITO
             SELECT F.CODCOMPANIA,
                    F.CODSERVICIO,
                    F.FECHA_FACTURA,
                    0 CANTIDAD,
                    0 TOTAL,
                    0 EFECTIVO,
                    0 CREDITO,
                    RC.MONTO_INSTRUMENTO * -1 DEBITO,
                    0 CHEQUE,
                    0 DEPOSITO
               FROM GD_ADM_FACTURAS F, GD_ADM_COBROS_RENG RC
              WHERE RC.NUMERO_FACTURA = F.NUMERO_FACTURA
                    AND RC.TIPO_INSTRUMENTO = 'TD'
             --
             UNION ALL
             --
             -- CHEQUE
             SELECT F.CODCOMPANIA,
                    F.CODSERVICIO,
                    F.FECHA_FACTURA,
                    0 CANTIDAD,
                    0 TOTAL,
                    0 EFECTIVO,
                    0 CREDITO,
                    0 DEBITO,
                    RC.MONTO_INSTRUMENTO * -1 CHEQUE,
                    0 DEPOSITO
               FROM GD_ADM_FACTURAS F, GD_ADM_COBROS_RENG RC
              WHERE RC.NUMERO_FACTURA = F.NUMERO_FACTURA
                    AND RC.TIPO_INSTRUMENTO = 'CH'
             --
             UNION ALL
             --
             -- DEPOSITO
             SELECT F.CODCOMPANIA,
                    F.CODSERVICIO,
                    F.FECHA_FACTURA,
                    0 CANTIDAD,
                    0 TOTAL,
                    0 EFECTIVO,
                    0 CREDITO,
                    0 DEBITO,
                    0 CHEQUE,
                    RC.MONTO_INSTRUMENTO * -1 DEPOSITO
               FROM GD_ADM_FACTURAS F, GD_ADM_COBROS_RENG RC
              WHERE RC.NUMERO_FACTURA = F.NUMERO_FACTURA
                    AND RC.TIPO_INSTRUMENTO = 'DP') T
      WHERE SC.CODSERVICIO = T.CODSERVICIO
   GROUP BY CODCOMPANIA, SC.NOMSERVICIO, TRUNC (T.FECHA_FACTURA)
