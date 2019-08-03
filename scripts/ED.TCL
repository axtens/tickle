        VAR sDir SYS ENVAR EDTCL
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
        SHELL "DIR *.* /W"
        NOTIFY
        NOTIFY "---------------------- MENU ----------------------"
        NOTIFY " C. CONSISTENT CHANGES  D. SET DEFAULT DIR"
        NOTIFY " E. EDIT FILE           J. JUMP TO DIR"
        NOTIFY " L. LIST"
        NOTIFY " M. MS TO SCREEN        N. NEW .CCT"
        NOTIFY " S. SHELL TO DOS        T. HOMEWORK.LST"
        NOTIFY " Q. QUIT                1. SINGLE COMMAND"
        NOTIFY
        NOTIFY "OPTION:"
LABEL GET
        VAR cOpt ""
        GETCHAR cOpt
        IF VAR cOpt NI "eEsSlLdDMmQqTtcCnN1Jj"
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
                REM CHDIR &'VAR sDir'
        ENDIF
        GOTO LOOP

LABEL OPTC
        VAR sTable ""
        INPUT "Change table [&'VAR sDefault']: " sTable
        IF VAR sTable NE ""
            VAR sDefault VAR sTable
            GOTO GETIN
        ENDIF
        IF VAR sDefault NE ""
            VAR sTable VAR sDefault
            VAR sDefault VAR sTable
            GOTO GETIN
        ENDIF
        GOTO LOOP
LABEL GETIN
        NOTIFY "Debug script (Y/N)? "
        GETCHAR sTmp
        IF VAR sTmp IN "Yy"
            VAR sTable "&'VAR sTable'/d"
        ENDIF
        INPUT "Input file[&'VAR sInput']: " sTemp
        IF VAR sTemp NE ""
                VAR sInput VAR sTemp
                GOTO NOTINblank
        ENDIF
        IF VAR sInput EQ ""
                GOTO LOOP
        ENDIF
LABEL NOTINBLANK
        INPUT "Output file [&'VAR sOutput']: " sTemp
        IF VAR sTemp NE ""
                VAR sOutput VAR sTemp
                GOTO !outblank
        ENDIF
        IF VAR sOutput EQ ""
                GOTO LOOP
        ENDIF
LABEL !OUTBLANK
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

LABEL OPTN
        VAR sId ""
        VAR sDate ""
        VAR sPurpose ""
        CLS
        NOTIFY "Create .CCT file"
        NOTIFY
        INPUT "Name of file (without extension): " sTemp
        IF VAR sTemp EQ ""
            GOTO LOOP
        ENDIF
        CREATE "&'VAR sTemp'.TMP"
        INPUT "Identification: " sId
        INPUT "Purpose: " sPurpose
        VAR sDate SYS ENVAR DATE
        IF VAR sDate EQ ""
            INPUT "Date: " sDate
        ENDIF
        APPEND "&'VAR sTemp'.tmp" "c &'VAR sTemp'.CCT - &'VAR sId'"
        APPEND  "&'VAR sTemp'.tmp" "c Author: Bruce M. Axtens."
        APPEND "&'VAR sTemp'.tmp" "c Created: &'VAR sDate'"
        APPEND "&'VAR sTemp'.tmp" "c Purpose: &'VAR sPurpose'"
        APPEND "&'VAR sTemp'.tmp" "c"
        APPEND "&'VAR sTemp'.tmp" '.i i:\sil\data\breaks.txt'
        INVOKE "c:\tools\INCLUDE.EXE" ".i &'VAR sTemp'.tmp &'VAR sTemp'.cct"
        DELETE "&'VAR sTemp'.tmp"
        VAR sDefault "&'VAR sTemp'.CCT"
        GOTO LOOP

LABEL OPTJ
        INPUT "DIRECTORY: " sDir
        IF VAR sDir NE ""
                INVOKE "c:\tools\JUMP.COM" "&'VAR sDir'"
        ENDIF
        GOTO LOOP


LABEL OPTQ
        CLS
        HALT RETURNING TO THE OUTSIDE
