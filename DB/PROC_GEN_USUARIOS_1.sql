--------------------------------------------------------
--  DDL for Package Body PROC_GEN_USUARIOS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "GDCNO"."PROC_GEN_USUARIOS" AS
/******************************************************************************
   NAME:       PROC_GEN_USUARIOS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        24-04-2014      Agustín       1. Created this package.
******************************************************************************/
-- 
-- Funcion que valida la existencia del Usuario y Retorna el codigo de la sede asociada al usuario
--
    FUNCTION VALIDA_USUARIO (pCODCOMPANIA out GD_GEN_USUARIOS.CODCOMPANIA%TYPE,
                             pCODSEDE out GD_GEN_USUARIOS.CODSEDE%TYPE) 
                             RETURN VARCHAR2 IS
    
    CURSOR C_USU IS
        SELECT *
        FROM GD_GEN_USUARIOS
        WHERE LoginUsuario = V('APP_USER');
        --
        R_USU C_USU%ROWTYPE; 
        
    BEGIN
        OPEN C_USU;
        FETCH C_USU INTO R_USU;
        IF C_USU%NOTFOUND THEN
            CLOSE C_USU;
            pCODCOMPANIA := NULL;
            pCODSEDE := NULL;
            RETURN 'NO';
        ELSE
            CLOSE C_USU;
            pCODCOMPANIA := R_USU.CODCOMPANIA;
            pCODSEDE := R_USU.CODSEDE;
            RETURN 'SI';
        END IF;       
    END;    
    
END PROC_GEN_USUARIOS;
