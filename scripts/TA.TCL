        VAR sDir SYS ENVAR TATCL
        IF VAR sDir NE ""
                CHDIR &'VAR sDir'
        ENDIF
        VAR sDefault ""
        VAR sInput ""
        VAR sOutput ""
        VAR sTmp ""
        VAR sCmd ""
LABEL LOOP
        VAR cOpt ""
        VAR sFile ""
        VAR sTmp ""
        VAR Stemp ""
        CLS
        SHELL "DIR *.* /W /on"
        NOTIFY
        NOTIFY "---------------------- MENU ----------------------"
        NOTIFY " A. ANSM    B. ANSQ     D. DICR     I. IC   S. SRT     W. WDL      Y. WS
        NOTIFY
        NOTIFY " C. CWD     E. EDIT     J. JUMP     L. LIST !. SHELL   Q. QUIT     1. SINGLE COMMAND
        NOTIFY
        NOTIFY "OPTION:"
LABEL GET
        VAR cOpt ""
        GETCHAR cOpt
        IF VAR cOpt NI "aAbBdDiIsSwWyYcCeEjJlL!qQ1"
                BEEP 440 1
                GOTO GET
        ENDIF
        NOTIFY &'VAR cOpt'
        GOTO OPT&'VAR cOpt'

LABEL OPTA
    INVOKE "I:\SIL\TA\ANSM.EXE" ""
    GOTO LOOP

LABEL OPTB
    INVOKE "I:\SIL\TA\ANSQ.EXE" ""
    GOTO LOOP

LABEL OPTD
    INVOKE "I:\SIL\TA\DICR.EXE" ""
    GOTO LOOP

LABEL OPTI
    INVOKE "I:\SIL\TA\IC.EXE" ""
    GOTO LOOP

LABEL OPTS
    INVOKE "I:\SIL\TA\SRT.EXE" ""
    GOTO LOOP

LABEL OPTW
    INVOKE "I:\SIL\TA\WDL.EXE" ""
    GOTO LOOP

LABEL OPTY
    INVOKE "I:\SIL\TA\WS.EXE" ""
    GOTO LOOP

LABEL OPTC
        INPUT "DIRECTORY: " sDir
        IF VAR sDir NE ""
                CHDIR "&'VAR sDir'"
        ENDIF
        GOTO LOOP

LABEL OPTE
        INPUT "FILE TO EDIT [&'VAR sDefault']: " sFile
        IF VAR sFile EQ "."
                GOTO LOOP
        ENDIF
        IF VAR sFile EQ ""
                VAR sFile "&'VAR sDefault'"
        ELSE
                VAR sDefault "&'VAR sFile'"
        ENDIF
        INVOKE "I:\TPE\TPE.EXE" "&'VAR sFile'"
        GOTO LOOP

LABEL OPTJ
        INPUT "DIRECTORY: " sDir
        IF VAR sDir NE ""
                INVOKE "c:\tools\JUMP.COM" "&'VAR sDir'"
        ENDIF
        GOTO LOOP

LABEL OPTL
        INPUT "FILE TO LIST [&'VAR sDefault']: " sFile
        IF VAR sFile EQ "."
                GOTO LOOP
        ENDIF
        IF VAR sFile EQ ""
                VAR sFile "&'VAR sDefault'"
        ELSE
                VAR sDefault "&'VAR sFile'"
        ENDIF
        INVOKE "c:\tools\LIST.COM" "&'VAR sFile'"
        GOTO LOOP


LABEL OPT!
        INVOKE "C:\DOS\COMMAND.COM" ""
        IF VAR sDir NE ""
                REM CHDIR &'VAR sDir'
        ENDIF
        GOTO LOOP

LABEL OPTQ
        CLS
        HALT RETURNING TO THE OUTSIDE

LABEL OPT1
        INPUT "Command [&'VAR sCmd']: " sTemp
        IF VAR sTemp NE ""
            VAR sCmd VAR sTemp
            GOTO OPT1A
        ENDIF
        IF VAR sCmd NE ""
            GOTO OPT1A
        ENDIF
        GOTO OPT1B
LABEL OPT1A
        SHELL "&'VAR sCmd'"
        pause
LABEL OPT1B
        GOTO LOOP

