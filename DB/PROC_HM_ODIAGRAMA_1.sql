--------------------------------------------------------
--  DDL for Package Body PROC_HM_ODIAGRAMA
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "GDCNO"."PROC_HM_ODIAGRAMA" AS

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
  vDESCRIPCION VARCHAR2(4000);
  dummy varchar2(800);
  veces number;
  dummy2 varchar2(800);
  veces2 number;
  dummy3 varchar2(800);
  veces3 number;
  dummy4 varchar2(800);
  veces4 number;
  dummy5 varchar2(800);
  veces5 number;
  dummy6 varchar2(800);
  veces6 number;
  dummy7 varchar2(800);
  veces7 number;
  dummy8 varchar2(800);
  veces8 number;
  descrip varchar2(4000);
  descripBloq varchar2(4000);
  descripExtr varchar2(4000);
  descripRet varchar2(4000);
  descripAux varchar2(4000);
  descripTub varchar2(4000);
  descripBan varchar2(4000);
  descripRef varchar2(4000);
  pDESCRIP_TRAT varchar2(4000);
  pDESCRIP_BLOQ varchar2(4000);
  pDESCRIP_RET varchar2(4000);
  pDESCRIP_EXTR varchar2(4000);
  pDESCRIP_AUX varchar2(4000);
  pDESCRIP_TUB varchar2(4000);
  pDESCRIP_BAN varchar2(4000);
  pDESCRIP_REF varchar2(4000);
  
  BEGIN 
  BEGIN
  pDESCRIP_TRAT := 'Tratamientos: ';
  pDESCRIP_BLOQ := 'Dientes bloqueados: ';
  pDESCRIP_RET := 'Dientes retenidos: ';
  pDESCRIP_EXTR := 'Extracciones: ';
  pDESCRIP_AUX := 'Auxiliares: ';
  pDESCRIP_TUB := 'Tubos: ';
  pDESCRIP_BAN := 'Bandas: ';
  pDESCRIP_REF := 'Referencias: '; 
  SELECT HO.TRATAMIENTO,
         (LENGTH(HO.TRATAMIENTO)-LENGTH(REPLACE(HO.TRATAMIENTO,':','')))/LENGTH(':')
  INTO   dummy, veces
  FROM   GD_HM_OD_HISTORIAS_ORTO HO, GD_HM_ORTODONCIA O, GD_GEN_PERSONAS P 
  WHERE  O.NUMHISTORIA = P.NUMHISTORIA 
  AND    O.NUMHISTORIA = HO.NUMHISTORIA 
  AND    O.TRATAMIENTOID = HO.TRATAMIENTOID 
  AND    O.NUMHISTORIA = pNUMHISTORIA;
  
  SELECT O.BLOQUEADOS,
         (LENGTH(O.BLOQUEADOS)-LENGTH(REPLACE(O.BLOQUEADOS,':','')))/LENGTH(':')
  INTO   dummy2, veces2
  FROM   GD_HM_OD_HISTORIAS_ORTO HO, GD_HM_ORTODONCIA O, GD_GEN_PERSONAS P 
  WHERE  O.NUMHISTORIA = P.NUMHISTORIA 
  AND    O.NUMHISTORIA = HO.NUMHISTORIA 
  AND    O.TRATAMIENTOID = HO.TRATAMIENTOID 
  AND    O.NUMHISTORIA = pNUMHISTORIA;
  
  SELECT O.RETENIDOS,
         (LENGTH(O.RETENIDOS)-LENGTH(REPLACE(O.RETENIDOS,':','')))/LENGTH(':')
  INTO   dummy3, veces3
  FROM   GD_HM_OD_HISTORIAS_ORTO HO, GD_HM_ORTODONCIA O, GD_GEN_PERSONAS P 
  WHERE  O.NUMHISTORIA = P.NUMHISTORIA 
  AND    O.NUMHISTORIA = HO.NUMHISTORIA 
  AND    O.TRATAMIENTOID = HO.TRATAMIENTOID 
  AND    O.NUMHISTORIA = pNUMHISTORIA;
  
  SELECT HO.EXTRACCIONES,
         (LENGTH(HO.EXTRACCIONES)-LENGTH(REPLACE(HO.EXTRACCIONES,':','')))/LENGTH(':')
  INTO   dummy4, veces4
  FROM   GD_HM_OD_HISTORIAS_ORTO HO, GD_HM_ORTODONCIA O, GD_GEN_PERSONAS P 
  WHERE  O.NUMHISTORIA = P.NUMHISTORIA 
  AND    O.NUMHISTORIA = HO.NUMHISTORIA 
  AND    O.TRATAMIENTOID = HO.TRATAMIENTOID 
  AND    O.NUMHISTORIA = pNUMHISTORIA;
  
  SELECT HO.AUXILIARES,
         (LENGTH(HO.AUXILIARES)-LENGTH(REPLACE(HO.AUXILIARES,':','')))/LENGTH(':')
  INTO   dummy5, veces5
  FROM   GD_HM_OD_HISTORIAS_ORTO HO, GD_HM_ORTODONCIA O, GD_GEN_PERSONAS P 
  WHERE  O.NUMHISTORIA = P.NUMHISTORIA 
  AND    O.NUMHISTORIA = HO.NUMHISTORIA 
  AND    O.TRATAMIENTOID = HO.TRATAMIENTOID 
  AND    O.NUMHISTORIA = pNUMHISTORIA;
  
  SELECT HO.TUBOS,
         (LENGTH(HO.TUBOS)-LENGTH(REPLACE(HO.TUBOS,':','')))/LENGTH(':')
  INTO   dummy6, veces6
  FROM   GD_HM_OD_HISTORIAS_ORTO HO, GD_HM_ORTODONCIA O, GD_GEN_PERSONAS P 
  WHERE  O.NUMHISTORIA = P.NUMHISTORIA 
  AND    O.NUMHISTORIA = HO.NUMHISTORIA 
  AND    O.TRATAMIENTOID = HO.TRATAMIENTOID 
  AND    O.NUMHISTORIA = pNUMHISTORIA;
  
  SELECT HO.BANDAS,
         (LENGTH(HO.BANDAS)-LENGTH(REPLACE(HO.BANDAS,':','')))/LENGTH(':')
  INTO   dummy7, veces7
  FROM   GD_HM_OD_HISTORIAS_ORTO HO, GD_HM_ORTODONCIA O, GD_GEN_PERSONAS P 
  WHERE  O.NUMHISTORIA = P.NUMHISTORIA 
  AND    O.NUMHISTORIA = HO.NUMHISTORIA 
  AND    O.TRATAMIENTOID = HO.TRATAMIENTOID 
  AND    O.NUMHISTORIA = pNUMHISTORIA;
  
  SELECT HO.REFERENCIAS,
         (LENGTH(HO.REFERENCIAS)-LENGTH(REPLACE(HO.REFERENCIAS,':','')))/LENGTH(':')
  INTO   dummy8, veces8
  FROM   GD_HM_OD_HISTORIAS_ORTO HO, GD_HM_ORTODONCIA O, GD_GEN_PERSONAS P 
  WHERE  O.NUMHISTORIA = P.NUMHISTORIA 
  AND    O.NUMHISTORIA = HO.NUMHISTORIA 
  AND    O.TRATAMIENTOID = HO.TRATAMIENTOID 
  AND    O.NUMHISTORIA = pNUMHISTORIA;
  
  select 'Paciente '||
  case
  when GENERO = 'F' then 'femenino '
  when GENERO = 'M' then 'masculino '
  else 'sexo? ' 
  end ||'de '||TRUNC(MONTHS_BETWEEN(sysdate,nvl(FECNACIMIENTO,'01/01/1900'))/12)||' años y '||TRUNC(((MONTHS_BETWEEN(sysdate,nvl(FECNACIMIENTO,'01/01/1900'))/12)-TRUNC(MONTHS_BETWEEN(sysdate,nvl(FECNACIMIENTO,'01/01/1900'))/12))*12)||' meses'||
  DECODE(MOTIVO_CONSULTA,NULL,'',chr(13)||'Motivo de la consulta: ')||MOTIVO_CONSULTA||
  DECODE(ALERTAS_MEDICAS,NULL,'',chr(13)||'Alertas: ')||ALERTAS_MEDICAS||
  DECODE(HO.ORTODONCISTA,NULL,'',chr(13)||'Ortodoncista: ')||(SELECT APELLESPECIALISTA||' , '||NOMESPECIALISTA FROM GD_GEN_ESPECIALISTAS WHERE LOGINUSUARIO = HO.ORTODONCISTA)||
  DECODE(O.STSTRATAMIENTO,NULL,'',chr(13)||'Estatus del tratamiento: ')||case 
  when O.STSTRATAMIENTO = 'ACT' then ' Activo '
  when O.STSTRATAMIENTO = 'CER' then ' Cerrado '
  else ' Estatus? '
  end||
  DECODE(O.MORDIDA_CRUZADA_ANT,NULL,'',chr(13)||'Mordida cruzada anterior: ')||
         (select DESCRIPCION
          from GD_HM_ORTO_MORDIDAANT
          where CODIGO = O.MORDIDA_CRUZADA_ANT)||
  DECODE(O.MORDIDA_CRUZADA_POST,NULL,'',chr(13)||'Mordida cruzada posterior: ')||
  (select DESCRIPCION
          from GD_HM_ORTO_MORDIDAPOST
          where CODIGO = O.MORDIDA_CRUZADA_POST)||
  DECODE(O.MORDIDA_ABIERTA_ANT,NULL,'',chr(13)||'Mordida abierta anterior: ')||
  (select DESCRIPCION
          from GD_HM_ORTO_MORDIDAANT
          where CODIGO = O.MORDIDA_ABIERTA_ANT)||
  DECODE(O.MORDIDA_ABIERTA_POST,NULL,'',chr(13)||'Mordida abierta posterior: ')||
  (select DESCRIPCION
          from GD_HM_ORTO_MORDIDAPOST
          where CODIGO = O.MORDIDA_ABIERTA_POST)||
  DECODE(O.MORDIDA_PRF,NULL,'',chr(13)||'Mordida profunda: ')||
  (select DESCRIPCION
          from GD_HM_ORTO_MORDIDAPRF
          where CODIGO = O.MORDIDA_PRF)||
  DECODE(O.APINAMIENTO_MAN,NULL,'',chr(13)||'Apiñamiento mandibular: ')||
  (select DESCRIPCION
          from GD_HM_ORTO_APINAMIENTO
          where CODIGO =O.APINAMIENTO_MAN)||
  DECODE(O.APINAMIENTO_MAX,NULL,'',chr(13)||'Apiñamiento maxilar: ')||
  (select DESCRIPCION
          from GD_HM_ORTO_APINAMIENTO
          where CODIGO =O.APINAMIENTO_MAX)||
  DECODE(O.ESPACIAMIENTO_MAN,NULL,'',chr(13)||'Espaciamiento mandibular: ')||
    (select DESCRIPCION
          from GD_HM_ORTO_APSP
          where CODIGO =O.ESPACIAMIENTO_MAN)||
  DECODE(O.ESPACIAMIENTO_MAX,NULL,'',chr(13)||'Espaciamiento maxilar: ')||
      (select DESCRIPCION
          from GD_HM_ORTO_APSP
          where CODIGO =O.ESPACIAMIENTO_MAX)||
  DECODE(O.CURVA_SPEE,NULL,'',chr(13)||'Curva de Spee: ')||
  (select DESCRIPCION
          from GD_HM_ORTO_APSP
          where CODIGO =O.CURVA_SPEE)||
  DECODE(O.LINEAMEDIA_SUP_IZQ,NULL,'',chr(13)||'Linea media superior izquierda: ')||
  (select DESCRIPCION
          from GD_HM_ORTO_APSP
          where CODIGO =O.LINEAMEDIA_SUP_IZQ)||
  DECODE(O.LINEAMEDIA_SUP_DER,NULL,'',chr(13)||'Linea media superior derecha: ')||
  (select DESCRIPCION
          from GD_HM_ORTO_APSP
          where CODIGO =O.LINEAMEDIA_SUP_DER)||
  DECODE(O.LINEAMEDIA_INF_IZQ,NULL,'',chr(13)||'Linea media inferior izquierda: ')||
  (select DESCRIPCION
          from GD_HM_ORTO_APSP
          where CODIGO =O.LINEAMEDIA_INF_IZQ)||
  DECODE(O.LINEAMEDIA_INF_DER,NULL,'',chr(13)||'Linea media inferior derecha: ')||
  (select DESCRIPCION
          from GD_HM_ORTO_APSP
          where CODIGO =O.LINEAMEDIA_INF_DER)||
  DECODE(O.CLASIFICACION_MOLAR_DER,NULL,'',chr(13)||'Clasificación molar derecha: ')||
  (select DESCRIPCION
          from GD_HM_ORTO_CLASIFICACION
          where CODIGO = O.CLASIFICACION_MOLAR_DER)||
  DECODE(O.CLASIFICACION_MOLAR_IZQ,NULL,'',chr(13)||'Clasificación molar izquierda: ')||
  (select DESCRIPCION
          from GD_HM_ORTO_CLASIFICACION
          where CODIGO = O.CLASIFICACION_MOLAR_IZQ)||
  DECODE(O.CLASIFICACION_CANINO_DER,NULL,'',chr(13)||'Clasificación canino derecho: ')||
  (select DESCRIPCION
          from GD_HM_ORTO_CLASIFICACION
          where CODIGO = O.CLASIFICACION_CANINO_DER)||
  DECODE(O.CLASIFICACION_CANINO_IZQ,NULL,'',chr(13)||'Clasificación canino izquierdo: ')||
    (select DESCRIPCION
          from GD_HM_ORTO_CLASIFICACION
          where CODIGO = O.CLASIFICACION_CANINO_IZQ)||
  DECODE(O.CLASIFICACION_ESQUELETAL,NULL,'',chr(13)||'Clasificación esqueletal: ')||
  (select DESCRIPCION
          from GD_HM_ORTO_CLASIFICACIONesq
          where CODIGO = O.CLASIFICACION_ESQUELETAL)||
  DECODE(O.PERFIL,NULL,'',chr(13)||'Perfil: ')||
  (select DESCRIPCION
          from GD_HM_ORTO_PERFILES
          where CODIGO =O.PERFIL)||
  DECODE(O.ANGULO_NASOLABIAL,NULL,'',chr(13)||'Angulo nasolabial: ')||
  (select DESCRIPCION
          from GD_HM_ORTO_ANGULOS
          where CODIGO =O.ANGULO_NASOLABIAL)||
  DECODE(O.ANGULO_MENTOLABIAL,NULL,'',chr(13)||'Angulo mentolabial: ')||
  (select DESCRIPCION
          from GD_HM_ORTO_ANGULOS
          where CODIGO =O.ANGULO_MENTOLABIAL)||
  DECODE(O.DIST_CUELLOMENTON,NULL,'',chr(13)||'Distancia cuello-mentón: ')||
  (select DESCRIPCION
          from GD_HM_ORTO_DISTANCIAS
          where CODIGO =O.DIST_CUELLOMENTON)||
  DECODE(O.INCOMPETENCIA_LABIAL,NULL,'',chr(13)||'Incompetencia labial: ')||
  case
  when O.INCOMPETENCIA_LABIAL = 'N' then 'No '
  when O.INCOMPETENCIA_LABIAL = 'S' then 'Si '
  end ||
  DECODE(O.EXP_DENTAL_REPOSO,NULL,'',chr(13)||'Simetría facial: ')||
  (select DESCRIPCION
          from GD_HM_ORTO_EXPRMM
          where CODIGO =O.EXP_DENTAL_REPOSO)||
  DECODE(O.SONRISA_ENCIAS,NULL,'',chr(13)||'Sonrisa Gengivitis: ')||
  case
  when O.SONRISA_ENCIAS = 'N' then 'No '
  when O.SONRISA_ENCIAS = 'S' then 'Si '
  end ||
  DECODE(O.HABITOS,NULL,'',chr(13)||'Hábitos: ')||O.HABITOS||
  DECODE(O.OTROS,NULL,'',chr(13)||'Otros: ')||O.OTROS||
  DECODE(O.RETENCION,NULL,'',chr(13)||'Retención: ')||O.RETENCION||
  DECODE(O.FECRETENCION,NULL,'',chr(13)||'Fecha de retención: ')||O.FECRETENCION||chr(13)
  into vDESCRIPCION
  from GD_HM_ORTODONCIA O, GD_HM_OD_HISTORIAS_ORTO HO, GD_GEN_PERSONAS P
  where O.NUMHISTORIA = P.NUMHISTORIA 
  and O.NUMHISTORIA = HO.NUMHISTORIA 
  and O.TRATAMIENTOID = HO.TRATAMIENTOID 
  and O.NUMHISTORIA = pNUMHISTORIA;
  
  FOR cont IN 1..veces+1
  LOOP
     select T.DESCRIPCION 
       INTO descrip 
       from GD_HM_OD_TRATAMIENTOS T 
       where T.TRATAMIENTO = regexp_substr(dummy,'[[:digit:]]+',1,cont);   
       pDESCRIP_TRAT := pDESCRIP_TRAT || chr(13) || '-' || descrip;
  END LOOP;
  
  FOR cont2 IN 1..veces2+1
  LOOP
     select T.DESCRIPCION 
       INTO descripBloq 
       from GD_HM_ORTO_DIENTES T 
       where T.DIENTE = regexp_substr(dummy2,'[[:digit:]]+',1,cont2);   
       pDESCRIP_BLOQ := pDESCRIP_BLOQ || chr(13) || '-' || descripBloq;
  END LOOP;
  
  FOR cont3 IN 1..veces3+1
  LOOP
     select T.DESCRIPCION 
       INTO descripRet 
       from GD_HM_ORTO_DIENTES T 
       where T.DIENTE = regexp_substr(dummy3,'[[:digit:]]+',1,cont3);   
       pDESCRIP_RET := pDESCRIP_RET || chr(13) || '-' || descripRet;
  END LOOP;
  
  FOR cont4 IN 1..veces4+1
  LOOP
     select T.DESCRIPCION 
       INTO descripExtr 
       from ( select DESCRIPCION, DIENTE, ORDEN
                from GD_HM_ORTO_DIENTES
               union
              select DESCRIPCION, CODIGO, ORDEN
                from GD_HM_ORTO_EXTRACCIONES
            order by ORDEN, 2  ) T 
       where T.DIENTE = regexp_substr(dummy4,'[[:digit:]]+',1,cont4);   
       pDESCRIP_EXTR := pDESCRIP_EXTR || chr(13) || '-' || descripExtr;
  END LOOP;
  
  FOR cont5 IN 1..veces5+1
  LOOP
     select DESCRIPCION 
       INTO descripAux 
       from GD_HM_ORTO_AUX
       where CODIGO = regexp_substr(dummy5,'[[:alpha:]]+',1,cont5);   
       pDESCRIP_AUX := pDESCRIP_AUX || chr(13) || '-' || descripAux;
  END LOOP;

  FOR cont6 IN 1..veces6+1
  LOOP
     select DESCRIPCION 
       INTO descripTub 
       from GD_HM_ORTO_BANDAS
       where BANDA = regexp_substr(dummy6,'[[:digit:]]+',1,cont6);   
       pDESCRIP_TUB := pDESCRIP_TUB || chr(13) || '-' || descripTub;
  END LOOP;
  
  FOR cont7 IN 1..veces7+1
  LOOP
     select DESCRIPCION 
       INTO descripBan 
       from GD_HM_ORTO_BANDAS
       where BANDA = regexp_substr(dummy7,'[[:digit:]]+',1,cont7);   
       pDESCRIP_BAN := pDESCRIP_BAN || chr(13) || '-' || descripBan;
  END LOOP;
  
  FOR cont8 IN 1..veces8+1
  LOOP
     select DESCRIPCION 
       INTO descripRef 
       from GD_HM_ORTO_REFERENCIAS
       where CODIGO = regexp_substr(dummy8,'[[:alnum:]]+',1,cont8);   
       pDESCRIP_REF := pDESCRIP_REF || chr(13) || '-' || descripRef;
  END LOOP;
  
  vDESCRIPCION := vDESCRIPCION || pDESCRIP_TRAT ||  chr(13) || pDESCRIP_BLOQ || chr(13) || pDESCRIP_RET || CHR(13) || pDESCRIP_EXTR || chr(13) || pDESCRIP_AUX || chr(13) || pDESCRIP_TUB || chr(13) || pDESCRIP_BAN || chr(13) || pDESCRIP_REF;
  
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
  vDESCRIPCION := '...';
  END;
  RETURN vDESCRIPCION;
  
  END ORTO_DIAGNOSTICO_DESCRIPCION;
  
END PROC_HM_ODIAGRAMA;
