        VAR sDir SYS ENVAR EDTCL
        IF VAR sDir NE ""
                CHDIR &'VAR sDir'
        ENDIF
        VAR sDefault ""
        VAR sFilter "*.*"
LABEL LOOP
        VAR cOpt ""
        VAR sFile ""
        VAR sTmp ""
        VAR Stemp ""
        CLS
        SHELL "DIR &'VAR sFilter'/W"
        NOTIFY
        NOTIFY "---------------------- MENU ----------------------"
        NOTIFY "           E. EDIT           D. SET DEFAULT DIR"
        NOTIFY "           S. SHELL          C. CONSISTENT CHANGES"
        NOTIFY "           L. LIST           M. MS TO SCREEN"
        NOTIFY "           T. HOMEWORK.LST   Q. QUIT"
        NOTIFY "           1. SINGLE COMMAND
        NOTIFY
        NOTIFY "OPTION:"
LABEL GET
        VAR cOpt ""
        GETCHAR cOpt
        IF VAR cOpt NI "eEsSlLdDMmQqTtcC1"
                BEEP 440 1
                GOTO GET
        ENDIF
        NOTIFY &'VAR cOpt'
        GOTO OPT&'VAR cOpt'


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
        INVOKE "I:\SIL\DTS\PROGRAMS\ED.EXE" "&'VAR sFile'"
        GOTO LOOP

LABEL OPTS
        INVOKE "C:\DOS\COMMAND.COM" ""
        IF VAR sDir NE ""
                CHDIR &'VAR sDir'
        ENDIF
        GOTO LOOP

LABEL OPTC
        VAR sTable ""
        VAR sInput ""
        VAR sOutput ""
        VAR sTmp ""
        INPUT "Change table [&'VAR sDefault']: " sTable
        IF VAR sTable NE ""
            GOTO GETIN
        ENDIF
        IF VAR sDefault NE ""
            VAR sTable VAR sDefault
            GOTO GETIN
        ENDIF
        GOTO LOOP
LABEL GETIN
        NOTIFY "Debug script (Y/N)? "
        GETCHAR sTmp
        IF VAR sTmp IN "Yy"
            VAR sTable "&'VAR sTable'/d"
        ENDIF
        INPUT "Input file: " sInput
        IF VAR sInput EQ ""
                GOTO LOOP
        ENDIF
        INPUT "Output file: " sOutput
        IF VAR sOutput EQ ""
                GOTO LOOP
        ENDIF
        VAR sCommand "-t &'VAR sTable' -o &'VAR sOutput' &'VAR sInput'"
        INVOKE "I:\SIL\DTS\PROGRAMS\CC.EXE" "&'VAR sCommand'"
        NOTIFY "MS the output file(Y/N)? "
        GETCHAR sTmp
        IF VAR sTmp IN "Yy"
            INVOKE "I:\SIL\DTS\PROGRAMS\MS.EXE" "-o SCREEN:  &'VAR sOutput'"
        ENDIF
        NOTIFY "LIST the output file(Y/N)? "
        GETCHAR sTmp
        IF VAR sTmp IN "Yy"
            INVOKE "c:\tools\LIST.COM" "&'VAR sOutput'"
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

LABEL OPTD
        INPUT "DIRECTORY: " sDir
        IF VAR sDir NE ""
                CHDIR "&'VAR sDir'"
        ENDIF
        GOTO LOOP

LABEL OPTM
        INPUT "FILE TO PROCESS [&'VAR sDefault']: " sFile
        IF VAR sFile EQ "."
                GOTO LOOP
        ENDIF
        IF VAR sFile EQ ""
                VAR sFile "&'VAR sDefault'"
        ELSE
                VAR sDefault "&'VAR sFile'"
        ENDIF
        INVOKE "I:\SIL\DTS\PROGRAMS\MS.EXE" "-o SCREEN:  &'VAR sFile'"
        GOTO LOOP
LABEL OPTT
        SHELL "EDIT HOMEWORK.LST"
        GOTO LOOP

LABEL OPT1
        INPUT "Command: " sTemp
        IF VAR sTemp NE ""
                SHELL "&'VAR sTemp'"
                CHDIR "&'VAR sDir'"
                pause
        ENDIF
        GOTO LOOP

LABEL OPTQ
        CLS
        HALT RETURNING TO THE OUTSIDE
