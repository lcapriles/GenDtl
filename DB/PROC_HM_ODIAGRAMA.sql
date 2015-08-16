CREATE OR REPLACE PACKAGE PROC_HM_ODIAGRAMA AS 

  FUNCTION ODONTODIAG_MANT_DIAG (pPARMS GD_HM_OD_HISTORIAS%ROWTYPE,
                                 pFECHA VARCHAR2)
                                 RETURN VARCHAR2; 
                                 
  FUNCTION ORTO_HISTORIAS_DESCRIPCION (pTRATAMIENTOID VARCHAR2)
                                       RETURN VARCHAR2;
                                       
  PROCEDURE ORTO_LIGADURAS_BORRAR (pRID ROWID);    
  
  FUNCTION ORTO_DIAGNOSTICO_DESCRIPCION (pNUMHISTORIA VARCHAR2)
                                       RETURN VARCHAR2;
                                 
END PROC_HM_ODIAGRAMA;
/


CREATE OR REPLACE PACKAGE BODY PROC_HM_ODIAGRAMA AS

  FUNCTION ODONTODIAG_MANT_DIAG (pPARMS GD_HM_OD_HISTORIAS%ROWTYPE,
                                 pFECHA VARCHAR2)
                                 RETURN VARCHAR2 AS
    vTRATAMIENTOID    VARCHAR2(10);
    
  BEGIN
    vTRATAMIENTOID := DBMS_RANDOM.STRING('a',10);
    
    insert into GD_HM_OD_HISTORIAS (NUMHISTORIA, DIENTE, POSICION, CODESPECIALISTA, FECHA, TIPO, OBSERVACIONES, 
                                    DIAGRAMA, CITAID, NUMPRESUPUESTO, CODSERVICIO, ESPECIALIDAD, TRATAMIENTO, 
                                    HALLAZGO, CODSEDE, TRATAMIENTOID, NUMTRATAMIENTO, STSTRATAMIENTO) 
                                    values (pPARMS.NUMHISTORIA, pPARMS.DIENTE, pPARMS.POSICION, pPARMS.CODESPECIALISTA,
                                            to_date(pFECHA,'DD/MM/YY HH24:MI:SS'), pPARMS.TIPO, pPARMS.OBSERVACIONES, 
                                            pPARMS.DIAGRAMA, pPARMS.CITAID, pPARMS.NUMPRESUPUESTO, pPARMS.CODSERVICIO, 
                                            pPARMS.ESPECIALIDAD, pPARMS.TRATAMIENTO, pPARMS.HALLAZGO, pPARMS.CODSEDE, 
                                            vTRATAMIENTOID, vTRATAMIENTOID, pPARMS.STSTRATAMIENTO);
    RETURN vTRATAMIENTOID;
  END ODONTODIAG_MANT_DIAG;

  FUNCTION ORTO_HISTORIAS_DESCRIPCION (pTRATAMIENTOID VARCHAR2)
                                       RETURN VARCHAR2 AS
    vDESCRIPCION    VARCHAR2(512);
    
  BEGIN
    vDESCRIPCION := '';
    for c1 in (select NUMHISTORIA, FECHA, TRATAMIENTOID, CODSEDE, CODSERVICIO, ESPECIALIDAD,
                      ARCOS, ARCOI, LIGADURASD, LIGADURASH, LIGADURASI, BRAKETS, BANDAS,
                      AUXILIARES, ELASINTERMAXD, ELASINTERMAXI, ELASINTERMAXDM, ELASINTERMAXIM,
                      EXTRACCIONES, TUBOS, BOTONES, OBSERVACIONES, ORTODONCISTA, RETENCION,

                      decode(decode(A1.DESCRCORTA,NULL,A1.DESCRIPCION),NULL,A1.DESCRCORTA) DESA1,
                      decode(decode(A2.DESCRCORTA,NULL,A2.DESCRIPCION),NULL,A2.DESCRCORTA) DESA2,
                      decode(decode(D1.DESCRCORTA,NULL,D1.DESCRIPCION),NULL,D1.DESCRCORTA) DESD1, 
                      decode(decode(D2.DESCRCORTA,NULL,D2.DESCRIPCION),NULL,D2.DESCRCORTA) DESD2
                      
               from GD_HM_OD_HISTORIAS_ORTO HO, 
                    GD_HM_ORTO_ARCOS A1,
                    GD_HM_ORTO_ARCOS A2,
                    GD_HM_ORTO_DIENTES D1,
                    GD_HM_ORTO_DIENTES D2,
                    GD_HM_ORTO_DIENTES D3
               where TRATAMIENTOID = pTRATAMIENTOID
               and nvl(ARCOS,'0') = A1.ARCO
               and nvl(ARCOI,'0') = A2.ARCO
               and nvl(LIGADURASD,'0') = D1.DIENTE
               and nvl(LIGADURASH,'0') = D2.DIENTE
               order by FECHA DESC)
    loop
    
    vDESCRIPCION := '';  
    
    if c1.DESA1 is not NULL then
      vDESCRIPCION := 'Arco '||c1.DESA1;
    end if;
    if c1.DESA2 is not NULL then
      vDESCRIPCION := vDESCRIPCION ||' '||c1.DESA2;
    end if;
    if c1.DESA1 is not NULL or c1.DESA2 is not NULL then
      vDESCRIPCION := vDESCRIPCION || chr(13);
    end if;     
    if c1.DESD1 is not NULL then
      vDESCRIPCION := vDESCRIPCION ||'Ligadura '||c1.DESD1;
    end if;
    if c1.DESD2 is not NULL then
      vDESCRIPCION := vDESCRIPCION ||' '||c1.DESD2;  
    end if;
    if c1.DESD1 is not NULL or c1.DESD2 is not NULL then
      vDESCRIPCION := vDESCRIPCION || chr(13);
    end if;
    if c1.LIGADURASI is not NULL then
      vDESCRIPCION := vDESCRIPCION ||' '||c1.LIGADURASI|| chr(13);  
    end if;
    if c1.BRAKETS is not NULL then
      vDESCRIPCION := vDESCRIPCION ||'Br/Tb Caídos '||c1.BRAKETS|| chr(13);  
    end if;
    if c1.BANDAS is not NULL then
      vDESCRIPCION := vDESCRIPCION ||'Bn Caídas '||c1.BANDAS|| chr(13);  
    end if;
    if c1.OBSERVACIONES is not NULL then
      vDESCRIPCION := vDESCRIPCION || chr(13);
      vDESCRIPCION := vDESCRIPCION || c1.OBSERVACIONES;  
    end if;
   
    end loop;
    
    RETURN vDESCRIPCION;
  
  END ORTO_HISTORIAS_DESCRIPCION;
  
  PROCEDURE ORTO_LIGADURAS_BORRAR (pRID ROWID) AS
  
  BEGIN
  
    delete GD_HM_OD_HISTORIAS_LIGADURAS
    where ROWID = pRID;
  
  END ORTO_LIGADURAS_BORRAR;
  
  FUNCTION ORTO_DIAGNOSTICO_DESCRIPCION (pNUMHISTORIA VARCHAR2)
                                               RETURN VARCHAR2 AS
  vDESCRIPCION    VARCHAR2(16384);
  vBloqueados     VARCHAR2(128);
  vRetenidos      VARCHAR2(128);
  vEspEdentulos   VARCHAR2(128);
  vAusentes       VARCHAR2(128);
  vTratamiento    VARCHAR2(128);
  vExtracciones   VARCHAR2(128);
  vExtrDef        VARCHAR2(128);
  vAuxiliares     VARCHAR2(128);
  vTubos          VARCHAR2(128);
  vBandas         VARCHAR2(128);
  vReferencias    VARCHAR2(128);
    
  BEGIN
  begin 
  --Conseguimos los campos de selección múltiples...
  select BLOQUEADOS, RETENIDOS, ESPEDENTULOS, AUSENTES, TRATAMIENTO, EXTRACCIONES, EXTRACCIONESDEFINIR, AUXILIARES, TUBOS, BANDAS, REFERENCIAS
  into vBloqueados, vRetenidos, vEspEdentulos, vAusentes, vTratamiento, vExtracciones, vExtrDef, vAuxiliares, vTubos, vBandas, vReferencias
  from GD_HM_ORTODONCIA O, GD_HM_OD_HISTORIAS_ORTO HO, GD_GEN_PERSONAS P
  where O.NUMHISTORIA = P.NUMHISTORIA 
  and O.NUMHISTORIA = HO.NUMHISTORIA 
  and O.TRATAMIENTOID = HO.TRATAMIENTOID
  and O.NUMHISTORIA = pNUMHISTORIA;
  
  select 'Paciente '||
  case
  when GENERO IS NULL then 'sexo? ' 
  when GENERO = 'F' then 'femenino '
  when GENERO = 'M' then 'masculino '
  end ||
  'de '||TRUNC(MONTHS_BETWEEN(sysdate,nvl(FECNACIMIENTO,'01/01/1900'))/12)||' años y '||
         TRUNC(((MONTHS_BETWEEN(sysdate,nvl(FECNACIMIENTO,'01/01/1900'))/12)-TRUNC(MONTHS_BETWEEN(sysdate,nvl(FECNACIMIENTO,'01/01/1900'))/12))*12)||' meses'||chr(13)||
  decode(MOTIVO_CONSULTA,NULL,NULL,MOTIVO_CONSULTA||chr(13)) ||
  decode(ALERTAS_MEDICAS,NULL,NULL,'Alertas: '||ALERTAS_MEDICAS||chr(13)) ||
  decode(CLASIFICACION_MOLAR_IZQ,NULL,decode(CLASIFICACION_MOLAR_DER,NULL,NULL,'Clsf.Molar Der: '),'Clsf.Molar Izq: '||
         (select DESCRIPCION from GD_HM_ORTO_CLASIFICACION where CODIGO = CLASIFICACION_MOLAR_IZQ) || decode(CLASIFICACION_MOLAR_DER,NULL,chr(13),chr(9)||chr(9)||' Der:')) ||
  decode(CLASIFICACION_MOLAR_DER,NULL,NULL,' '||
         (select DESCRIPCION from GD_HM_ORTO_CLASIFICACION where CODIGO = CLASIFICACION_MOLAR_DER) || chr(13)) ||         
  decode(CLASIFICACION_CANINO_IZQ,NULL,decode(CLASIFICACION_CANINO_DER,NULL,NULL,'Clsf.Canino Der: '),'Clsf.Canino Izq: '||
         (select DESCRIPCION from GD_HM_ORTO_CLASIFICACION where CODIGO = CLASIFICACION_CANINO_IZQ) || decode(CLASIFICACION_CANINO_DER,NULL,chr(13),chr(9)||chr(9)||' Der:')) ||
  decode(CLASIFICACION_CANINO_DER,NULL,NULL,' '||
         (select DESCRIPCION from GD_HM_ORTO_CLASIFICACION where CODIGO = CLASIFICACION_CANINO_DER) || chr(13)) || 
  decode(CLASIFICACION_ESQUELETAL,NULL,NULL,'Clsf.Esqueletal: '||
         (select DESCRIPCION from GD_HM_ORTO_CLASIFICACIONESQ where CODIGO = CLASIFICACION_ESQUELETAL) || chr(13)) ||         
  decode(APINAMIENTO_MAN,NULL,decode(APINAMIENTO_MAX,NULL,NULL,'Apiñamiento Max: '),'Apiñamiento Man: '||
         (select DESCRIPCION from GD_HM_ORTO_APINAMIENTO where CODIGO = APINAMIENTO_MAN) || decode(APINAMIENTO_MAX,NULL,chr(13),chr(9)||chr(9)||' Max:')) ||
  decode(APINAMIENTO_MAX,NULL,NULL,' '||
         (select DESCRIPCION from GD_HM_ORTO_APINAMIENTO where CODIGO = APINAMIENTO_MAX) || chr(13)) ||
  decode(ESPACIAMIENTO_MAN,NULL,decode(ESPACIAMIENTO_MAX,NULL,NULL,'Diastemas Max: '),'Diastemas Man: '||
         (select DESCRIPCION from GD_HM_ORTO_DIASTEMAS where CODIGO = ESPACIAMIENTO_MAN) || decode(ESPACIAMIENTO_MAX,NULL,chr(13),chr(9)||chr(9)||' Max:')) ||
  decode(ESPACIAMIENTO_MAX,NULL,NULL,' '||
         (select DESCRIPCION from GD_HM_ORTO_DIASTEMAS where CODIGO = ESPACIAMIENTO_MAX) || chr(13)) ||  
  decode(CURVA_SPEE,NULL,NULL,'Curva Spee: '||
         (select DESCRIPCION from GD_HM_ORTO_APSP where CODIGO = CURVA_SPEE) || chr(13)) ||
  decode(LINEAMEDIA_SUP_IZQ,NULL,decode(LINEAMEDIA_SUP_DER,NULL,NULL,'Linea Med.Sup. Der: '),'Linea Med.Sup. Izq: '||
         (select DESCRIPCION from GD_HM_ORTO_APSP where CODIGO = LINEAMEDIA_SUP_IZQ) || decode(LINEAMEDIA_SUP_DER,NULL,chr(13),chr(9)||chr(9)||' Der:')) ||
  decode(LINEAMEDIA_SUP_DER,NULL,NULL,' '||
         (select DESCRIPCION from GD_HM_ORTO_APSP where CODIGO = LINEAMEDIA_SUP_DER) || chr(13)) ||   
  decode(LINEAMEDIA_INF_IZQ,NULL,decode(LINEAMEDIA_INF_DER,NULL,NULL,'Linea Med.Inf. Der: '),'Linea Med.Inf. Izq: '||
         (select DESCRIPCION from GD_HM_ORTO_APSP where CODIGO = LINEAMEDIA_INF_IZQ) || decode(LINEAMEDIA_INF_DER,NULL,chr(13),chr(9)||chr(9)||' Der:')) ||
  decode(LINEAMEDIA_INF_DER,NULL,NULL,' '||
         (select DESCRIPCION from GD_HM_ORTO_APSP where CODIGO = LINEAMEDIA_INF_DER) || chr(13)) ||  
  decode(vBloqueados,NULL,NULL,'Bloqueados: '||PROC_GEN_GENERAL.DESCRIPCION_MULTIPLE('GD_HM_ORTO_DIENTES',vBloqueados,':') || chr(13)) ||  
  decode(vRetenidos,NULL,NULL,'Retenidos: '||PROC_GEN_GENERAL.DESCRIPCION_MULTIPLE('GD_HM_ORTO_DIENTES',vRetenidos,':') || chr(13)) ||  
  decode(vEspEdentulos,NULL,NULL,'Esp.Edéntulos: '||PROC_GEN_GENERAL.DESCRIPCION_MULTIPLE('GD_HM_ORTO_ESPEDENTULOS',vEspEdentulos,':') || chr(13)) || 
  decode(vAusentes,NULL,NULL,'Ausentes: '||PROC_GEN_GENERAL.DESCRIPCION_MULTIPLE('GD_HM_ORTO_DIENTES',vAusentes,':') || chr(13)) ||
  decode(MORDIDA_CRUZADA_ANT,NULL,decode(MORDIDA_CRUZADA_POST,NULL,NULL,'Mordida Crz.Pos: '),'Mordida Crz.Ant: '||
         (select DESCRIPCION from GD_HM_ORTO_MORDIDAANT where CODIGO = MORDIDA_CRUZADA_ANT) || decode(MORDIDA_CRUZADA_POST,NULL,chr(13),chr(9)||chr(9)||' Pos:')) ||
  decode(MORDIDA_CRUZADA_POST,NULL,NULL,' '||
         (select DESCRIPCION from GD_HM_ORTO_MORDIDAPOST where CODIGO = MORDIDA_CRUZADA_POST) || chr(13)) ||         
  decode(MORDIDA_ABIERTA_ANT,NULL,decode(MORDIDA_ABIERTA_POST,NULL,NULL,'Mordida Abr.Pos: '),'Mordida Abr.Ant: '||
         (select DESCRIPCION from GD_HM_ORTO_MORDIDAANT where CODIGO = MORDIDA_ABIERTA_ANT) || decode(MORDIDA_ABIERTA_POST,NULL,chr(13),chr(9)||chr(9)||' Pos:')) ||
  decode(MORDIDA_ABIERTA_POST,NULL,NULL,' '||
         (select DESCRIPCION from GD_HM_ORTO_MORDIDAPOST where CODIGO = MORDIDA_ABIERTA_POST) || chr(13)) ||         
  decode(MORDIDA_PRF,NULL,NULL,'Mordida Profunda: '||
         (select DESCRIPCION from GD_HM_ORTO_MORDIDAPRF where CODIGO = MORDIDA_PRF) || chr(13)) ||
  decode(PERFIL,NULL,NULL,'Perfil: '||
         (select DESCRIPCION from GD_HM_ORTO_PERFILES where CODIGO = PERFIL) || chr(13)) ||  
  decode(INCOMPETENCIA_LABIAL,NULL,NULL,'Simetría Facial: '||
         decode(INCOMPETENCIA_LABIAL,'S','Si','No') ||decode(SONRISA_ENCIAS,NULL,chr(13),chr(9)||chr(9)||' ')) ||
  decode(SONRISA_ENCIAS,NULL,NULL,'Sonrisa Gingival: '||
         decode(SONRISA_ENCIAS,'S','Si','No') || chr(13)) ||     
  decode(HABITOS,NULL,NULL,'Hábitos: '|| HABITOS || chr(13)) ||
  decode(OTROS,NULL,NULL,'Otros: '|| OTROS || chr(13)) ||
  decode(vTratamiento,NULL,NULL,'Tratamiento: '||PROC_GEN_GENERAL.DESCRIPCION_MULTIPLE('GD_HM_OD_TRATAMIENTOS',vTratamiento,':') || chr(13)) ||
  decode(vExtrDef,NULL,NULL,'Extr.Definir: '||PROC_GEN_GENERAL.DESCRIPCION_MULTIPLE('GD_HM_ORTO_DIENTES',vExtrDef,':') || chr(13)) ||
  decode(vExtracciones,NULL,NULL,'Extr.Definiticas: '||PROC_GEN_GENERAL.DESCRIPCION_MULTIPLE('GD_HM_ORTO_DIENTES',vExtracciones,':') || chr(13)) ||
  decode(vAuxiliares,NULL,NULL,'Auxiliares: '||PROC_GEN_GENERAL.DESCRIPCION_MULTIPLE('GD_HM_ORTO_AUX',vAuxiliares,':') || chr(13)) ||
  decode(vTubos,NULL,NULL,'Tubos: '||PROC_GEN_GENERAL.DESCRIPCION_MULTIPLE('GD_HM_ORTO_TUBOS',vTubos,':') || chr(13)) ||
  decode(vBandas,NULL,NULL,'Bandas: '||PROC_GEN_GENERAL.DESCRIPCION_MULTIPLE('GD_HM_ORTO_BANDAS',vBandas,':') || chr(13)) ||
  decode(HO.OBSERVACIONES,NULL,NULL,'Observaciones Plan: '||HO.OBSERVACIONES||chr(13)) ||
  decode(vReferencias,NULL,NULL,'Referencias: '||PROC_GEN_GENERAL.DESCRIPCION_MULTIPLE('GD_HM_ORTO_REFERENCIAS',vReferencias,':') || chr(13)) ||
  'Fin...'
  into vDESCRIPCION
  from GD_HM_ORTODONCIA O, GD_HM_OD_HISTORIAS_ORTO HO, GD_GEN_PERSONAS P
  where O.NUMHISTORIA = P.NUMHISTORIA 
  and O.NUMHISTORIA = HO.NUMHISTORIA 
  and O.TRATAMIENTOID = HO.TRATAMIENTOID
  and O.NUMHISTORIA = pNUMHISTORIA;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
  vDESCRIPCION := '...';
  END;
  RETURN vDESCRIPCION;
  
  END ORTO_DIAGNOSTICO_DESCRIPCION;
  
END PROC_HM_ODIAGRAMA;
/
