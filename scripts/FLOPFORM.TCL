     REM FlopForm.Tcl - Format Floppy as 1.2M or 360K in 1.2M drive
     REM              -               as 1.4M or 720K in 1.4M drive
     VAR ver 1
     VAR upd 2
     NOTIFY "FlopForm.TCL V&'VAR ver'.&'VAR upd'"

     VAR FMT SYS CLVAR 2
     IF VAR FMT EQ ""
              GOTO LOOP
     ENDIF
     IF VAR FMT EQ 360 
              NOTIFY "Formatting 360K floppy disk on A:"
              VAR FORMATCMD "A:/4/H"
              VAR RETURN EXIT
              GOTO FORMATTER
     ENDIF
     IF VAR FMT EQ 1.2
              NOTIFY "Formatting 1.2M floppy disk on A:"
              VAR FORMATCMD "A:/H"
              VAR RETURN EXIT
              GOTO FORMATTER
     ENDIF
     IF VAR FMT EQ 720
              NOTIFY "Formatting 720K floppy disk on B:"
              VAR FORMATCMD "B:/N:9/H"
              VAR RETURN EXIT
              GOTO FORMATTER
     ENDIF
     IF VAR FMT EQ 1.44
              NOTIFY "Formatting 1.44M floppy disk on B:"
              VAR FORMATCMD "B:/H"
              VAR RETURN EXIT
              GOTO FORMATTER
     ENDIF
LABEL EXIT
     HALT

LABEL LOOP
     CLS
     BOX 2 30 10 22
     SHOWXY 2 36 " FlopForm "
     SHOWXY 4 32 "1. Format 360K disk"
     SHOWXY 5 32 "2. Format 1.2M disk"
     SHOWXY 6 32 "3. Format 720K disk"
     SHOWXY 7 32 "4. Format 1.4M disk"
     SHOWXY 8 32 "5. Quit"
     SHOWXY 10 32 "Choice:"
LABEL LOOP2
     GOTOXY 10 40
     VAR opt " "
     GETCHAR opt
     IF VAR opt NI "12345"
              BEEP 440 8
              GOTO LOOP2
     ENDIF
     SHOWXY 10 40 "&'VAR opt'"
     GOTOXY 12 1

     GOTO L&'VAR opt'

LABEL L1
     VAR RETURN LOOP
     VAR FORMATCMD "A:/4/H"
LABEL L2
     VAR RETURN LOOP
     VAR FORMATCMD "A:/H"
     GOTO FORMATTER
LABEL L3
     VAR RETURN LOOP
     VAR FORMATCMD "B:/N:9/H"
     GOTO FORMATTER
LABEL L4
     VAR RETURN LOOP
     VAR FORMATCMD "B:/H"
     GOTO FORMATTER
LABEL L5
     HALT

LABEL FORMATTER
     INVOKE "C:\TOOLS\KEY-FAKE.COM" '"N" 13'
     INVOKE "C:\DOS\FORMAT.COM" "&'VAR FORMATCMD'"
     GOTO &'VAR RETURN'
