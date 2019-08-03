    VAR CL SYS CLVAR 2
    IF VAR CL NE ""
            VAR CL SYS ENVAR &'VAR CL'
            NOTIFY &'VAR CL'
            GOTO END
    ENDIF
LABEL LOOP
        VAR ENVAR ""
        INPUT "SYMBOL: " ENVAR
        IF VAR ENVAR NE ""
        VAR ENVAR SYS ENVAR &'VAR ENVAR'
        NOTIFY &'VAR ENVAR'
            GOTO LOOP
        ENDIF
LABEL END
