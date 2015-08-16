--------------------------------------------------------
--  DDL for Package Body PROC_CC_LISTAS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "GDCNO"."PROC_CC_LISTAS" AS
/******************************************************************************
   NAME:       PROC_CC_LISTAS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        27-12-2013      Agustín       1. Created this package.
******************************************************************************/
    FUNCTION EXPANDE_TEXTO(pR_LIS C_LIS%ROWTYPE, pR_DAT C_PRB%ROWTYPE,pTexto VARCHAR2) RETURN VARCHAR2 IS
        CURSOR C_PRESUPUESTO_CUOTAS_VENCIDAS IS
        -- Busca el Numero del Presupuesto de la Cuota Vencida 
            SELECT NumPresupuesto, SUM(MtoCuota) MontoVencido
            FROM GD_ADM_CUOTAS CUO
            WHERE CUO.PersonaID = pR_DAT.PER_PersonaID
                AND CodServicio LIKE NVL(pR_LIS.CodServicio,'%')||'%'
                AND (StsCuota = 'VEN'
                        OR (TRUNC(FecCuota) < TRUNC(SYSDATE)
                              AND StsCuota != 'PAG'))
            GROUP BY NumPresupuesto
            HAVING COUNT(*) BETWEEN NVL(pR_LIS.CuotasVencDesde,0) AND NVL(pR_LIS.CuotasVencHasta,99);

        vMontoVencido           NUMBER(14,2); 
        vNumeroPresupuesto  GD_ADM_CUOTAS.NUMPRESUPUESTO%TYPE;
        vFechaUltimaVisita      DATE;
        vNombrePaciente        VARCHAR2(250);
        vTextoFinal                 VARCHAR2(2500);

    BEGIN
        -- Precarga el texto final con lo ecibido 
        vTextoFinal := pTexto;
        -- Consigue los valores de las variables estandar del Sistema 
        --
        -- Busca el Numero de Presupuesto de las cuotas vencidas y reemplaza 
        DBMS_OUTPUT.PUT_LINE('ENTRA A EXPANDIR '||pTexto);
        OPEN C_PRESUPUESTO_CUOTAS_VENCIDAS;
        FETCH C_PRESUPUESTO_CUOTAS_VENCIDAS INTO vNumeroPresupuesto, vMontoVencido;
        CLOSE C_PRESUPUESTO_CUOTAS_VENCIDAS;
        DBMS_OUTPUT.PUT_LINE('va a reemplazar '||vNumeroPresupuesto);
        vTextoFinal := REPLACE(vTextoFinal, '&NumeroPresupuesto&', vNumeroPresupuesto);
        --
        -- Reemplaza la fecha de ultima visita
        DBMS_OUTPUT.PUT_LINE('va a reemplazar '|| TO_CHAR(R_DAT.HIS_FECULTVISITA,'DD/MM/YYYY'));
        vTextoFinal := REPLACE(vTextoFinal, '&FechaUltimaVisita&', TO_CHAR(R_DAT.HIS_FECULTVISITA,'DD/MM/YYYY'));
        -- Reemplaza nombre del Paciente
        DBMS_OUTPUT.PUT_LINE('va a reemplazar '|| TRIM(R_DAT.PER_APELLIDOSPERSONA)||', '||TRIM(R_DAT.PER_NOMBPERSONA));
        vTextoFinal := REPLACE(vTextoFinal, '&NombrePaciente&', TRIM(R_DAT.PER_APELLIDOSPERSONA)||', '||TRIM(R_DAT.PER_NOMBPERSONA));
        -- Reemplaza Monto Vencido 
        DBMS_OUTPUT.PUT_LINE('va a reemplazar '|| TO_CHAR(vMontoVencido,'999G999D99'));
        vTextoFinal := REPLACE(vTextoFinal, '&MontoVencido&', TO_CHAR(vMontoVencido,'999G999D99'));

        RETURN(vTextoFinal);    
    END;
    PROCEDURE REFRESCA_LISTAS IS    
    BEGIN
        FOR R_LIS IN C_LIS LOOP
        PROC_CC_LISTAS.vTextoQuery :=   'SELECT PER.*, HIS.* '||CHR(13)||
                                                             'FROM GD_GEN_PERSONAS PER, '||CHR(13)||
                                                             '          GD_GEN_HISTORIAS_PERSONA HIS'||CHR(13)||
                                                             'WHERE PER.PersonaID = HIS.PersonaID'||CHR(13);
            -- Recorrido de las variables para crear  lista de seleccion 
            IF R_LIS.DiasUltVisitaDesde IS NOT NULL THEN 
                PROC_CC_LISTAS.vTextoQuery := PROC_CC_LISTAS.vTextoQuery || ' AND  TRUNC(HIS.FecUltVisita) <= TRUNC(SYSDATE) -'|| R_LIS.DiasUltVisitaDesde||CHR(13);
            END IF;               
            --
            IF R_LIS.DiasUltVisitaHasta IS NOT NULL THEN 
                PROC_CC_LISTAS.vTextoQuery := PROC_CC_LISTAS.vTextoQuery || ' AND  TRUNC(HIS.FecUltVisita) >= TRUNC(SYSDATE) -'|| R_LIS.DiasUltVisitaHasta||CHR(13);
            END IF;               
            --
            IF R_LIS.DiasProxCitaDesde IS NOT NULL THEN 
                PROC_CC_LISTAS.vTextoQuery := PROC_CC_LISTAS.vTextoQuery || ' AND  TRUNC(HIS.FecProxCita) >= TRUNC(SYSDATE) +'|| R_LIS.DiasProxCitaDesde||CHR(13);
            END IF;               
            --
            IF R_LIS.DiasProxCitaHasta IS NOT NULL THEN 
                PROC_CC_LISTAS.vTextoQuery := PROC_CC_LISTAS.vTextoQuery || ' AND  TRUNC(HIS.FecProxCita) <= TRUNC(SYSDATE) +'|| R_LIS.DiasProxCitaHasta||CHR(13);
            END IF;               
             --
            IF R_LIS.CodServicio NOT IN (NULL,'%')  THEN 
                PROC_CC_LISTAS.vTextoQuery := PROC_CC_LISTAS.vTextoQuery || ' AND  HIS.CodServicio = '''||R_LIS.CodServicio||''''||CHR(13);
            END IF;               
            --
            IF R_LIS.CodSede NOT IN (NULL,'%') THEN 
                PROC_CC_LISTAS.vTextoQuery := PROC_CC_LISTAS.vTextoQuery || ' AND  HIS.CodSede = '''||R_LIS.CodSede||''''||CHR(13);
            END IF;               
            --
            IF R_LIS.EdadDesde IS NOT NULL THEN 
                PROC_CC_LISTAS.vTextoQuery := PROC_CC_LISTAS.vTextoQuery || ' AND  TRUNC(PER.FecNacimiento) <= SYSDATE - ('|| R_LIS.EdadDesde||' * 365)'||CHR(13);
            END IF;               
            --
            IF R_LIS.EdadHasta IS NOT NULL THEN 
                PROC_CC_LISTAS.vTextoQuery := PROC_CC_LISTAS.vTextoQuery || ' AND  TRUNC(PER.FecNacimiento) >= SYSDATE - ('|| R_LIS.EdadHasta||' * 365)'||CHR(13);
            END IF;               
            --
            IF R_LIS.Genero NOT IN (NULL,'%')THEN 
                PROC_CC_LISTAS.vTextoQuery := PROC_CC_LISTAS.vTextoQuery || ' AND  PER.Genero = '''||R_LIS.Genero||''''||CHR(13);
            END IF;               
            --
            IF R_LIS.CuotasVencDesde IS NOT NULL THEN 
                PROC_CC_LISTAS.vTextoQuery := PROC_CC_LISTAS.vTextoQuery || ' AND  PER.PersonaID IN ('||
                            'SELECT PersonaID'||CHR(13)||
                            'FROM GD_ADM_CUOTAS CUO'||CHR(13)||
                            'WHERE CUO.PersonaID = PER.PersonaID'||CHR(13)||
                            '    AND CodServicio '||CASE WHEN R_LIS.CodServicio IS NULL THEN 'IS NOT NULL' ELSE '= '''||R_LIS.CodServicio||'''' END||CHR(13)||
                            '    AND (StsCuota = ''VEN'''||CHR(13)||
                            '            OR (TRUNC(FecCuota) < TRUNC(SYSDATE)'||CHR(13)||
                            '                  AND StsCuota != ''PAG''))'||CHR(13)||
                            'GROUP BY PersonaID'||CHR(13)||
                            'HAVING COUNT(*) >= '||R_LIS.CuotasVencDesde||CHR(13)||
                            ')';
            END IF;                           
            --
            IF R_LIS.CuotasVencHasta IS NOT NULL THEN 
                PROC_CC_LISTAS.vTextoQuery := PROC_CC_LISTAS.vTextoQuery || ' AND  PER.PersonaID IN ('||
                            'SELECT PersonaID'||CHR(13)||
                            'FROM GD_ADM_CUOTAS CUO'||CHR(13)||
                            'WHERE CUO.PersonaID = PER.PersonaID'||CHR(13)||
                            '    AND CodServicio '||CASE WHEN R_LIS.CodServicio IS NULL THEN 'IS NOT NULL' ELSE '= '''||R_LIS.CodServicio||'''' END||CHR(13)||
                            '    AND (StsCuota = ''VEN'''||CHR(13)||
                            '            OR (TRUNC(FecCuota) < TRUNC(SYSDATE)'||CHR(13)||
                            '                  AND StsCuota != ''PAG''))'||CHR(13)||
                            'GROUP BY PersonaID'||CHR(13)||
                            'HAVING COUNT(*) <= '||R_LIS.CuotasVencHasta||CHR(13)||
                            ')';
            END IF;                           
            --
            DBMS_OUTPUT.PUT_LINE('GENERO EL QUERY '||PROC_CC_LISTAS.vTextoQuery);             
            IF R_LIS.TipoContacto = 'LLA' THEN -- Es llamada 
                DBMS_OUTPUT.PUT_LINE('VA A LLAMADAS');       
                GENERA_LLAMADAS(R_LIS);
            ELSE
                GENERA_TEXTO(R_LIS);
            END IF;
        END LOOP;                   
    END;
    --
    -- Recorre la lista dinamica generada por el procedimiento de REFRESCA_LISTAS y completa el proceso de generar las llamadas
    --           
    PROCEDURE GENERA_LLAMADAS (R_LIS C_LIS%ROWTYPE) IS
        CURSOR C_LLA IS
            SELECT 'X'
            FROM   GD_CC_LLAMADAS LLA,
                        GD_CC_DEF_LISTAS LST
            WHERE LLA.ListaID = R_LIS.ListaID -- De la misma Definicion de Lista
                AND  LST.LISTAID = LLA.ListaID 
                AND  R_DAT.PER_PERSONAID = LLA.PERSONAID
                AND  R_DAT.HIS_CODSERVICIO = LLA.CODSERVICIO 
                AND  (StsLlamada IN('INS','PEN','ASG') -- Llamada por realizarse 
                          OR 
                         (StsLlamada = 'CMP' -- Llamada completada 
                          AND (TRUNC(FecCompCliente) > TRUNC(SYSDATE) -- Con compromiso NO vencido 
                                 OR
                                 (TRUNC(LLA.FecRealLlamada) + LST.DIASREPETCONTACTO) > TRUNC(SYSDATE) -- Con Lapso no vencido 
                                 )
                          )       
                        );                   

    -- Objeto de Cursor dinamico 
    C_DAT           SYS_REFCURSOR;                 
    vLlamadaID    VARCHAR2(10);
    vDummy          VARCHAR2(1);
    BEGIN
        DBMS_OUTPUT.PUT_LINE('ENTRA EN LLAMADAS  CON TEXTO '||vTextoQuery);       
        OPEN C_DAT FOR PROC_CC_LISTAS.vTextoQuery;
        LOOP
            FETCH C_DAT INTO R_DAT;
            EXIT WHEN C_DAT%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('LEO UN REGISTRO ' ||R_DAT.PER_PersonaID);
            -- Verifica que este registro no esté ya pendiente de realizar
            OPEN C_LLA;
            FETCH C_LLA INTO vDummy;
            DBMS_OUTPUT.PUT_LINE('OBTUVO '||vDummy||' DEL CHEQUEO DE EXISTENTE');
            IF C_LLA%NOTFOUND THEN
                DBMS_OUTPUT.PUT_LINE('ENTRA A INSERTAR');
                -- Inserta la llamada para ser asignada a los operadores                
                vLlamadaID := DBMS_RANDOM.STRING('a',10);
                INSERT INTO GD_CC_LLAMADAS
                    (LLAMADAID, PersonaID, CodServicio, LISTAID, STSLLAMADA, SESIONLLAMADAIDASIG, FECREGLLAMADA,CODSEDE, CODESPECIALIDAD, CODESPECIALISTA)
                VALUES
                    (vLlamadaID, R_DAT.PER_PersonaID, R_DAT.HIS_CodServicio,R_LIS.ListaID, 'INS',NULL,SYSDATE, R_DAT.HIS_CODSEDE, R_DAT.HIS_CODESPECIALIDAD, R_DAT.HIS_CODESPECIALISTA );
            END IF;
            CLOSE C_LLA;                                    
        END LOOP;             
        CLOSE C_DAT;
    END;         
    --   
    PROCEDURE GENERA_TEXTO (R_LIS C_LIS%ROWTYPE) IS
    -- Objeto de Cursor dinamico 
    C_DAT           SYS_REFCURSOR;                 
    -- Cursor para conseguir si el texto ya está incluido en algun lote 
    CURSOR C_TXT IS
        SELECT 'X'
        FROM   GD_CC_LOTE_TEXTOS LOT,
                   GD_CC_TEXTO_LOTE TXT,
                    GD_CC_DEF_LISTAS LST
        WHERE TXT.ListaID = R_LIS.ListaID -- De la misma Definicion de Lista
            AND  LST.LISTAID = TXT.ListaID  
            AND TXT.LoteTextoID = LOT.LoteTextoID
            AND  (StsEnvioTexto IN('INS','PEN') -- Envío por realizarse 
                      OR 
                     (StsEnvioTexto = 'CMP' -- Envío completado
                      AND  (TRUNC(LOT.FecEnvio) + LST.DIASREPETCONTACTO > TRUNC(SYSDATE)) -- Con Lapso no vencido 
                     )
                    );                   

    vLoteTextoID    VARCHAR2(10);
    vDummy          VARCHAR2(1);
    vTexto             VARCHAR2(2000);
    vTextoFinal      VARCHAR2(2000);
    vNumTexto       NUMBER(5) := 0;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('ENTRA EN TEXTO');       
        OPEN C_DAT FOR PROC_CC_LISTAS.vTextoQuery;
        LOOP
            FETCH C_DAT INTO R_DAT;
            EXIT WHEN C_DAT%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('LEO UN REGISTRO ' ||R_DAT.PER_PersonaID);
            -- Verifica que este registro no esté ya pendiente de realizar
            OPEN C_TXT;
            FETCH C_TXT INTO vDummy;
            DBMS_OUTPUT.PUT_LINE('OBTUVO '||vDummy||' DEL CHEQUEO DE EXISTENTE');
            IF C_TXT%NOTFOUND THEN
                DBMS_OUTPUT.PUT_LINE('ENTRA A INSERTAR');
                -- Busca el Texto definido para enviar 
                BEGIN
                    SELECT Texto
                    INTO vTexto
                    FROM GD_CC_TEXTOS
                    WHERE TextoID = R_LIS.TextoID;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        vTexto := NULL;
                END;
                IF vLoteTextoID IS NULL THEN -- No se ha conseguido/generado un Lote                                             
                    --  Busca un Lote de textos pendiente de ser enviado 
                    BEGIN
                        SELECT LOT.LoteTextoID, MAX(TXT.NumTexto) 
                        INTO vLoteTextoID, vNumtexto
                        FROM GD_CC_LOTE_TEXTOS LOT,
                                  GD_CC_TEXTO_LOTE TXT
                        WHERE StsLoteTexto IN ('INS','PEN')
                            AND LOT.LoteTextoID = TXT.LoteTextoID
                        GROUP BY LOT.LoteTextoID;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN -- No existe nada pendiente y lo va a insertar
                            -- Genera un ID para el Lote de Texto 
                            vLoteTextoID := DBMS_RANDOM.STRING('a',10);
                            vNumtexto     := 0;
                            INSERT INTO GD_CC_LOTE_TEXTOS
                               (LOTETEXTOID, FECLOTETEXTO, STSLOTETEXTO, FECENVIO, STSENVIO)
                            VALUES
                               (vLoteTextoID, SYSDATE, 'INS',NULL,'PEN');                                   
                    END;
                END IF;                
                -- Lo pasa por la sustitucion de Variables
                vTextoFinal := EXPANDE_TEXTO(R_LIS, R_DAT,vTexto);
                vNumTexto := vNumTexto + 1;    
                INSERT INTO GD_CC_TEXTO_LOTE
                    (LOTETEXTOID, NUMTEXTO, LISTAID, TEXTO, PERSONAID, CODSERVICIO, STSENVIOTEXTO )
                VALUES
                    (vLoteTextoID, vNumTexto, R_LIS.ListaID ,vTextoFinal, R_DAT.PER_PersonaID, R_DAT.HIS_CodServicio,'INS' );
            END IF;
            CLOSE C_TXT;                                    
        END LOOP;            
        CLOSE C_DAT;
        IF R_LIS.TipoContacto = 'SMS' THEN
            NULL;
        ELSIF R_LIS.TipoContacto = 'MAI' THEN
            NULL;
        END IF;            
    END;            
    
    --
    PROCEDURE DISTRIBUYE_LLAMADAS IS
    -- Cursor con las llamadas pendientes
    CURSOR C_LLA IS
        SELECT LLA.*, DEF.CategoriaLlamada
        FROM GD_CC_LLAMADAS LLA,
                 GD_CC_DEF_LISTAS DEF
        WHERE StsLlamada IN('INS','PEN','ASG') -- Pendiente por realizarse
            AND DEF.LISTAID = LLA.LISTAID 
        ORDER  BY FecRegLlamada;
    -- Cursor con los operadores activos en la sesion
    CURSOR C_OPE IS
        SELECT OPS.LoginUsuario
        FROM GD_CC_OPERADORES_SESION OPS,
                  GD_CC_SESIONES_LLAMADAS SES
        WHERE SES.StsSesion = 'ACT'
            AND OPS.SESIONLLAMADAID = SES.SESIONLLAMADAID
            AND OPS.STSOPERADORSESION = 'ACT';      
    -- Cursor de los Categorias de un Operador 
    CURSOR C_CATOPER (pLoginUsuario VARCHAR2) IS
        SELECT ESPOP.CategoriaLlamada 
        FROM  GD_CC_ESPEC_OPER ESPOP
        WHERE ESPOP.LoginUsuario = pLoginUsuario
        ORDER BY ESPOP.Prioridad DESC;         
    --
    -- Definición de matriz para guardar a cada operador activo y la cantidad de llamadas asignadas
    --
    TYPE vOperadores IS RECORD
        (Operador VARCHAR2(16),
         Cantidad   NUMBER(5) := 0
        );                   
    TYPE vTablaOperadores IS TABLE OF vOperadores INDEX BY PLS_INTEGER;    
    vMatrizOperadores       vTablaOperadores; 
    --
    -- Definicion de matriz con las Categorias de cada operador
    --
    TYPE vCategorias IS RECORD
        (Operador VARCHAR2(16),
         Categoria VARCHAR2(3)
        );                   
    TYPE vTablaCategorias IS TABLE OF vCategorias INDEX BY BINARY_INTEGER;    
    vMatrizCategorias       vTablaCategorias; 
    --
    -- Definicion de matriz con las Llamadas
    --
    TYPE vLlamadas IS RECORD
        (LlamadaiD VARCHAR2(16),
         Operador   VARCHAR2(16) := 0
        );                   
    TYPE vTablaLlamadas IS TABLE OF vLlamadas INDEX BY PLS_INTEGER;    
    vMatrizLlamadas       vTablaLlamadas; 
    --
    vCantLlamadas       NUMBER(5) := 0;
    vCantoperadores    NUMBER(5) := 0;
    vCantPorOper         NUMBER(5) := 0;
    vLoginUsuario         GD_GEN_USUARIOS.LOGINUSUARIO%TYPE;
    vContOper              NUMBER(3) := 0;
    vContCat                NUMBER(3) := 0;
    vContLla                 NUMBER(5) := 0;
    --
    vCat                        BOOLEAN;
    vOper                      BOOLEAN;
    I                              NUMBER(10) := 0;
    BEGIN
        -- Carga la matriz de Operadores activos
        vContOper := 0;
        FOR R_OPE IN C_OPE LOOP
            vContOper := vContOper + 1;
            vMatrizOperadores(vContOper).Operador := R_OPE.LoginUsuario;
            vMatrizOperadores(vContOper).Cantidad  := 0;
            DBMS_OUTPUT.PUT_LINE('GUARDO OPE: '||R_OPE.LoginUsuario);
            -- Carga la matriz de Categorias de los Operadores activos
            vContCat := 0;
            FOR R_CATOPER IN C_CATOPER (R_OPE.LoginUsuario) LOOP
                vContCat := vContCat + 1;
                vMatrizCategorias(vContCat).Operador := R_OPE.LoginUsuario;
                vMatrizCategorias(vContCat).Categoria  := R_CATOPER.CategoriaLlamada;
                DBMS_OUTPUT.PUT_LINE('GUARDO CATOPER: '||R_OPE.LoginUsuario||' DE CATEGORIA '||R_CATOPER.CategoriaLlamada);
            END LOOP;
            -- En el caso que el Operador NO tenga categorias 
            IF vContCat = 0 THEN
                vContCat := 1;
                vMatrizCategorias(vContCat).Operador :=  R_OPE.LoginUsuario;
                vMatrizCategorias(vContCat).Categoria  := 'X';
            END IF;                
        END LOOP;                     
        -- Carga la matriz de llamadas
        vContLla := 0;
        FOR R_LLA IN C_LLA LOOP
            vContLla := vContLla + 1;
            vMatrizLlamadas(vContLla).LlamadaID := R_LLA.LlamadaID;
            DBMS_OUTPUT.PUT_LINE('GUARDO LLA: '||R_LLA.LlamadaID);
        END LOOP;
       
        --
        IF NVL(vContOper,0) > 0 THEN  
            vCantPorOper := TRUNC(vContLla / vContOper) + 1;
            DBMS_OUTPUT.PUT_LINE(' EL TOPE DE LLAMADAS POR OPERADOR SERA DE  '||vCantPorOper);
            --
            FOR R_LLA IN C_LLA LOOP
                -- Coloca los controles
                vCat   := FALSE;
                vOper := FALSE;
                -- Recorre la matriz de categorias buscando un Operador que la atienda 
                DBMS_OUTPUT.PUT_LINE('Busca asignar la llamada '||R_LLA.LlamadaID||'   DE CATEGORIA '||R_LLA.CategoriaLlamada);
                --
                FOR I IN  vMatrizCategorias.FIRST..vMatrizCategorias.LAST LOOP
                    IF vMatrizCategorias(I).Categoria = R_LLA.CategoriaLlamada THEN -- Consigue un operador con esa categoria
                        DBMS_OUTPUT.PUT_LINE('Consiguio a un operador de esa categoria '|| vMatrizCategorias(I).Operador);
                        vCat := TRUE;
                        -- Busva al operador en la matriz 
                        FOR J IN vMatrizOperadores.FIRST .. vMatrizOperadores.LAST LOOP
                            IF vMatrizOperadores(J).Operador =  vMatrizCategorias(I).Operador THEN -- Consiguio el elemento
                                DBMS_OUTPUT.PUT_LINE('Consigue al operador en la matriz  con  '|| vMatrizOperadores(J).Cantidad||' de llamadas');
                                vOper := FALSE;
                                IF vMatrizOperadores(J).Cantidad <  vCantPorOper THEN --  No se le ha asignado el Maximo
                                    vMatrizOperadores(J).Cantidad :=  vMatrizOperadores(J).Cantidad + 1;
                                    vOper := TRUE;
                                    -- Busca la llamada en la matriz para asignarla 
                                    FOR K IN vMatrizLlamadas.FIRST .. vMatrizLlamadas.LAST LOOP 
                                        IF vMatrizLlamadas(K).LlamadaID = R_LLA.LlamadaID THEN -- Consiguio el elemento
                                            -- Le pone el Operador a la llamada 
                                            DBMS_OUTPUT.PUT_LINE('Le pone el Operador   '|| vMatrizOperadores(J).Operador||' a la llamada '||vMatrizLlamadas(K).LlamadaID);
                                             vMatrizLlamadas(K).Operador := vMatrizOperadores(J).Operador;
                                        END IF;
                                    END LOOP;
                                END IF;
                            END IF;                                                            
                        END LOOP;
                    END IF;
                END LOOP;
                IF NOT vCat OR NOT vOper THEN -- No consigio ningun operador que atienda esa categoria y/o que tenga disponibilidad 
                    DBMS_OUTPUT.PUT_LINE('No consigio ningun operador que atienda esa categoria y/o que tenga disponibilidad ');
                    -- Busca el primer operador sin Carga completa 
                    FOR J IN vMatrizOperadores.FIRST .. vMatrizOperadores.LAST LOOP 
                        IF vMatrizOperadores(J).Cantidad <  vCantPorOper THEN --  No se le ha asignado el Maximo
                            DBMS_OUTPUT.PUT_LINE('Consigue a este Operador '||vMatrizOperadores(J).Operador||' con disponibilidad');
                            vMatrizOperadores(J).Cantidad :=  vMatrizOperadores(J).Cantidad + 1;
                            -- Busca la llamada en la matriz para asignarla 
                            FOR K IN vMatrizLlamadas.FIRST .. vMatrizLlamadas.LAST LOOP 
                                IF vMatrizLlamadas(K).LlamadaID = R_LLA.LlamadaID THEN -- Consiguio el elemento
                                    DBMS_OUTPUT.PUT_LINE('Consigue la llamada '|| vMatrizLlamadas(K).LlamadaID); 
                                    -- Le pone el Operador a la llamada 
                                     vMatrizLlamadas(K).Operador := vMatrizOperadores(J).Operador;
                                END IF;
                            END LOOP;
                            EXIT;
                        END IF;
                    END LOOP;
                END IF;                                                                          
            END LOOP;
        END IF;            
        -- 
        IF vContLla > 0 THEN
            -- Va a registrar las asignaciones en la Tabla de llamadas
            FOR K IN vMatrizLlamadas.FIRST .. vMatrizLlamadas.LAST LOOP
                UPDATE GD_CC_LLAMADAS 
                SET  StsLlamada        = 'ASG',
                        OperadorIDReal  =  vMatrizLlamadas(K).Operador,
                        LoginUsuario       = vMatrizLlamadas(K).Operador
                WHERE LlamadaID = vMatrizLlamadas(K).LlamadaID;                    
            END LOOP;
        END IF;            
        --
    END;

END PROC_CC_LISTAS;
