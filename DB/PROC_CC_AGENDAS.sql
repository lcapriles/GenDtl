--------------------------------------------------------
--  DDL for Package PROC_CC_AGENDAS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "GDCNO"."PROC_CC_AGENDAS" AS 

    --Procedimiento para crear/borrar cita...
    PROCEDURE AGENDAR_CITA (pCITA_ID GD_CC_CITAS.CITAID%TYPE,
                            pCITA_CODSEDE GD_CC_CITAS.CODSEDE%TYPE,
                            pCITA_CODSERVICIO GD_CC_CITAS.CODSERVICIO%TYPE,
                            pCITA_CODESPECIALIDAD GD_CC_CITAS.CODESPECIALIDAD%TYPE,
                            pCITA_CODESPECIALISTA GD_CC_CITAS.CODESPECIALISTA%TYPE,
                            pCITA_PERSONAID GD_CC_CITAS.PERSONAID%TYPE,
                            pCITA_HORAINICIO VARCHAR2,
                            pCITA_DURACION GD_CC_CITAS.DURACION%TYPE,
                            pCITA_NUMCITA GD_CC_CITAS.NUMCITA%TYPE
                            );
                            
    --Procedimiento para mover una cita...
    PROCEDURE AGENDAR_CITA_MOV (pCITA_NUMCITA GD_CC_CITAS_MOV.NUMCITA%TYPE, 
                                pCITA_NUEVAHI VARCHAR2,
                                pCITA_PERSONAID GD_CC_CITAS_MOV.PERSONAID%TYPE,
                                pCITA_CODSEDE GD_CC_CITAS_MOV.CODSEDE%TYPE,
                                pCITA_CODSERVICIO GD_CC_CITAS_MOV.CODSERVICIO%TYPE,
                                pCITA_CODESPECIALIDAD GD_CC_CITAS_MOV.CODESPECIALIDAD%TYPE,
                                pCITA_CODESPECIALISTA GD_CC_CITAS_MOV.CODESPECIALISTA%TYPE);
                                
    --Procedimiento para cambiar estado de una cita...
    PROCEDURE AGENDAR_CITA_STS (pCITA_NUMCITA GD_CC_CITAS_MOV.NUMCITA%TYPE, 
                                pCITA_NUEVAHI VARCHAR2);
                                
    PROCEDURE GENERAR_CALENDARIO_GLOBAL;
    
    PROCEDURE AGENDAR_PRUEBA(P1 varchar2, P2 date);
    PROCEDURE AGENDAR_PRUEBA(P1 VARCHAR2, P2 VARCHAR2);
  
END PROC_CC_AGENDAS;
