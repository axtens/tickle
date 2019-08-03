        CHDIR D:\TICKLE
        VAR DEFAULT ""
        VAR FILTER "*.tcl"
LABEL LOOP
        VAR OPT ""
        VAR FILE ""
        VAR TMP ""
        CLS
        SHELL "DIR &'VAR FILTER'/W"
        NOTIFY
        NOTIFY "                1. EDIT         5. SET DIR FILTER"
        NOTIFY "                2. TICKLE       6. QUIT"
        NOTIFY "                3. SHELL"
        NOTIFY "                4. LIST"
LABEL GET
        VAR OPT ""
        GETCHAR OPT
        IF VAR OPT NI "123456"
                GOTO GET
        ENDIF
        GOTO OPT&'VAR OPT'


LABEL OPT1
        INPUT "FILE TO EDIT [DEFAULT=&'VAR DEFAULT']: " FILE
        IF VAR FILE EQ "."
                GOTO LOOP
        ENDIF
        IF VAR FILE EQ ""
                VAR FILE "&'VAR DEFAULT'"
        ELSE
                VAR DEFAULT "&'VAR FILE'"
        ENDIF
        INVOKE "C:\TOOLS\Q.EXE" "&'VAR FILE'"
        GOTO LOOP

LABEL OPT2
        INPUT "FILE TO TICKLE [DEFAULT=&'VAR DEFAULT']: " FILE
        IF VAR FILE EQ "."
                GOTO LOOP
        ENDIF
        IF VAR FILE EQ ""
                VAR FILE "&'VAR DEFAULT'"
        ELSE
                VAR DEFAULT "&'VAR FILE'"
        ENDIF
        INVOKE "C:\TOOLS\TICKLE.EXE" "&'VAR FILE'"
        GOTO LOOP

LABEL OPT3
        INVOKE "C:\DOS\COMMAND.COM" ""
        GOTO LOOP

LABEL OPT4
        INPUT "FILE TO LIST [DEFAULT=&'VAR DEFAULT']: " FILE
        IF VAR FILE EQ "."
                GOTO LOOP
        ENDIF
        IF VAR FILE EQ ""
                VAR FILE "&'VAR DEFAULT'"
        ELSE
                VAR DEFAULT "&'VAR FILE'"
        ENDIF
        INVOKE "C:\TOOLS\LIST.COM" "&'VAR FILE'"
        GOTO LOOP

LABEL OPT5
        VAR TMP ""
        INPUT "DIRECTORY FILTER: " TMP
        IF VAR TMP NE ""
                VAR FILTER VAR TMP
        ENDIF
        GOTO LOOP

LABEL OPT6
        CLS
        HALT RETURNING TO THE OUTSIDE
