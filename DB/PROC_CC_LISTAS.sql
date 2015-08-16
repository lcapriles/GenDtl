--------------------------------------------------------
--  DDL for Package PROC_CC_LISTAS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "GDCNO"."PROC_CC_LISTAS" AS
/******************************************************************************
   NAME:       PROC_CC_LISTAS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        27-12-2013      Agustín       1. Created this package.
******************************************************************************/
    -- Cursor 
    CURSOR C_LIS IS
        SELECT *
        FROM GD_CC_DEF_LISTAS 
        WHERE (FecHoraProxProceso <= SYSDATE OR FecHoraProxProceso IS NULL)
            AND  TRUNC(SYSDATE) BETWEEN TRUNC(NVL(FecDesde,TO_DATE('01/01/1980','DD/MM/YYYY'))) AND TRUNC(NVL(FecHasta,TO_DATE('31/12/2300','DD/MM/YYYY'))) 
            AND StsLista = 'ACT'
        ORDER BY ListaID;            
    --        
    -- Definicion del Cursor que tiene los datos que se obtienen del cursor Dinámico generado por REFRESCA_LISTAS- SOLO para definicion.
    --
    CURSOR C_PRB IS
        SELECT PER.PERSONAID PER_PERSONAID, 
                    PER.NOMBPERSONA PER_NOMBPERSONA, 
                    PER.APELLIDOSPERSONA PER_APELLIDOSPERSONA, 
                    PER.EMAILPERSONA PER_EMAILPERSONA, 
                    PER.NUMHISTORIA PER_NUMHISTORIA, 
                    PER.FECNACIMIENTO PER_FECNACIMIENTO, 
                    PER.GENERO PER_GENERO, 
                    PER.CODSEDE PER_CODSEDE, 
                    PER.TELHABITACION PER_TELHABITACION, 
                    PER.TELCELULAR PER_TELCELULAR, 
                    PER.TELTRABAJO PER_TELTRABAJO, 
                    PER.TELOTROS PER_TELOTROS, 
                    PER.MSGRECEPCION PER_MSGRECEPCION, 
                    PER.MSGFACTURACION PER_MSGFACTURACION, 
                    PER.LETRACEDULA PER_LETRACEDULA, 
                    PER.NUMCEDULA PER_NUMCEDULA, 
                    PER.PERSONACONTACTO PER_PERSONACONTACTO, 
                    PER.NACIONALIDAD PER_NACIONALIDAD, 
                    PER.PAISORIGEN PER_PAISORIGEN, 
                    PER.TELCONTACTO PER_TELCONTACTO, 
                    PER.ESTADOCIVIL PER_ESTADOCIVIL, 
                    PER.DIRHABITACION PER_DIRHABITACION, 
                    PER.REGIONHABITACION PER_REGIONHABITACION, 
                    PER.ENTIDADHABITACION PER_ENTIDADHABITACION, 
                    PER.MUNICIPIOHABITACION PER_MUNICIPIOHABITACION, 
                    PER.OBSERVACIONES PER_OBSERVACIONES, 
                    PER.NOTAS PER_NOTAS, 
                    PER.FECINGRESO PER_FECINGRESO,
                    HIS.PERSONAID HIS_PERSONAID, 
                    HIS.CODSEDE HIS_CODSEDE, 
                    HIS.CODSERVICIO HIS_CODSERVICIO, 
                    HIS.NUMHISTORIA HIS_NUMHISTORIA,                     
                    HIS.NUMHISTORIAANTERIOR HIS_NUMHISTORIAANTERIOR, 
                    HIS.FECULTVISITA HIS_FECULTVISITA, 
                    HIS.FECPROXCITA HIS_FECPROXCITA,
                    HIS.CODESPECIALIDAD HIS_CODESPECIALIDAD,
                    HIS.CODESPECIALISTA HIS_CODESPECIALISTA
        FROM GD_GEN_PERSONAS PER, 
                  GD_GEN_HISTORIAS_PERSONA HIS
        WHERE PER.PersonaID = HIS.PersonaID;

    --
    R_DAT           C_PRB%ROWTYPE;     
    --                 
    vTextoQuery VARCHAR2(1000);
    --
    PROCEDURE REFRESCA_LISTAS;
    PROCEDURE GENERA_LLAMADAS (R_LIS C_LIS%ROWTYPE);
    PROCEDURE GENERA_TEXTO (R_LIS C_LIS%ROWTYPE) ;
    --
    PROCEDURE DISTRIBUYE_LLAMADAS;
    --

END PROC_CC_LISTAS;
