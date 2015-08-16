--------------------------------------------------------
--  DDL for Package Body PROC_PRESUPUESTO
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "GDCNO"."PROC_PRESUPUESTO" AS
/******************************************************************************
   NAME:       PROC_PRESUPUESTO
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        7/25/2013      Agustín Botana       1. Created this package.
******************************************************************************/

PROCEDURE APROBAR_PRESUPUESTO (pCodSede VARCHAR2, pNUMPRESUPUESTO VARCHAR2) IS
  --
  CURSOR C_PRE IS
    SELECT *
    FROM GD_PPTO_PRESUPUESTOS
    WHERE CodSede = pCodSede 
        AND NUMPRESUPUESTO = pNUMPRESUPUESTO
        AND STSPRESUPUESTO IN ('PEN');
    R_PRE   C_PRE%ROWTYPE;
  --
  CURSOR C_RNG IS
    SELECT *
    FROM GD_PPTO_RENG_PRESUPUESTO
    WHERE CodSede = pCodSede 
        AND NUMPRESUPUESTO = pNUMPRESUPUESTO
    ORDER BY NUMRENGLON;
    --
    CURSOR C_ITM(pCODIGO_ITEM VARCHAR2)  IS
        SELECT *
        FROM GD_INV_ITEMS
        WHERE CodSede = pCodSede
           AND   CODIGO_ITEM = pCODIGO_ITEM;
    R_ITM2   C_ITM%ROWTYPE;         
    --
    vMonto              NUMBER(16,2) := 0;
    vFinanciamiento NUMBER(16,2)    := 0;
    vMontoCuota     NUMBER(16,2)    := 0;
    vFecha              DATE;    
    vResto              NUMBER(16,2)    := 0;
    vDiaFecha         NUMBER(2);
    vDiaCuota         NUMBER(2);
    vMesFecha        NUMBER(2);
    vAnoFecha        NUMBER(4);
    vFechaCuota     DATE;    
    vBaremo           NUMBER(15,2) := 0;
  BEGIN
    OPEN C_PRE;
    FETCH C_PRE INTO R_PRE;
    IF C_PRE%NOTFOUND THEN
        RAISE NO_DATA_FOUND;
    END IF; 
    CLOSE C_PRE;
    FOR R_RNG IN C_RNG LOOP
        OPEN C_ITM(R_RNG.CODIGO_ITEM);
        FETCH C_ITM INTO R_ITM2;
        CLOSE C_ITM;
        vMonto := (R_RNG.PRECIOUNITARIO * R_RNG.CANTRENGLON) * ((1 - NVL(R_RNG.AJUSTE,0)/100));
        vBaremo := (R_RNG.BAREMOUNITARIO * R_RNG.CANTRENGLON);  -- Monto total del Baremo (unitario * cantidad)              
        IF NVL(R_RNG.NUMCUOTAS,0) != 0 THEN -- Es un renglon que se divide en cuotas 
            vFinanciamiento := vMonto - NVL(R_RNG.Inicial,0);
            vMontoCuota     := vFinanciamiento / NVL(R_RNG.NUMCUOTAS,1);
            vResto              := vFinanciamiento;       
            -- Genera las cuotas 
            vFecha := TRUNC(SYSDATE);
            IF NVL(R_RNG.INICIAL,0) != 0 THEN  -- Tiene una primera cuota Inicial  
                INSERT INTO GD_ADM_CUOTAS 
                     (PERSONAID, NUMHISTORIA, NUMPRESUPUESTO, NUMCUOTA, CODSERVICIO, MTOCUOTA, CODSEDE, FECCUOTA, FECPAGO, STSCUOTA, NUMFACTURA, NUMRENGLON, CODIGO_ITEM, BAREMO,CODCOMPANIA)
                VALUES
                    (R_PRE.PersonaID, R_PRE.NumHistoria, R_PRE.NumPresupuesto, 0, R_PRE.CodServicio,  R_RNG.Inicial, pCodSede, SYSDATE, NULL, 'PEN', NULL, R_RNG.NumRenglon, R_RNG.CODIGO_ITEM, 0, V('GLOBALCompania'));
               --DBMS_OUTPUT.PUT_LINE('INSERTARÍA CUOTA '||' 0 ');
            END IF;            
            -- Prepara todo para las fechas de la cuotas mensuales 
            vDiaFecha   := TO_CHAR(SYSDATE,'DD');
            vMesFecha := TO_CHAR(SYSDATE,'MM');
            vAnoFecha := TO_CHAR(SYSDATE,'RRRR');
            DBMS_OUTPUT.PUT_LINE('VA A INICIAR GUARDANDO LA FECHA DEL DIA CON  '||vDIAFECHA||' '||VMESFECHA||' '||VANOFECHA);
            FOR I IN 1..R_RNG.NUMCUOTAS LOOP
                IF I = R_RNG.NUMCUOTAS THEN -- Llegó a la última cuota, lanza el resto 
                    vMontoCuota := vResto;
                END IF;   
                INSERT INTO GD_ADM_CUOTAS 
                     (PERSONAID,NUMHISTORIA, NUMPRESUPUESTO, NUMCUOTA, CODSERVICIO, MTOCUOTA, CODSEDE, FECCUOTA, FECPAGO, STSCUOTA, NUMFACTURA, NUMRENGLON, CODIGO_ITEM, BAREMO,CODCOMPANIA)                    
                VALUES
                    (R_PRE.PersonaID,R_PRE.NumHistoria, R_PRE.NumPresupuesto, I, R_PRE.CodServicio,  vMontoCuota, R_PRE.CodSede, vFecha, NULL, 'PEN', NULL, R_RNG.NumRenglon, R_RNG.CODIGO_ITEM, R_RNG.BAREMOCUOTA,V('GLOBALCompania')) ;                   
                -- DBMS_OUTPUT.PUT_LINE('INSERTARÍA CUOTA '||I||' MONTO '||vMontoCuota||' FECHA '||TO_CHAR(vFecha,'DD/MM/RRRR')||' PARA UN LAPSO DE '||R_ITM.DIAS_CUOTA);
                -- 
                IF R_ITM2.DIAS_CUOTA = 30 THEN
                    IF vMesFecha = 12 THEN
                        vAnoFecha := vAnoFecha + 1;
                        vMesFecha := 1;
                    ELSE
                        vMesFecha := vMesFecha + 1;
                    END IF;
                    vDiaCuota := vDiaFecha;
                    WHILE TRUE LOOP
                        BEGIN
                            vFechaCuota := TO_DATE(vDiaCuota||'/'||vMesFecha||'/'||vAnoFecha,'DD/MM/RRRR');
                            DBMS_OUTPUT.PUT_LINE('CONSTRUYÓ FECHA '||TO_DATE(VFECHACUOTA,'DD/MM/YYYY'));
                            EXIT;
                        EXCEPTION
                            WHEN OTHERS THEN
                                vDiaCuota := vDiaCuota - 1;
                        END;
                    END LOOP;
                    vFecha := vFechaCuota;
                ELSE
                    vFecha := vFecha + R_ITM2.DIAS_CUOTA;                    
                END IF;
                vResto := vResto - vMontoCuota;       
            END LOOP;
        ELSE -- Guarda el monto total del renglon como una sola cuota para que aparezca en caja 
            INSERT INTO GD_ADM_CUOTAS 
                 (PERSONAID, NUMHISTORIA, NUMPRESUPUESTO, NUMCUOTA, CODSERVICIO, MTOCUOTA, CODSEDE, FECCUOTA, FECPAGO, STSCUOTA, NUMFACTURA, NUMRENGLON, CODIGO_ITEM, BAREMO,CODCOMPANIA)                      
            VALUES
                (R_PRE.PersonaID, R_PRE.NumHistoria, R_PRE.NumPresupuesto, 1, R_PRE.CodServicio,  vMontoCuota, R_PRE.CodSede, SYSDATE, NULL, 'PEN', NULL, R_RNG.NumRenglon, R_RNG.CODIGO_ITEM, vBaremo,V('GLOBALCompania')) ;                
            --DBMS_OUTPUT.PUT_LINE('INSERTARÍA CUOTA UNICA  MONTO '||vMonto||' FECHA '||TRUNC(SYSDATE));
        END IF;      
        --
        -- Va a actualizar la relacion del Paciente con la Clínica 
        --
        PROC_GEN_GENERAL.ACTUALIZA_HISTORIA(R_PRE.PersonaID, R_PRE.CodSede, R_PRE.CodServicio, R_PRE.CodEspecialidad, R_PRE.CodEspecialista, R_PRE.NumPresupuesto,R_PRE.NumHistoria);     
    END LOOP;
    UPDATE GD_PPTO_PRESUPUESTOS
    SET STSPRESUPUESTO = 'APR'
    WHERE CodSede = pCodSede 
       AND  NUMPRESUPUESTO = pNUMPRESUPUESTO;
    COMMIT;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN -- estan mandando a aprobar un presupuesto que no existe. No hacemo nada
       NULL;
  END;
--
  FUNCTION BUSCA_CONTADOR(pCodCompania VARCHAR2, pFechaPpto DATE) RETURN NUMBER IS
    vContador NUMBER(4);
  BEGIN
    BEGIN
        SELECT Contador
        INTO vContador
        FROM GD_GEN_CONTADORES_DOCUMENTOS
        WHERE CodCompania = pCodCompania
          AND Tipo_Documento = 'PRESUPUESTO'
          AND SUB_TIPO_DOCUMENTO = '*'
          AND Ano = TO_CHAR(pFechaPpto,'RRRR') 
          AND Mes = TO_CHAR(pFechaPpto,'MM');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN -- No existe cointador pära la emnpresa en el periodo., es el primero
            INSERT INTO GD_GEN_CONTADORES_DOCUMENTOS
               (CodCompania, Ano, Mes, Contador, TIPO_DOCUMENTO, SUB_TIPO_DOCUMENTO )
            VALUES
               ( pCodCompania, TO_CHAR(pFechaPpto,'RRRR'), TO_CHAR(pFechaPpto,'MM'), 1, 'PRESUPUESTO', '*' );
               COMMIT;
            RETURN(1);
    END;
    vContador := vContador + 1;
    UPDATE GD_GEN_CONTADORES_DOCUMENTOS
    SET Contador = vContador
    WHERE CodCompania = pCodCompania 
      AND Tipo_Documento = 'PRESUPUESTO'
      AND Ano = TO_CHAR(pFechaPpto,'RRRR') 
      AND Mes  = TO_CHAR(pFechaPpto,'MM');
    COMMIT;
    RETURN(vContador);
  END;

END PROC_PRESUPUESTO;
