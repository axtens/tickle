     REM ZipLoad V2.0
     VAR ver 2
     VAR upd 0
     NOTIFY "ZipLoad Version &'VAR ver',&'VAR upd'"

     REM to increase/decrease the number of disks in a diskset then
     REM change DISKTOTAL to a higher or lower value

     VAR DISKTOTAL 8

     REM ZipLoad assumes that the archived files for a ZipSet reside in
     REM subdirectories below C:\ZIPSET named FILE1 through FILEn where n
     REM is the number of disks in the set. That is, the 2nd disk in the set
     REM will have it's file on C:\ZIPSET\FILE2.

     REM All floppy disks used in a ZipSet are assumed to be pre-formatted.

     CLS
     NOTIFY "THIS PROGRAM UPDATES/CREATES A SOFTWARE INSTALLATION ZIPSET"
     NOTIFY
     NOTIFY "HAVE READY &'VAR DISKTOTAL' FORMATTED DISKS NUMBERED 1 TO &'VAR DISKTOTAL'"
     NOTIFY
     PAUSE

     VAR DISKLIMIT VAR DISKTOTAL
     INCVAR DISKLIMIT

     VAR CNT 1

LABEL LOOP
     CLS
     YESNO "DISK &'VAR CNT' IN DRIVE A: (Y/N)? "
     IF SYS YESNO EQ 1
              SHELL "ECHO. | RECOVER A: >NUL"
              SHELL "DEL A:FILE*.* >NUL"
              SHELL "COPY C:\ZIPSET\FILE&'VAR CNT' A:"
              SHELL "LABEL A:ZIPSET&'VAR CNT'"
     ENDIF
     INCVAR CNT
     IF VAR CNT NE VAR DISKLIMIT
              GOTO LOOP
     ENDIF

     CLS
     NOTIFY "ZIPSET UPDATE/CREATE COMPLETE"
     PAUSE
     HALT
