        VAR sDate SYS ENVAR DATE
        VAR VERIFYSET "OFF"
        VAR sDir SYS ENVAR DTSTCL
        IF VAR sDir NE ""
                CHDIR &'VAR sDir'
        ENDIF
        VAR A ""
        VAR B ""
        VAR C ""
        VAR D ""
        VAR E ""
        VAR sDefault ""
        VAR sInput ""
        VAR sOutput ""
        VAR sTmp ""
        VAR sCmd ""
        VAR sFont ""
        VAR sKeyFile ""
        VAR sFilter "*.*"
LABEL LOOP
        VAR cOpt ""
        VAR sFile ""
        VAR sTmp ""
        VAR Stemp ""
        CLS
        SHELL "DIR &'VAR sFilter' /W /on"
        NOTIFY
        NOTIFY "---------------------- MENU ----------------------"
        NOTIFY "A. ASCC     C. CC       D. DESIGN   E. ED       F. FONTCO   L. LETTER
        notify "M. MS       P. PRIDEF   R. PRINTF   S. SHAPES   K. KEYDEF
        NOTIFY
        NOTIFY "T. TPE      J. JUMP     >. MS->SCRN N. NEW CCT  !. SHELL    1. ONE CMD
        notify "W. word 5   X. DIREX    V. VERIFY   Q. QUIT     @. SET FONT #. COMPILE
        NOTIFY "%. FILTER   \. LIST VARIABLES       a. dir a:   G. shapes_f ^. makeprd
        notify "(. make var ). eval var
        NOTIFY
        NOTIFY "OPTION:"
LABEL GET
        VAR cOpt ""
        GETCHAR cOpt
        IF VAR cOpt NI "ACDEFLMPRSKtTjJ>nN!1qQXx6vV@#\%aGgW^()"
                BEEP 440 10
                GOTO GET
        ENDIF
        IF VAR cOPT EQ "a"
            NOTIFY "DIRECTORY OF A:"
            SHELL "DIR A: /W"
            pause
            GOTO LOOP
        ENDIF
        REM NOTIFY &'VAR cOpt'
        GOTO OPT&'VAR cOpt'

LABEL OPTA
    NOTIFY "ASCC"
    INPUT "Argument to ASCC: " sTemp
    IF VAR sTemp EQ ""
        GOTO LOOP
    ENDIF

    SHELL "C:\SIL\ASCC.COM &'VAR sTemp'"
    PAUSE
    GOTO LOOP

LABEL OPTC
    NOTIFY "CC"
    INVOKE "C:\SIL\CC.EXE" ""
    GOTO LOOP

LABEL OPTD
    NOTIFY "DESIGN"
    INVOKE "C:\SIL\DESIGN.EXE" ""
    GOTO LOOP

LABEL OPTE
    NOTIFY "ED"
    INVOKE "C:\SIL\ED.EXE" ""
    GOTO LOOP

LABEL OPTF
    NOTIFY "FONTCO"
    INVOKE "C:\SIL\FONTCO.EXE" ""
    GOTO LOOP

LABEL OPTL
    NOTIFY "LETTER"
    INVOKE "C:\SIL\LETTER.EXE" ""
    GOTO LOOP

LABEL OPTM
    NOTIFY "MS"
    INVOKE "C:\SIL\MS.EXE" ""
    GOTO LOOP

LABEL OPTP
    NOTIFY "PRIDEF"
    INVOKE "C:\SIL\PRIDEF.EXE" ""
    GOTO LOOP

LABEL OPTR
    NOTIFY "PRINTF"
    INVOKE "C:\SIL\PRINTF.EXE" ""
    GOTO LOOP

LABEL OPTS
    NOTIFY "SHAPES"
    INVOKE "C:\SIL\SHAPES.EXE" ""
    GOTO LOOP


LABEL OPTT
        NOTIFY "TPE"
        INPUT "FILE TO EDIT [&'VAR sDefault']: " sFile
        IF VAR sFile EQ "."
                GOTO LOOP
        ENDIF
        IF VAR sFile EQ ""
                VAR sFile "&'VAR sDefault'"
        ELSE
                VAR sDefault "&'VAR sFile'"
        ENDIF
        CREATE "I:\SIL\DELETEME.BAT"
        IF VAR sKeyFile NE ""
            APPEND "I:\SIL\DELETEME.BAT" "MARK"
            APPEND "I:\SIL\DELETEME.BAT" "KEYSWAP &'VAR sKeyFile'
        ENDIF
        APPEND "I:\SIL\DELETEME.BAT" "C:\TPE\TPE.EXE &'VAR sFile'"
        IF VAR sKeyFile NE ""
            APPEND "I:\SIL\DELETEME.BAT" "RELEASE"
        ENDIF
        SHELL "I:\SIL\DELETEME.BAT"
        DELETE "I:\SIL\DELETEME.BAT"
        IF VAR VERIFYSET EQ "ON"
            pause
        endif
        GOTO LOOP

LABEL OPTW
        NOTIFY "word"
        INPUT "FILE TO EDIT [&'VAR sDefault']: " sFile
        IF VAR sFile EQ "."
                GOTO LOOP
        ENDIF
        IF VAR sFile EQ ""
                VAR sFile "&'VAR sDefault'"
        ELSE
                VAR sDefault "&'VAR sFile'"
        ENDIF
        INVOKE "I:\WORD5\WORD.EXE"  "&'VAR sFile'"
        IF VAR VERIFYSET EQ "ON"
            pause
        endif
        GOTO LOOP

LABEL OPT!
        NOTIFY "COMMAND"
        INVOKE "C:\DOS\COMMAND.COM" ""
        IF VAR sDir NE ""
                REM CHDIR &'VAR sDir'
        ENDIF
        GOTO LOOP

LABEL OPT>
        NOTIFY "MS TO SCREEN"
        INPUT "FILE TO PROCESS [&'VAR sDefault']: " sFile
        IF VAR sFile EQ "."
                GOTO LOOP
        ENDIF
        IF VAR sFile EQ ""
                VAR sFile "&'VAR sDefault'"
        ELSE
                VAR sDefault "&'VAR sFile'"
        ENDIF
        INVOKE "C:\SIL\MS.EXE" "-o SCREEN:  &'VAR sFile'"
        IF VAR VERIFYSET EQ "ON"
            pause
        endif
        GOTO LOOP

LABEL OPT1
        NOTIFY "ONE COMMAND"
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
        NOTIFY "NEWTABLE"
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
        APPEND    "&'VAR sTemp'.tmp" "c Author: Bruce M. Axtens."
        APPEND "&'VAR sTemp'.tmp" "c Created: &'VAR sDate'"
        APPEND "&'VAR sTemp'.tmp" "c Purpose: &'VAR sPurpose'"
        APPEND "&'VAR sTemp'.tmp" "c Modified: "
        APPEND "&'VAR sTemp'.tmp" "c"
        APPEND "&'VAR sTemp'.tmp" "c Notes: 'd' precedes name of define"
        APPEND "&'VAR sTemp'.tmp" "c        'l' precedes name of set (logical)"
        APPEND "&'VAR sTemp'.tmp" "c        'g' precedes name of group"
        APPEND "&'VAR sTemp'.tmp" "c        's' precedes name of store"
        APPEND "&'VAR sTemp'.tmp" "c"
        APPEND "&'VAR sTemp'.tmp" '.i i:\sil\data\brk_doc.cci'
        INVOKE "i:\tools\INCLUDE.EXE" ".i &'VAR sTemp'.tmp &'VAR sTemp'.cct"
        DELETE "&'VAR sTemp'.tmp"
        VAR sDefault "&'VAR sTemp'.CCT"
        IF VAR VERIFYSET EQ "ON"
            pause
        endif
        GOTO LOOP

LABEL OPTJ
        NOTIFY "JUMP"
        INPUT "DIRECTORY: " sDir
        IF VAR sDir NE ""
                INVOKE "i:\tools\JUMP.COM" "&'VAR sDir'"
        ENDIF
        IF VAR VERIFYSET EQ "ON"
            pause
        endif
        GOTO LOOP

LABEL OPTX
        NOTIFY "DIREX"
        INVOKE "i:\tools\DIREX.COM" ""
        GOTO LOOP

LABEL OPT6
        NOTIFY "MS TO 630"
        IF VAR sFont EQ ""
            PAUSE "sFont must be defined. See option @"
            GOTO LOOP
        ENDIF
        INPUT "Input file [&'VAR sInput']: " sInput
        INVOKE "C:\SIL\MS.EXE" "-f &'VAR sFont' -o i:\sil\dts\printers\630: &'VAR sInput'"
        IF VAR VERIFYSET EQ "ON"
            pause
        endif
        goto loop

LABEL OPT@
        NOTIFY "SET FONT"
        INPUT "Font [&'VAR sFont']: " sFont
        EXISTS &'VAR sFont'
        IF SYS IO NE 0
            NOTIFY '&'VAR sFont' does not exist."
            VAR sFont ""
            PAUSE
        ENDIF
        GOTO LOOP

LABEL OPTV
        NOTIFY "VERIFY"
        IF VAR VERIFYSET EQ "ON"
            VERIFY OFF
            VAR VERIFYSET "OFF"
        ELSE
            VAR VERIFYSET "ON"
            VERIFY ON
        ENDIF
        GOTO LOOP

LABEL OPT#
        NOTIFY "COMPILE .FNA FILE"
        INPUT ".FNA FILE: " sTemp
        IF VAR sTemp EQ ""
            GOTO LOOP
        ENDIF
        VAR sInput "&'VAR sTemp'.FNA"
        VAR sFont  "&'VAR sTemp'.FNT"
        INVOKE "C:\SIL\FONTCO.EXE" "-o &'VAR sFont' &'VAR sInput'"
        IF VAR VERIFYSET EQ "ON"
            pause
        endif
        GOTO LOOP

LABEL OPT^
        VAR V1 ""
        VAR V2 ""
        NOTIFY "MAKEPRD OF FILE"
        INPUT ".TXT FILE: " sTemP
        IF VAR sTemp EQ ""
            GOTO LOOP
        ENDIF
        INPUT ".PRD FILE: " sTmp
        IF VAR STMP EQ ""
            GOTO LOOP
        ENDIF
        VAR V1 "&'VAR sTemp'.TXT"
        VAR V2 "&'VAR sTmp'.PRD"
        INVOKE "I:\WORD5\MAKEPRD.EXE" "/P &'VAR V2' &'VAR V1'"
        PAUSE
        GOTO LOOP

LABEL OPTG
        NOTIFY "Shapes of .shp file for graphical to p351 printer"
        INPUT ".shp FILE: " sTemp
        IF VAR sTemp EQ ""
            GOTO LOOP
        ENDIF
        VAR sInput "&'VAR sTemp'.shp"
        VAR sTemp "&'VAR sTemp'.fna"
        INVOKE "C:\SIL\SHAPES.EXE" "-n 1 -p f -o &'VAR sTemp' &'VAR sInput'"
        IF VAR VERIFYSET EQ "ON"
            pause
        endif
        GOTO LOOP

LABEL OPTK
        NOTIFY "KEYDEF"
        INPUT "Key file: " sKeyFile
        IF VAR sKeyFile EQ ""
            GOTO LOOP
        ENDIF
        EXISTS "&'VAR sKeyFile'"
        IF SYS IO EQ 0
            INVOKE "C:\SIL\KEYDEF.EXE" "&'VAR sKeyFile'"
        ELSE
            INVOKE "C:\SIL\KEYDEF.EXE" ""
        ENDIF
        IF VAR VERIFYSET EQ "ON"
            pause
        endif
        GOTO LOOP
LABEL OPT\
        CLS
        NOTIFY "VARIABLE    VALUE"
        NOTIFY "cOpt        &'VAR cOpt'"
        NOTIFY "sCmd        &'VAR sCmd'"
        NOTIFY "sDate       &'VAR sDate'"
        NOTIFY "sDefault    &'VAR sDefault'"
        NOTIFY "sDir        &'VAR sDir'"
        NOTIFY "sFile       &'VAR sFile'"
        NOTIFY "sFont       &'VAR sFont'"
        NOTIFY "sId         &'VAR sId'"
        NOTIFY "sInput      &'VAR sInput'"
        NOTIFY "sKeyFile    &'VAR sKeyFile'"
        NOTIFY "sOutput     &'VAR sOutput'"
        NOTIFY "sPurpose    &'VAR sPurpose'"
        NOTIFY "sTemp       &'VAR sTemp'"
        NOTIFY "sTmp        &'VAR sTmp'"
        NOTIFY "sFilter     &'VAR sFilter'"
        NOTIFY "VERIFYSET   &'VAR VERIFYSET'"
        NOTIFY
        PAUSE
        GOTO LOOP
LABEL OPT%
        VAR sDefFilt "*.*"
        VAR sTemp ""
        INPUT "Dir Filter[&'VAR sDefFilt']: " sTemp
        IF VAR sTemp EQ ""
            VAR sFilter VAR sDefFilt
        ELSE
            VAR sFilter VAR sTemp
        ENDIF
        IF VAR VERIFYSET EQ "ON"
            pause
        endif
        GOTO LOOP
label opt(
        VAR sTemp ""
        input "Name of variable: " sTemp
        IF VAR sTemp EQ ""
            goto loop
        endif
        VAR sTmp ""
        input "Contents of variable: " sTmp
        VAR &'VAR sTemp' "&'VAR sTmp'"
        IF VAR VERIFYSET EQ "ON"
            pause
        endif
        goto loop
label opt)
        VAR sTmp ""
        VAR sTemp ""
        input "Name of variable: " sTemp
        if var sTemp eq ""
            goto loop
        endif
        VAR sTmp VAR &'VAR sTemp'
        "&'VAR sTmp'"
        IF VAR VERIFYSET EQ "ON"
            pause
        endif
        goto loop
LABEL OPTQ
        NOTIFY "QUIT"
        CLS
        HALT RETURNING TO THE OUTSIDE
