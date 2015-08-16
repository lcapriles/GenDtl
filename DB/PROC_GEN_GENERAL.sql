CREATE OR REPLACE PACKAGE       PROC_GEN_GENERAL  AS
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


CREATE OR REPLACE PACKAGE BODY       PROC_GEN_GENERAL AS
/******************************************************************************
   NAME:       PROC_PRESUPUESTO
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        7/25/2013      Agust�n Botana       1. Created this package.
******************************************************************************/

PROCEDURE ACTUALIZA_HISTORIA(pPersonaID NUMBER, 
                             pCodSede VARCHAR2, 
                             pCodServicio VARCHAR2, 
                             pCodEspecialidad VARCHAR2, 
                             pCodEspecialista VARCHAR2, 
                             pNumPresupuesto VARCHAR2, 
                             pNumHistoria VARCHAR2) IS
      ErrCode varchar2(20);
--
    BEGIN
        IF pPersonaID IS NOT NULL 
        AND pCodSede IS NOT NULL 
        AND pCodServicio IS NOT NULL 
        AND pCodEspecialidad IS NOT NULL 
        AND pCodEspecialista  IS NOT NULL 
        THEN
            BEGIN            
                MERGE INTO GD_GEN_HISTORIAS_PERSONA HP
                USING (select pPersonaID as vPersonaID, pCodSede as vCodSede, pCodServicio as vCodServicio,
                              pNumHistoria as vNumHistoria, pCodEspecialidad as vCodEspecialidad, pCodEspecialista as vCodEspecialista 
                       from DUAL) s
                ON (HP.PERSONAID = s.vPersonaID 
                AND HP.CODSEDE = s.vCodSede  
                AND HP.CODSERVICIO = s.vCodServicio   
                AND HP.CODESPECIALIDAD = s.vCodEspecialidad  
                AND HP.CODESPECIALISTA = s.vCodEspecialista )
                WHEN MATCHED THEN UPDATE SET NUMHISTORIA = pNumHistoria
                WHEN NOT MATCHED THEN 
                        INSERT (PERSONAID,CODSEDE,CODSERVICIO,NUMHISTORIA,CODESPECIALIDAD,CODESPECIALISTA)
                        VALUES (s.vPersonaID,s.vCodSede,s.vCodServicio,s.vNumHistoria,s.vCodEspecialidad,s.vCodEspecialista);
            EXCEPTION
                WHEN OTHERS THEN
                    NULL;
            END;                                                                    
        END IF;                                             
            /*            
            OPEN C_HIS;
            IF C_HIS%NOTFOUND THEN -- No existe esta relacion del Paciente con la Cl�nica, la crea
                INSERT INTO GD_GEN_HISTORIAS_PERSONA
                    (PERSONAID, CODSEDE, CODSERVICIO, NUMHISTORIA, NUMHISTORIAANTERIOR, FECULTVISITA, FECPROXCITA, CODESPECIALIDAD, CODESPECIALISTA)
                VALUES
                    (pPERSONAID, pCODSEDE, pCODSERVICIO, NULL, NULL, NULL, NULL, pCODESPECIALIDAD, pCODESPECIALISTA);
            ELSE -- Existe la relaci�n; La actualiza 
                UPDATE GD_GEN_HISTORIAS_PERSONA
                SET       CodEspecialista = pCodEspecialista,
                             NumHistoria     =   pNumHistoria
                WHERE CURRENT OF C_HIS;
            END IF;
            CLOSE C_HIS;
        END IF;
        */   
    EXCEPTION 
      WHEN OTHERS THEN
        ErrCode := SQLCODE;
    END;               
--    
FUNCTION BUSCA_HISTORIA(pPersonaID NUMBER, pCodSede VARCHAR2, pCodServicio VARCHAR2, pCodEspecialidad VARCHAR2, pCodEspecialista VARCHAR2) RETURN VARCHAR2 IS
    CURSOR C_PER IS
        SELECT NumHistoria
        FROM GD_GEN_PERSONAS
        WHERE PersonaID = pPersonaID;
    --
    CURSOR C_HIS IS
        SELECT NumHistoria 
        FROM GD_GEN_HISTORIAS_PERSONA
        WHERE PersonaID = pPersonaID
            AND CodSede    = pCodSede
            AND CodServicio = pCodServicio
            AND CodEspecialidad = pCodEspecialidad
            AND CodEspecialista  = pCodEspecialista;        
    vNumHistoria GD_GEN_PERSONAS.NUMHISTORIA%TYPE;                
    BEGIN
        OPEN C_HIS;
        IF C_HIS%NOTFOUND THEN  -- No exite la relaci�n. La crea 
            OPEN C_PER;
            FETCH C_PER INTO vNumHistoria;
            CLOSE C_PER;
            ACTUALIZA_HISTORIA(pPersonaID, pCodSede, pCodServicio, pCodEspecialidad, pCodEspecialista, NULL,vNumHistoria);
        ELSE
            FETCH C_HIS INTO vNumHistoria;
        END IF;  
        CLOSE C_HIS;          
        RETURN (vNumHistoria);
    END;   
    
  --Procedimiento para actualizar la �ltima/pr�xima visita...
  PROCEDURE ACTUALIZA_FECHAS_VISITA (pPersonaID NUMBER, 
                                     pCodSede VARCHAR2, 
                                     pCodServicio VARCHAR2, 
                                     pCodEspecialidad VARCHAR2, 
                                     pCodEspecialista VARCHAR2,  
                                     pNumHistoria VARCHAR2,
                                     pFechaUltimaVisita VARCHAR2,
                                     pFechaProximaVisita VARCHAR2) IS
  BEGIN
    if pFechaUltimaVisita IS NOT NULL then
      update GD_GEN_HISTORIAS_PERSONA
      set FECULTVISITA = to_date(pFechaUltimaVisita, 'DD/MM/YYYY HH24:MI:SS')
--          CODESPECIALISTA = pCodEspecialista  LC:10/07/14>>Error de clave duplicada!!!
      where PersonaID = pPersonaID
      and CodSede = pCodSede
      and CodServicio = pCodServicio
      and CodEspecialidad = pCodEspecialidad
      and CodEspecialista = pCodEspecialista --LC:10/07/14>>Error de clave duplicada!!!
      and NumHistoria = pNumHistoria;
    end if;
    
    if pFechaProximaVisita IS NOT NULL then
      update GD_GEN_HISTORIAS_PERSONA
      set FECPROXCITA = to_date(pFechaProximaVisita, 'DD/MM/YY HH24:MI:SS')
--          CODESPECIALISTA = pCodEspecialista  LC:10/07/14>>Error de clave duplicada!!!
      where PersonaID = pPersonaID
      and CodSede = pCodSede
      and CodServicio = pCodServicio
      and CodEspecialidad = pCodEspecialidad
      and CodEspecialista = pCodEspecialista --LC:10/07/14>>Error de clave duplicada!!!
      and NumHistoria = pNumHistoria;
    end if;    
  
  END ACTUALIZA_FECHAS_VISITA;
  

  --�Funci�n para devolver un subc�digo a partir de un delimitador..  
  FUNCTION SUB_CODIGO (pCodigo VARCHAR2,
                       pDelimitador VARCHAR2,
                       pOrdinal NUMBER)
                       RETURN VARCHAR2 AS
                       
  BEGIN
  declare
    posicionInicial NUMBER;
    posicionFinal NUMBER;
    ordinalAnterior NUMBER;
    largoStr NUMBER;
    subCodigo VARCHAR2(64);
    
  begin
  
    if pCodigo = 'ZZZZZZ999999' then
      return 'ZZ';
    end if;
  
    if pOrdinal = 1 then
      posicionInicial := 1;  
    end if;
    if pOrdinal > 1 then
      ordinalAnterior := pOrdinal - 1;
      posicionInicial := INSTR(pCodigo, pDelimitador, 1, ordinalAnterior) + 1;    
    end if;
    posicionFinal := INSTR(pCodigo, pDelimitador, 1, pOrdinal) - 1;
    if posicionFinal = -1 then
      posicionFinal := LENGTH(pCodigo);
    end if;
    largoStr := posicionFinal - posicionInicial + 1;
    
    subCodigo := SUBSTR(pCodigo, posicionInicial, largoStr);
    
    return subCodigo;

  end;
  
  END SUB_CODIGO;
  
  FUNCTION DESCRIPCION_MULTIPLE (pTabla VARCHAR2,
                                 pCodigo VARCHAR2,
                                 pDelimitador VARCHAR2)
                                 RETURN VARCHAR2 AS
  vDescrDummy  VARCHAR2(128);
  vDescrCod    VARCHAR2(128);
  vDescrDscr   VARCHAR2(512);
    
  BEGIN
  vDescrCod := pCodigo || pDelimitador;
  vDescrDscr := '';
  if vDescrCod IS NOT NULL then
    for i in 1 .. regexp_count(vDescrCod,pDelimitador) loop
      case pTabla
      when 'GD_HM_ORTO_DIENTES' then  
        EXECUTE IMMEDIATE 'select DESCRIPCION  from '||pTabla||' where DIENTE = :1 ' INTO vDescrDummy USING PROC_GEN_GENERAL.SUB_CODIGO(vDescrCod,':',i);
      when 'GD_HM_ORTO_BANDAS' then  
        EXECUTE IMMEDIATE 'select DESCRIPCION  from '||pTabla||' where BANDA = :1 ' INTO vDescrDummy USING PROC_GEN_GENERAL.SUB_CODIGO(vDescrCod,':',i);
      when 'GD_HM_ORTO_ARCOS' then  
        EXECUTE IMMEDIATE 'select DESCRIPCION  from '||pTabla||' where ARCOS = :1 ' INTO vDescrDummy USING PROC_GEN_GENERAL.SUB_CODIGO(vDescrCod,':',i);
      when 'GD_HM_OD_TRATAMIENTOS' then  
        EXECUTE IMMEDIATE 'select DESCRIPCION  from '||pTabla||' where TRATAMIENTO = :1 ' INTO vDescrDummy USING PROC_GEN_GENERAL.SUB_CODIGO(vDescrCod,':',i);
      else  
        EXECUTE IMMEDIATE 'select DESCRIPCION  from '||pTabla||' where CODIGO = :1 ' INTO vDescrDummy USING PROC_GEN_GENERAL.SUB_CODIGO(vDescrCod,':',i); 
      end case;
      if i = 1 then
        vDescrDscr := vDescrDummy;
      else
       vDescrDscr := vDescrDscr || ', '|| vDescrDummy;
      end if;
    end loop;
  end if;
  return vDescrDscr;
  END DESCRIPCION_MULTIPLE;
  
END PROC_GEN_GENERAL;
/
