--------------------------------------------------------
--  DDL for Package Body PROC_CAJAS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "GDCNO"."PROC_CAJAS" AS

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
                     RETURN NUMBER AS
  BEGIN
    declare
      l_factura_id number;
      factura_cia varchar2(20);
      factura_serie varchar2(20);
      
      cuota number := 0;
      monto_neto number := 1;
      monto_neto1 number := 0;
      monto_baremo number(10,2);
      cedula varchar2(20) := 0;
      historia varchar2(20) := '0';
      numero_control varchar2(20) := '0';
      cant_items number := 0;
      flagVisita number := 0;
      fechaFactura DATE;
      especialidad_temp varchar2(10);
    
      dummy varchar2(60);
      
      c1 number := 0;
      c2 number := 0;
    
      n_caja varchar2(10);
      t_fac_i varchar2(20);
      d_fac_i date; 
      t_fac_f varchar2(20);
      d_fac_f date; 
      
      vPersonaID NUMBER;
      vCodEspecialidad VARCHAR2(6);
      
      errores NUMBER;
    
      No_Facturable exception;
      Contador_Invalido exception;
        
    begin
    --Validaciones
      errores := 0;
      
--    select c001, c002, c003, c004 into monto_neto, cedula, historia, numero_control 
--    from apex_collections where collection_name = 'BUFFER';
      select c001, c002, c003, c004 into monto_neto, cedula, historia, numero_control
      from APEX_040200.COLECCION_APEX
      where SESSION_ID = pSESSION_ID
      and COLLECTION_NAME = 'BUFFER';
      --
--    if apex_collection.collection_exists(p_collection_name => 'FACTURA') then
--      cant_items := apex_collection.collection_member_count(p_collection_name => 'FACTURA');
--    end if;
      select count(*), nvl(sum(c003),1) into cant_items, monto_neto1
      from APEX_040200.COLECCION_APEX
      where SESSION_ID = pSESSION_ID
      and COLLECTION_NAME = 'FACTURA';
      --
      if monto_neto <> 0 or monto_neto1 <> 0 or cedula = 0 or cant_items = 0 or numero_control = '0' 
      or pP7030_ERRORES_CARRITO <> '0' then
--        apex_error.add_error (
--          p_message          => '***ERROR: Revise los montos y campos relacionados!',
--          p_display_location => apex_error.c_inline_in_notification );
--        raise No_Facturable;
        errores := errores + 1;
      end if;        
       /*
      01	Ortodoncia requiere HISTORIA y PRESUPUESTO...
      02	Odontología requiete HISTORIA, pero no PRESUPUESTO...
      03	Radiología NO requiere HISTORIA NI PRESUPUESTO...
      05	Cirugía requiere HISTORIA Y PRESUPUESTO... 
      */
      if pP7030_ESPECIALIDAD = '01' and (historia IS NULL or historia = '0') and (pP7030_PRESUPUESTO IS NULL or pP7030_PRESUPUESTO = '0')
      or pP7030_ESPECIALIDAD = '02' and (historia IS NULL or historia = '0') 
      or pP7030_ESPECIALIDAD = '05' and (historia IS NULL or historia = '0') and (pP7030_PRESUPUESTO IS NULL or pP7030_PRESUPUESTO = '0')
      then --Servicios 03 y 04 siempre pasan esta validación...
--      apex_error.add_error (
--          p_message          => '***ERROR: Revise Historia y Presupuesto requeridos!',
--          p_display_location => apex_error.c_inline_in_notification );
--        raise No_Facturable;
        errores := errores + 2;
      end if;
      if pP7030_ESPECIALIDAD = '99' or (pP7030_ESPECIALIDAD <> '01' and pP7030_ESPECIALISTA = '99') then
  --      apex_error.add_error (
  --        p_message          => '***ERROR: Revise Especialidad y Especialista!',
  --        p_display_location => apex_error.c_inline_in_notification );
  --      raise No_Facturable;
        errores := errores + 4;
      end if;
      begin
        select CODESPECIALISTA  into dummy 
        from GD_GEN_ESPECIALISTAS
        where CODSEDE = pGLOBALsede and CODSERVICIO = pP7030_ESPECIALIDAD 
        and CODESPECIALIDAD = pP7030_ESPECIALIDADII and CODESPECIALISTA = pP7030_ESPECIALISTA;
      exception
        when NO_DATA_FOUND  then
  --        apex_error.add_error (
  --          p_message          => '***ERROR: Revise Especialidad y Especialista!',
  --          p_display_location => apex_error.c_inline_in_notification );
  --        raise No_Facturable;
          errores := errores + 8;
      end;
      
      for y in (
--      select c001, c002, c003, c004, c005, c006, c007, c008, c009 
--      from apex_collections 
--      where collection_name = 'FACTURA')
        select c001, c002, c003, c004, c005, c006, c007, c008, c009
        from APEX_040200.COLECCION_APEX
        where SESSION_ID = pSESSION_ID
        and COLLECTION_NAME = 'FACTURA'
      )
      loop
        especialidad_temp := PROC_GEN_GENERAL.SUB_CODIGO(y.c001, '-', 2);

        if especialidad_temp != pP7030_ESPECIALIDAD and especialidad_temp != 'ZZ' and especialidad_temp != '0' then
--          apex_error.add_error (
--            p_message          => '***ERROR: Items a facturar no pertenecen a la Especialidad...',
--            p_display_location => apex_error.c_inline_in_notification );
--          raise No_Facturable;
          errores := errores + 16;
        end if;
      end loop;    
      --Calcula Nro. Factura
      begin
        --l_factura_id := CONTADOR_EMPRESA(:GLOBALEMPRESA,'FACTURA');
        factura_cia := pGLOBALcompania;
        factura_serie := PROC_GEN_GENERAL.SUB_CODIGO(pP7030_FACTURA1, '-', 2);
        select CONTADOR into l_factura_id 
        from GD_GEN_CONTADORES_DOCUMENTOS 
        where CODCOMPANIA = factura_cia and ANO = 0 and TIPO_DOCUMENTO = 'FACTURA' and SUB_TIPO_DOCUMENTO = factura_serie;
      exception
        when NO_DATA_FOUND  then
--          apex_error.add_error (
--            p_message          => '***ERROR: Datos de Nro.Factura invalidos o no configurados...',
--            p_display_location => apex_error.c_inline_in_notification );
--          raise Contador_Invalido;
          errores := errores + 32;
      end; 
      
      if errores > 0 then
        return errores;
      end if;

      fechaFactura := SYSDATE;
      
      -- Insert a row into the FACTURAS Header table 
      begin
        insert into GD_ADM_FACTURAS 
        values(pGLOBALsede, pGLOBALcompania, pP7030_FACTURA1||'-'||to_char(l_factura_id, 'FM000009'), fechaFactura, historia, numero_control,
               pP7030_CAJA_NUMERO, pP7030_ESPECIALIDAD, pP7030_ESPECIALISTA, 
               pP7030_RESPONSABLE_PAGO_NOMBRE, pP7030_NAC_RPAGO, pP7030_RESPONSABLE_PAGO_CI, pP7030_ESPECIALIDADII);
  
        -- Loop through the FACTURA collection and insert rows into the RENGLONES_FACTURAS table
        for x in (
  --      select c001, c002, sum(c003) c003, sum(c004) c004, c005, c006, c007, c008, c009 
  --      from apex_collections 
  --      where collection_name = 'FACTURA' 
  --      group by c005, c001, c002, c003, c004, c006, c007, c008, c009
  --      order by c005, c001, c002
          select c001, c002, sum(c003) c003, sum(c004) c004, c005, c006, c007, c008, c009
          from APEX_040200.COLECCION_APEX
          where SESSION_ID = pSESSION_ID
          and COLLECTION_NAME = 'FACTURA'
          group by c005, c001, c002, c003, c004, c006, c007, c008, c009
          order by c005, c001, c002
        )
        loop
          if x.c005 = '2items' or x.c005 = '2itemsP' or x.c005 = '3cobros' then cuota := 0; end if;
          if x.c005 = '1cuotas' then cuota := x.c009; end if;
          if x.c005 = '1cuotas' or x.c005 = '2items' or x.c005 = '2itemsP' then 
            c1 := c1 + 1;     
            if x.c001 is not NULL and x.c001 <> '0' and x.c005 <> '1cuotas' and x.c005 <> '2itemsP' then
            --El baremo sale de ITEMS si no es cuota/presupuesto!!...
              monto_baremo := 0;
              select 
              case 
              when pP7030_TABULADOR = '1' or pP7030_TABULADOR = '01' then
                nvl(HONORARIOS_01_1/nvl(NUMERO_CUOTAS,1),0)
              when pP7030_TABULADOR = '2' or pP7030_TABULADOR = '02' then
                nvl(HONORARIOS_01_2/nvl(NUMERO_CUOTAS,1),0)
              when pP7030_TABULADOR = '3' or pP7030_TABULADOR = '03' then
                nvl(HONORARIOS_01_3/nvl(NUMERO_CUOTAS,1),0) 
              when pP7030_TABULADOR = '4' or pP7030_TABULADOR = '04' then
                nvl(HONORARIOS_01_4/nvl(NUMERO_CUOTAS,1),0)
              when pP7030_TABULADOR = '5' or pP7030_TABULADOR = '05' then
                nvl(HONORARIOS_01_5/nvl(NUMERO_CUOTAS,1),0)
              when pP7030_TABULADOR = '6' or pP7030_TABULADOR = '06' then
                nvl(HONORARIOS_01_6/nvl(NUMERO_CUOTAS,1),0)
              else nvl(HONORARIOS_01_1/nvl(NUMERO_CUOTAS,1),0)
              end honorarios
              into monto_baremo 
              from GD_INV_ITEMS
              where CODSEDE = pGLOBALsede and CODIGO_ITEM = x.c001;
              --vCodEspecialidad := PROC_GEN_GENERAL.SUB_CODIGO(x.c001, '-', 3);--Obtenemos Especialidad del último Ítem facturado...              
            end if;
            
            if x.c001 is not NULL and x.c001 <> '0' and (x.c005 = '1cuotas' or x.c005 = '2itemsP') then
            --El baremo sale de CUOTAS/PRESUPUESTO (x.c006)...
              monto_baremo := x.c006;
            end if;
    
            monto_baremo := monto_baremo * x.c004;
        
            insert into GD_ADM_FACTURAS_RENG 
            values (pGLOBALsede, pGLOBALcompania, pP7030_FACTURA1||'-'||to_char(l_factura_id, 'FM000009'), c1, 
                    x.c001, cuota, x.c003, x.c002, x.c004, monto_baremo);
                     
            if flagVisita = 0 then
              select count(*) into flagVisita --Determinamos si hay visita ...
              from DUAL
              where (pP7030_ESPECIALIDAD = (select ValorParametro
                                            from GD_GEN_PARAMETROS
                                            where CodSede = pGLOBALsede
                                            and CodParametro = 'CodServicioOrtodoncia')
              and x.c001 in (select ValorParametro
                             from GD_GEN_PARAMETROS
                             where CodSede = pGLOBALsede
                             and CodParametro like 'CodItemConsulta%'))
              or (pP7030_ESPECIALIDAD <> (select ValorParametro
                                          from GD_GEN_PARAMETROS
                                          where CodSede = pGLOBALsede
                                          and CodParametro = 'CodServicioOrtodoncia'));
            end if;
                      
          end if;
        
          if x.c005 = '3cobros' then 
            c2 := c2 + 1;
            insert into GD_ADM_COBROS_RENG 
            values (pGLOBALsede, pGLOBALcompania, 0, pP7030_FACTURA1||'-'||to_char(l_factura_id, 'FM000009'), c2, 
                    x.c007, x.c006, x.c008, x.c003, fechaFactura);
          end if;       
        end loop;
        
        -- Loop through the FACTURA collection and update CUOTAS table
        for x in (
  --      select c001, c002, sum(c003) c003, c004, c005, c006, c007,c008, c009, c010 
  --      from apex_collections 
  --      where collection_name = 'FACTURA' 
  --      group by c005, c001, c002, c003, c004, c006, c007, c008, c009, c010
  --      order by c005, c001, c002
          select c001, c002, sum(c003) c003, c004, c005, c006, c007,c008, c009, c010
          from APEX_040200.COLECCION_APEX
          where SESSION_ID = pSESSION_ID
          and COLLECTION_NAME = 'FACTURA'
          group by c005, c001, c002, c003, c004, c006, c007, c008, c009, c010
          order by c005, c001, c002
        )
        loop
          cuota := 0; 
          if x.c005 = '1cuotas' then 
            cuota := x.c009; 
            update GD_ADM_CUOTAS 
            set NUMFACTURA = pP7030_FACTURA1||'-'||to_char(l_factura_id, 'FM000009'), FECPAGO = fechaFactura  
            where (NUMHISTORIA = historia and NUMPRESUPUESTO = pP7030_PRESUPUESTO and NUMCUOTA = cuota and CODSEDE = pGLOBALsede
            and nvl(NUMFACTURA,' ') = ' ' 
            and x.c010 = ROWID);
          end if;     
        end loop;  
            
        --Inicializaciones
        pP7030_FACTURA2 := l_factura_id;
        pP7030_NUMERO_FACTURA2 := pP7030_FACTURA1||'-'||to_char(l_factura_id, 'FM000009');
        pP7030_NUMERO_CONTROL :=  numero_control;
        
        l_factura_id := l_factura_id + 1;
        update GD_GEN_CONTADORES_DOCUMENTOS 
        set CONTADOR = l_factura_id 
        where CODCOMPANIA = pGLOBALcompania and ANO = 0 and TIPO_DOCUMENTO = 'FACTURA' 
        and SUB_TIPO_DOCUMENTO = substr(pP7030_FACTURA1,3,1);
        
        pP7030_NRO_CONTROL2 := pP7030_NRO_CONTROL2 + 1;
        update GD_GEN_CONTADORES_DOCUMENTOS 
        set CONTADOR = pP7030_NRO_CONTROL2 
        where CODCOMPANIA = pGLOBALcompania and ANO = 0 and TIPO_DOCUMENTO = 'CONTROL' 
        and SUB_TIPO_DOCUMENTO = substr(pP7030_FACTURA1,3,1);
  
        select CAJA_NUMERO, NVL(FACTURA_INICIAL,'0'), FECHA_FACTURA_I, NVL(FACTURA_FINAL,'0'), FECHA_FACTURA_F 
        into n_caja, t_fac_i, d_fac_i, t_fac_f, d_fac_f 
        from GD_CJA_CAJAS 
        where CAJA_NUMERO = pP7030_CAJA_NUMERO;
        
        if t_fac_i = '0' then
          t_fac_i := pP7030_NUMERO_FACTURA2;
          d_fac_i := fechaFactura;
          t_fac_f := pP7030_NUMERO_FACTURA2;
          d_fac_f := fechaFactura;
        else
          t_fac_f := pP7030_NUMERO_FACTURA2;
          d_fac_f := fechaFactura;
         end if;
         
        update GD_CJA_CAJAS 
        set FACTURA_INICIAL = t_fac_i, FECHA_FACTURA_I = d_fac_i, FACTURA_FINAL = t_fac_f, FECHA_FACTURA_F = d_fac_f 
        where CAJA_NUMERO = n_caja;
        
        if pP7030_PRESUPUESTO IS NOT NULL and pP7030_PRESUPUESTO <> '0' then
          update GD_PPTO_PRESUPUESTOS 
          set LETRAIDRESPPAGO = pP7030_NAC_RPAGO, NUMIDRESPPAGO = pP7030_RESPONSABLE_PAGO_CI, NOMBRESPPAGO = pP7030_RESPONSABLE_PAGO_NOMBRE,
          --Esto va comentado... se descomenta por Brion para depurar presupuestos...
          CODSERVICIO = pP7030_ESPECIALIDAD, CODESPECIALISTA = pP7030_ESPECIALISTA
          where NUMPRESUPUESTO = pP7030_PRESUPUESTO and CODSEDE = pGLOBALsede;
               
          select PERSONAID, CODESPECIALIDAD into vPersonaID, vCodEspecialidad --Obtenemos PersonaID
          from GD_PPTO_PRESUPUESTOS
          where NUMPRESUPUESTO = pP7030_PRESUPUESTO and CODSEDE = pGLOBALsede;
        else
          begin 
            vCodEspecialidad := pP7030_ESPECIALIDADII;
            select PERSONAID into vPersonaID --Obtenemos PersonaID
            from GD_GEN_HISTORIAS_PERSONA
            where NUMHISTORIA = historia
            and ROWNUM = 1;
          exception
          when OTHERS then
            select PERSONAID into vPersonaID
            from GD_GEN_PERSONAS
            where NUMHISTORIA = historia
            and ROWNUM = 1;
          end;
        end if;
        
        if flagVisita <> 0 then
          PROC_GEN_GENERAL.ACTUALIZA_HISTORIA(vPersonaID, pGLOBALsede, pP7030_ESPECIALIDAD,
            vCodEspecialidad, pP7030_ESPECIALISTA, pP7030_PRESUPUESTO, historia);
            
          PROC_GEN_GENERAL.ACTUALIZA_FECHAS_VISITA(vPersonaID, pGLOBALsede, pP7030_ESPECIALIDAD ,
            vCodEspecialidad, pP7030_ESPECIALISTA, historia, TO_CHAR(fechaFactura, 'DD/MM/YYYY HH24:MI:SS'), NULL );
        end if;
        
        -- Truncate the collection after the order has been placed
        --apex_collection.truncate_collection(p_collection_name => 'FACTURA');
        
  --      apex_collection.create_or_truncate_collection(p_collection_name => 'BUFFER');
  --      apex_collection.add_member(p_collection_name => 'BUFFER', p_c001 => 0, p_c002 => 0, p_c003 => 0, p_c004 => 0, p_c005 => 0, p_c006 => 0, p_c007 => 0);    
        commit; 
      exception
        when OTHERS then
--        apex_error.add_error (
--          p_message          => '***ERROR: Error BD inisperado...',
--          p_display_location => apex_error.c_inline_in_notification );
--          raise Contador_Invalido;
          errores := errores + 64;
      end;
      return errores;
    end;
  END FACTURAR;



  FUNCTION  AJUSTAR_FACTURA (pSESSION_ID NUMBER,
                             pGLOBALsede VARCHAR2,
                             pGLOBALcompania VARCHAR2) 
                             RETURN NUMBER AS
  BEGIN

    declare
      l_factura_id number;
      
      cuota number := 0;
      historia varchar2(20) := 0;
      numero_control varchar2(20) := '0';
      
      c1 number := 0;
    
    begin
      -- Fetch values that need to be inserted into the Facturas Header
      select GD_CJA_FACTTMP_SEQ.nextval into l_factura_id from dual;
      
      -- Insert a row into the Order Header table
      insert into GD_ADM_FACT_TMP values(pGLOBALsede, pGLOBALcompania, l_factura_id, sysdate, historia, numero_control);
      
      -- Loop through the ORDER collection and insert rows into the Order Line Item table
      for x in (
  --    select c001, c002, sum(c003) c003, c004, c005, c006, c007,c008, c009, c010 from apex_collections 
  --    where collection_name = 'FACTURA' 
  --    group by c005, c001, c002, c003, c003, c004, c006, c007,c008, c009, c010
  --    order by c005, c001, c002
        select c001, c002, sum(c003) c003, c004, c005, c006, c007, c008, c009, c010, n001
        from APEX_040200.COLECCION_APEX
        where SESSION_ID = pSESSION_ID
        and COLLECTION_NAME = 'FACTURA'
        group by c005, c001, c002, c003, c004, c006, c007, c008, c009, c010, n001
        order by c005, c001, c002)      
      loop
        if x.c005 = '2items' or x.c005 = '2itemsP' or x.c005 = '3cobros' then cuota := 0; end if;
        if x.c005 = '1cuotas' then cuota := x.c009; end if;
        if x.c005 = '1cuotas' or x.c005 = '2items' or x.c005 = '2itemsP' then 
          c1 := c1 + 1;
          insert into GD_ADM_FACT_RENG_TMP 
          values (pGLOBALsede, pGLOBALcompania, to_char(l_factura_id), c1, x.c001, cuota, x.c003, x.c002, x.c005, x.c010, x.c006, x.n001);
        end if;
        
      end loop;
      
      commit;
    -- Set the item P7030_FACTURA_NUMERO to the FACTURA which was just placed
--    pP7030_FACTURA_NUMERO := l_factura_id;
--    apex_collection.update_member_attribute(p_collection_name => 'BUFFER', 
--          p_seq => 1, p_attr_number => 10, p_attr_value => l_factura_id);
      return l_factura_id;
    
    end;


  END AJUSTAR_FACTURA;

END PROC_CAJAS;
