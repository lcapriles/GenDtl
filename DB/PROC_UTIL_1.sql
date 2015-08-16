--------------------------------------------------------
--  DDL for Package Body PROC_UTIL
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "GDCNO"."PROC_UTIL" AS
/******************************************************************************
   NAME:       PROC_UTIL
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        15-05-2014      Agustín       1. Created this package.
******************************************************************************/

  FUNCTION CONTADORES_SEDES (pCodSede VARCHAR2, pContador VARCHAR2 DEFAULT 'HISTORIA') RETURN VARCHAR2 IS
        CURSOR C_SED IS
            SELECT *
            FROM GD_GEN_SEDES
            WHERE CodSede = pCodSede
            FOR UPDATE;
        --
        R_SED C_SED%ROWTYPE;

        vContador           VARCHAR2(20);
        vValor              NUMBER(10) := 0;
        vLetra              VARCHAR2(4);
        TIPO_INVALIDO   EXCEPTION;
        SEDE_INVALIDA   EXCEPTION;
        BEGIN
            OPEN C_SED;
            FETCH C_SED INTO R_SED;
            IF C_SED%NOTFOUND THEN
                RAISE SEDE_INVALIDA;
            END IF;       
            vContador := UPPER(TRIM(pContador));
            CASE vContador
                WHEN 'HISTORIA' THEN
                    vValor := NVL(R_SED.NumHistoria,0) + 1;
                    UPDATE GD_GEN_SEDES
                    SET NumHistoria = vValor
                    WHERE CURRENT OF C_SED;
            END CASE; 
            vLetra := R_SED.LetraHistoria;
            COMMIT;  
            CLOSE C_SED;
            --RETURN(vValor);
            return vLetra||TO_CHAR(vValor,'FM00000');
            
        END;
--
-- PROCEDIMIENTO QUE CARGA LAS OPCIONES DE MENU EN UNA TABLA EN MEMORIA
--
    PROCEDURE CARGA_OPCIONES_MENU IS
        CURSOR C_OPC IS
            SELECT OPCIONID ID,
                   OPCIONIDREF PID,
                   NOMBREOPCION NAME,
                   NVL ("URL", 'f?p=&APP_ID.:1')  || 
                            CASE SUBSTR (URL, 1, 4)
                                        WHEN 'f?p=' THEN ':' || v('APP_SESSION') || URL2
                                        ELSE NULL
                            END
                      LINK,
                   LEVEL
            FROM GD_GEN_OPCIONES_MENU
            WHERE IndActiva = 'S'
            START WITH OPCIONIDREF IS NULL
            CONNECT BY PRIOR OPCIONID = OPCIONIDREF;
        
    BEGIN
        FOR R_OPC IN C_OPC LOOP
            vCantOpciones := vCantOpciones + 1;
            vMatrizOpciones(vCantOpciones).ID       := R_OPC.ID;
            vMatrizOpciones(vCantOpciones).PID     := R_OPC.PID;
            vMatrizOpciones(vCantOpciones).LINK   :=  R_OPC.LINK;
            vMatrizOpciones(vCantOpciones).LEVEL :=  R_OPC.LEVEL;            
        END LOOP;
    END;                    

  FUNCTION GENERA_RIF (pLetraID VARCHAR2, pNumeroID VARCHAR2) RETURN VARCHAR2 IS
      vValorLetra     NUMBER(1);
      vProducto       VARCHAR2(8) := '32765432';
      vSuma           NUMBER := 0;
      vMult             NUMBER := 0;
      vCedula         VARCHAR2(8);
      vResiduo        NUMBER(3) := 0;
      vResto           NUMBER(3) := 0;
      vNumeroID     VARCHAR2(200);
    BEGIN
      CASE pLetraID
          WHEN 'V' THEN
              vValorLetra := 1;
          WHEN 'E' THEN
              vValorLetra := 2;
          WHEN 'J' THEN
              vValorLetra := 3;
          WHEN 'P' THEN
              vValorLetra := 4;
          WHEN 'G' THEN
              vValorLetra := 5;
          ELSE
              vValorLetra := 1;                        
      END CASE;       
      -- Le quita los caracteres raros 
      vNumeroID := TRIM(BOTH ' ' FROM 
                            REPLACE(TRANSLATE(pNumeroID,'.-,',' '),' ','')
                            );                    
      --
      -- Cambio temporal mientras se averigua el manejo de PASAPORTES PARA EL RIF 
      IF pLetraID IN( 'P','J','G') THEN
          RETURN (pLetraID||'-'||SUBSTR(vNumeroID,1,10));
      END IF;
      -- Usa máximo 8 caracteres 
      vCedula := SUBSTR(vNumeroID,1,8);
      -- Lo rellena de ceros 
      vCedula := LPAD(vCedula,8,'0');
      FOR I IN 1..8 LOOP
          vMult := SUBSTR(vCedula,I,1) * SUBSTR(vProducto,I,1);
          vSuma     := vSuma + vMult;
      END LOOP;
      vSuma := vSuma + vValorLetra * 4;
      vResiduo := MOD(vSuma,11);
      vResto   := 11 - vResiduo;
      IF vResto >=10 THEN
          vResto := 0;
      END IF;
      RETURN(pLetraID||'-'||vCedula||'-'||TO_CHAR(vResto,'FM0'));   
    END;
    
  FUNCTION VERIFICA_SEGURIDAD(pPagina VARCHAR2,
                              pUserID VARCHAR2,
                              pSecurityGroupID NUMBER) RETURN BOOLEAN IS
                              
  Permiso1 NUMBER := 0;
  Permiso2 NUMBER := 0;
  
  BEGIN
  
    --RETURN TRUE;--Anulada la seguridad!!!
    
    if (pPagina = 0) or (pPagina = 1) then
      return TRUE;
    end if;
    
    select count(*) into Permiso1
    from GD_GEN_SEGURIDAD_APP
    where PAGINA in (pPagina, '*ALL')
    and PERFIL in (
      select G.GROUP_NAME
      from  APEX_040200.WWV_FLOW_FND_USER_GROUPS G, 
            APEX_040200.WWV_FLOW_FND_USER U, 
            APEX_040200.WWV_FLOW_FND_GROUP_USERS GU
      where U.USER_ID = GU.USER_ID
      and GU.GROUP_ID = G.ID
      and U.SECURITY_GROUP_ID = pSecurityGroupID
      and U.USER_NAME = pUserID);
    
    if (Permiso1 = 0) then
      select count(*) into Permiso2
      from GD_GEN_SEGURIDAD_APP
      where PERFIL = pUserID
      and PAGINA in (pPagina, '*ALL');
    end if;
    
    if (Permiso1 > 0) or (Permiso2 > 0) then
      return TRUE;
    else
      return FALSE;
    end if;
    
  END VERIFICA_SEGURIDAD;      
                
END PROC_UTIL;
