--------------------------------------------------------
--  DDL for Package Body PROC_GEN_GENERAL
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "GDCNO"."PROC_GEN_GENERAL" AS
/******************************************************************************
   NAME:       PROC_PRESUPUESTO
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        7/25/2013      Agustín Botana       1. Created this package.
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
            IF C_HIS%NOTFOUND THEN -- No existe esta relacion del Paciente con la Clínica, la crea
                INSERT INTO GD_GEN_HISTORIAS_PERSONA
                    (PERSONAID, CODSEDE, CODSERVICIO, NUMHISTORIA, NUMHISTORIAANTERIOR, FECULTVISITA, FECPROXCITA, CODESPECIALIDAD, CODESPECIALISTA)
                VALUES
                    (pPERSONAID, pCODSEDE, pCODSERVICIO, NULL, NULL, NULL, NULL, pCODESPECIALIDAD, pCODESPECIALISTA);
            ELSE -- Existe la relación; La actualiza 
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
        IF C_HIS%NOTFOUND THEN  -- No exite la relación. La crea 
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
    
  --Procedimiento para actualizar la última/próxima visita...
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
  

  --¿Función para devolver un subcódigo a partir de un delimitador..  
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
  
END PROC_GEN_GENERAL;
