
        VAR sDefault ""
        VAR sFilter "*.txt"
        VAR sChoice1 "E. EDIT"
        VAR sChoice2 "S. SHELL"
        VAR sChoice3 "L. LIST"
        VAR sChoice4 "D. SET DIR FILTER"
        VAR sChoice5 "M. MS TO SCREEN"
        VAR sChoice6 "F. MS TO TEMP FILE"
        VAR sChoice7 "Q. QUIT"
        VAR nMaxChoice 7
        VAR nTemp 1
        VAR sChoiceList "ESLDMFQ"
LABEL LOOP
        VAR cOpt ""
        VAR sFile ""
        VAR sTmp ""
        CLS
        SHELL "DIR &'VAR sFilter'/W"
        NOTIFY
        REM NOTIFY "---------------------- MENU ----------------------"
LABEL MENUDISPLAY
        VAR sX ""
        VAR sX VAR sChoice&'VAR nTemp'
        VAR nInc 11
        VAR nIncBy VAR nTemp
        VAR sRETURN "HERE"
        GOTO INCREMENT_SUB
LABEL HERE
        SHOWXY &'VAR nX' 31  "&'VAR sX'"
        INCVAR nTemp
        IF VAR nTemp LE VAR nMaxChoice
            GOTO MENUDISPLAY
        ENDIF
        VAR nInc 11
        VAR nIncBy VAR nMaxChoice
        VAR sRETURN "NEXT"
        GOTO INCREMENT_SUB
LABEL NEXT
        INCVAR nInc
LABEL GET
        SHOWXY &'VAR nInc' 31 "Choice: "
        GOTOXY &'VAR nInc' 38
        VAR cOpt ""
        GETCHAR cOpt
        IF VAR cOpt GE "a"
            GOTO OK_a
        ENDIF
        GOTO ISUPPER
LABEL OK_a
        IF VAR cOpt LE "z"
            GOTO OK_z
        ENDIF
        GOTO ISUPPER
LABEL OK_z
        VAR nDec VAR cOpt
        VAR nDecBy 32
        VAR sRETURN "ISUPPER"
        GOTO DECREMENT_SUB
LABEL ISUPPER
        IF VAR cOpt NI "&'VAR sChoiceList'"
                GOTO GET
        ENDIF
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
        VAR sTmp ""
        INPUT "DIRECTORY sFilter: " sTmp
        IF VAR sTmp NE ""
                VAR sFilter VAR sTmp
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

LABEL OPTQ
        CLS
        HALT RETURNING TO THE OUTSIDE

LABEL INCREMENT_SUB
        IF VAR nIncBy EQ 0
            GOTO NOMOREINCR
        ENDIF
        INCVAR nInc
        DECVAR nIncBy
        GOTO INCREMENT_SUB
LABEL NOMOREINCR
        GOTO &'VAR sRETURN'

LABEL DECREMENT_SUB
        IF VAR nDecBy EQ 0
            GOTO NOMOREINCR
        ENDIF
        INCVAR nDec
        DECVAR nDecBy
        GOTO DECREMENT_SUB
LABEL NOMOREINCR
        GOTO &'VAR sRETURN'

