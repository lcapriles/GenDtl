--------------------------------------------------------
--  DDL for Package Body PROC_CC_AGENDAS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "GDCNO"."PROC_CC_AGENDAS" AS

  --Procedimiento para crear/borrar citas
  ----Si la cita no existe, la crea...
  ----Si la cita existe, la borra... Saca una copia por si el operador quiere moverla...
  --
  PROCEDURE AGENDAR_CITA (pCITA_ID GD_CC_CITAS.CITAID%TYPE,
                          pCITA_CODSEDE GD_CC_CITAS.CODSEDE%TYPE,
                          pCITA_CODSERVICIO GD_CC_CITAS.CODSERVICIO%TYPE,
                          pCITA_CODESPECIALIDAD GD_CC_CITAS.CODESPECIALIDAD%TYPE,
                          pCITA_CODESPECIALISTA GD_CC_CITAS.CODESPECIALISTA%TYPE,
                          pCITA_PERSONAID GD_CC_CITAS.PERSONAID%TYPE,
                          pCITA_HORAINICIO VARCHAR2,
                          pCITA_DURACION GD_CC_CITAS.DURACION%TYPE,
                          pCITA_NUMCITA GD_CC_CITAS.NUMCITA%TYPE
                          ) AS
                                             
    vCitaID    VARCHAR2(10);
    vTipoCalendario VARCHAR2(2);
    vFlaf VARCHAR2(1);
    
    vNumHistoria VARCHAR2(20); 
    
      BEGIN     

        if pCITA_id = 'N' then
                  
          select NUMHISTORIA into vNumHistoria
          from GD_GEN_PERSONAS
          where PERSONAID = pCITA_PERSONAID
          and ROWNUM = 1;          
        
          vCitaID := DBMS_RANDOM.STRING('a',10);
          insert into GD_CC_CITAS (CITAID,CODSEDE,CODSERVICIO,CODESPECIALIDAD,CODESPECIALISTA,PERSONAID,NUMPRESUPUESTO,HORAINICIO,DURACION,NUMCITA) 
          values (vcitaid,pCITA_CODSEDE,pCITA_CODSERVICIO,pCITA_CODESPECIALIDAD,pCITA_CODESPECIALISTA,pCITA_PERSONAID,'0',
                  to_date(pCITA_HORAINICIO,'DD/MM/YY HH24:MI:SS'),to_number(pCITA_DURACION),pCITA_NUMCITA);
          
          update GD_CC_CITAS_DISPONIBILIDAD 
          set CITASRESERVADO = CITASRESERVADO + 1
          where trunc(DISPONIBILIDADFECHA) = trunc(to_date(pCITA_HORAINICIO,'DD/MM/YY HH24:MI:SS')) 
          and CODSEDE = pCITA_CODSEDE and CODSERVICIO = pCITA_CODSERVICIO;
          
          --Queremos contar una cita más de ortodoncia.. para la vista mensual...
          select TIPOCALENDARIO into vTipoCalendario
          from GD_GEN_SERVICIOS_CLINICOS
          where CODSERVICIO = pCITA_CODSERVICIO;
          if vTipoCalendario = 'OR' --Cita de ortodoncia... 
          or vTipoCalendario = 'OD' then --Se incluye odontología 07/05/15!!!...
            update GD_CC_CITAS_CONTADOR 
            set CONTADOR = CONTADOR + 1
            where HORAINICIO = to_date(pCITA_HORAINICIO,'DD/MM/YY HH24:MI:SS')
            --Necesitamos actualizar todos los contadores de la cita, no solo el de la fecha exacta...
            --where HORAINICIO in (select HORAINICIO from GD_CC_CITAS_MOV where NUMCITA = pCITA_NUMCITA)
            and CODSEDE = pCITA_CODSEDE
            and CODSERVICIO = pCITA_CODSERVICIO
            and CODESPECIALISTA = pCITA_CODESPECIALISTA;
            if SQL%ROWCOUNT = 0 then --Si no existe, lo creamos!!!
              vCitaID := DBMS_RANDOM.STRING('a',10);
              insert into GD_CC_CITAS_CONTADOR (CODSEDE,CODSERVICIO,HORAINICIO,CONTADOR,CODESPECIALISTA) 
              values (pCITA_CODSEDE,pCITA_CODSERVICIO,to_date(pCITA_HORAINICIO,'DD/MM/YY HH24:MI:SS'),1,pCITA_CODESPECIALISTA);          
            end if;
          end if;
         
         begin
            PROC_GEN_GENERAL.ACTUALIZA_HISTORIA(pCITA_PERSONAID , pCITA_CODSEDE, pCITA_CODSERVICIO,
                    pCITA_CODESPECIALIDAD, pCITA_CODESPECIALISTA, NULL, vNumHistoria);
            
            PROC_GEN_GENERAL.ACTUALIZA_FECHAS_VISITA(pCITA_PERSONAID, pCITA_CODSEDE, pCITA_CODSERVICIO,
                    pCITA_CODESPECIALIDAD, pCITA_CODESPECIALISTA, vNumHistoria, NULL, pCITA_HORAINICIO);
          exception
          when OTHERS then
            NULL;
          end;
            
        else 
          -- Solo podemos actualizar si la cita es del paciente...
          -- Sacamos una copia por si queremos pegar mas tarde...
          insert  into GD_CC_CITAS_MOV (CITAID,CODSEDE,CODSERVICIO,CODESPECIALIDAD,CODESPECIALISTA,PERSONAID,NUMPRESUPUESTO,HORAINICIO,DURACION,NUMCITA,STSCITA,FECHAMOV)
          select CITAID,CODSEDE,CODSERVICIO,CODESPECIALIDAD,CODESPECIALISTA,PERSONAID,NUMPRESUPUESTO,HORAINICIO,DURACION,NUMCITA,STSCITA,to_char(SYSDATE,'DD/MM/YYYY')  
          from GD_CC_CITAS
          where NUMCITA = pCITA_NUMCITA
          and PERSONAID = pCITA_PERSONAID;
          
          delete GD_CC_CITAS
          where NUMCITA = pCITA_NUMCITA
          and PERSONAID = pCITA_PERSONAID;

          if SQL%ROWCOUNT <> 0 then
            --Efectivamente borramos la cita del paciente, entonces actualizamos los contadores...
            update GD_CC_CITAS_DISPONIBILIDAD 
            set CITASRESERVADO = CITASRESERVADO - 1
            where trunc(DISPONIBILIDADFECHA) = trunc(to_date(pCITA_HORAINICIO,'DD/MM/YY HH24:MI:SS'))
            and CODSEDE = pCITA_CODSEDE and CODSERVICIO = pCITA_CODSERVICIO;    
         
            --Queremos contar una cita menos de ortodoncia.. para la vista mensual...
            select TIPOCALENDARIO into vTipoCalendario
            from GD_GEN_SERVICIOS_CLINICOS
            where CODSERVICIO = pCITA_CODSERVICIO;
            if vTipoCalendario = 'OR' --Cita de ortodoncia... 
            or vTipoCalendario = 'OD' then --Se incluye odontología 07/05/15!!!...
              update GD_CC_CITAS_CONTADOR 
              set CONTADOR = CONTADOR - 1
              --where HORAINICIO = to_date(pCITA_HORAINICIO,'DD/MM/YY HH24:MI:SS')
              --Necesitamos actualizar todos los contadores de la cita, no solo el de la fecha exacta...
              where HORAINICIO in (select HORAINICIO from GD_CC_CITAS_MOV where NUMCITA = pCITA_NUMCITA)
              and CODSEDE = pCITA_CODSEDE
              and CODSERVICIO = pCITA_CODSERVICIO
              and CODESPECIALISTA = pCITA_CODESPECIALISTA;
              if SQL%ROWCOUNT = 0 then --Si no existe, lo creamos!!!
                vCitaID := DBMS_RANDOM.STRING('a',10);
                insert into GD_CC_CITAS_CONTADOR (CODSEDE,CODSERVICIO,HORAINICIO,CONTADOR,CODESPECIALISTA) 
                values (pCITA_CODSEDE,pCITA_CODSERVICIO,to_date(pCITA_HORAINICIO,'DD/MM/YY HH24:MI:SS'),0,pCITA_CODESPECIALISTA);          
              end if;
            end if;
          end if;
        end if;       
      commit;
    END AGENDAR_CITA;  

  --
  --Procedimeto para mover citas...
  ----Inserta citas previamente borradas...
  --
  PROCEDURE AGENDAR_CITA_MOV (pCITA_NUMCITA GD_CC_CITAS_MOV.NUMCITA%TYPE, 
                              pCITA_NUEVAHI VARCHAR2,
                              pCITA_PERSONAID GD_CC_CITAS_MOV.PERSONAID%TYPE,
                              pCITA_CODSEDE GD_CC_CITAS_MOV.CODSEDE%TYPE,
                              pCITA_CODSERVICIO GD_CC_CITAS_MOV.CODSERVICIO%TYPE,
                              pCITA_CODESPECIALIDAD GD_CC_CITAS_MOV.CODESPECIALIDAD%TYPE,
                              pCITA_CODESPECIALISTA GD_CC_CITAS_MOV.CODESPECIALISTA%TYPE) AS
                                   
  CURSOR C_CITAS_HORARIO_ESPEC IS --Conseguimos las horas del día citado a partir de las hora citada...
    select to_char(HORADIA,'HH24:MI:SS')
    from GD_CC_CITAS_HORARIO_ESPEC
    where DIASEMANA  = to_char(to_date(pCITA_NUEVAHI,'DD/MM/YY HH24:MI:SS'),'D')
    and to_char(HORADIA,'HH24:MI:SS') >= substr(pCITA_NUEVAHI,10,8)
    order by HORADIA;
        
  vHORADIA VARCHAR2(16);
  vCITA_HORAINICIO VARCHAR2(32);
  vNumHistoria VARCHAR2(20);
  
  i NUMBER;
  
  BEGIN
    select NUMHISTORIA into vNumHistoria
    from (
      select NUMHISTORIA
      from GD_GEN_HISTORIAS_PERSONA
      where PERSONAID = pCITA_PERSONAID
      and CODSEDE =  pCITA_CODSEDE
      and CODSERVICIO = pCITA_CODSERVICIO
      order by FECULTVISITA NULLS LAST)
    where ROWNUM = 1;
    
    i := 0;
  
    open C_CITAS_HORARIO_ESPEC;
  
    for x in (
      select CITAID,CODSEDE,CODSERVICIO,CODESPECIALIDAD,CODESPECIALISTA,PERSONAID,NUMPRESUPUESTO,HORAINICIO,DURACION,NUMCITA,STSCITA  
      from GD_CC_CITAS_MOV
      where NUMCITA = pCITA_NUMCITA 
      and FECHAMOV = to_char(SYSDATE,'DD/MM/YYYY')
      and CODSEDE = pCITA_CODSEDE
      and CODSERVICIO = pCITA_CODSERVICIO
      and CODESPECIALIDAD = pCITA_CODESPECIALIDAD
      and CODESPECIALISTA = pCITA_CODESPECIALISTA
      order by HORAINICIO) --Como seguridad, solo consideramos lo del día de hoy...
    loop
      fetch C_CITAS_HORARIO_ESPEC into vHORADIA;
      
      insert  into GD_CC_CITAS (CITAID,CODSEDE,CODSERVICIO,CODESPECIALIDAD,CODESPECIALISTA,PERSONAID,NUMPRESUPUESTO,HORAINICIO,DURACION,NUMCITA,STSCITA)
      values (x.CITAID,x.CODSEDE,x.CODSERVICIO,x.CODESPECIALIDAD,x.CODESPECIALISTA,x.PERSONAID,x.NUMPRESUPUESTO,
              to_DATE(substr(pCITA_NUEVAHI,1,8) ||' '|| vHORADIA,'DD/MM/YY HH24:MI:SS'),x.DURACION,x.NUMCITA,x.STSCITA);
              
      if i = 0 then --La primera hora será la Próxima Visita...
        vCITA_HORAINICIO := substr(pCITA_NUEVAHI,1,8) ||' '|| vHORADIA;
        i := i + 1;
      end if;
    end loop;
    
    delete GD_CC_CITAS_MOV --Borramos del temporal...
    where NUMCITA = pCITA_NUMCITA;
    
    close C_CITAS_HORARIO_ESPEC;
    
     begin      
        PROC_GEN_GENERAL.ACTUALIZA_FECHAS_VISITA(pCITA_PERSONAID, pCITA_CODSEDE, pCITA_CODSERVICIO,
                pCITA_CODESPECIALIDAD, pCITA_CODESPECIALISTA, vNumHistoria, NULL, vCITA_HORAINICIO);
      exception
      when OTHERS then
        NULL;
      end;    
  
  END AGENDAR_CITA_MOV;
  

  --Procedimeto actualizar status citas...
  --
  PROCEDURE AGENDAR_CITA_STS (pCITA_NUMCITA GD_CC_CITAS_MOV.NUMCITA%TYPE, 
                              pCITA_NUEVAHI VARCHAR2) AS  

  BEGIN
  
    for x in (
      select STSCITA 
      from GD_CC_CITAS
      where NUMCITA = pCITA_NUMCITA )
      loop
        if x.STSCITA = 'T' then
          update GD_CC_CITAS
          set STSCITA = 'C'
          where NUMCITA = pCITA_NUMCITA;
        end if;
        if x.STSCITA = 'C' then
          update GD_CC_CITAS
          set STSCITA = 'T'
          where NUMCITA = pCITA_NUMCITA;
        end if;
      end loop;
  
  END AGENDAR_CITA_STS;

  PROCEDURE AGENDAR_PRUEBA(P1 varchar2, P2 date) AS
  
  BEGIN
    htp.prn('AGENDAR_PRUEBA!!! P1= '||P1||' P2= '||P2);
  END AGENDAR_PRUEBA ;

  PROCEDURE AGENDAR_PRUEBA(P1 varchar2, P2 varchar2) AS
  
  BEGIN
    htp.prn('AGENDAR_PRUEBA!!! P1= '||P1||' P2 TEXTO= '||P2|| '  P2 FECHA= '||TO_DATE(P2,'DD/MM/RRRR  HH:MI:SS'));
  END AGENDAR_PRUEBA ;

--
--  Procedimiento que Genera los datos de dias Hábiles laborables generales 
--
    PROCEDURE GENERAR_CALENDARIO_GLOBAL IS
    --
    -- CURSOR DE LAS SEDES 
    CURSOR C_SED IS
        SELECT *
        FROM GD_GEN_SEDES
        ORDER BY CodSede;
    --
    -- CURSOR DE LOS SERVICIOS DE UNA SEDE  
    CURSOR C_SERV (pCodSede VARCHAR2) IS
        SELECT *
        FROM GD_GEN_SERV_SEDES 
        WHERE CodSede = pCodSede
        ORDER BY CodServicio;
        
    -- CURSOR DE LOS ESPECIALISTAS DE UNA ESPECIALIDAD EN LA SEDE 
    CURSOR C_ESPTA (pCodSede VARCHAR2, pCodServicio VARCHAR2) IS
        SELECT *
        FROM GD_GEN_ESPECIALISTAS
        WHERE CodSede = pCodSede
            AND CodServicio = pCodServicio
        ORDER BY CodEspecialista;
    --
    --  CURSOR CON LOS DIAS FERIADOS ESPECIFICOS  
    CURSOR C_DFE IS
        SELECT *
        FROM GD_GEN_DIAS_FERIADOS
        WHERE IndFeriadoFijo = 'N';
               
    BEGIN
        -- Elimina todas las fechas DISPONIBLES desde este momento en adelante. Lo que exista
        DELETE GD_CC_CITAS_DISPONIBILIDAD
        WHERE DisponibilidadFecha >= TRUNC(SYSDATE);
        --
        -- Recorre las sedes 
        FOR R_SED IN C_SED LOOP
            -- Recorre los SERVICIOS de esa sede
            FOR R_SERV IN C_SERV(R_SED.CodSede) LOOP
                 -- Y ahora todas los dias de los proximos 5 años
                FOR I IN 1..365*5 LOOP
                    INSERT INTO GD_CC_CITAS_DISPONIBILIDAD
                       (DISPONIBILIDADFECHA, CODSEDE, CODSERVICIO, CITASRESERVADO, CITASDISPONIBLE)
                    VALUES
                        (TRUNC(SYSDATE)+I, R_SERV.CodSede, R_SERV.CodServicio, 0, 0);
                END LOOP;                                                       
            END LOOP;
        END LOOP;                             
        -- Ahora recorre los dias feriados y elimina estos de la tabla de Disponibilidad
        FOR R_DFE IN C_DFE LOOP
            IF R_DFE.IndFeriadoFijo = 'S' THEN -- Es dia feriado fijo todos los años pe. 31/12 
                DELETE GD_CC_CITAS_DISPONIBILIDAD
                WHERE TO_CHAR(DisponibilidadFecha,'DDMM') = TO_CHAR(R_DFE.FecFeriado,'DDMM')
                    AND (CodSede = R_DFE.CodSede OR NVL(R_DFE.CodSede,'*') = '*'); 
            ELSE -- Es una fecha especifica 
                DELETE GD_CC_CITAS_DISPONIBILIDAD
                WHERE TRUNC(DisponibilidadFecha) = TRUNC(R_DFE.FecFeriado)
                     AND (CodSede = R_DFE.CodSede OR NVL(R_DFE.CodSede,'*') = '*');
            END IF;                
        END LOOP;            
    END;

END PROC_CC_AGENDAS;
