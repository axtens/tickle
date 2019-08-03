REM CMLINST.TCL - installation routine for CML

   VAR ver 1
   VAR upd 7
   NOTIFY "CMLINST (c) Copyright Bruce M. Axtens. V&'VAR ver'.&'VAR upd'"


LABEL MAINLOOP

   CLS
   BOX 1 1 23 79
   BOX 1 16 2 46
   SHOWXY 2 18 "Christine Memorial Library System Installer"
   SHOWXY 5 10 "Please place CML PROGRAM diskette in drive B:"
   GOTOXY 6 10
   YESNO "Ready to install updated CML system (Y/N)? "
   IF SYS YESNO EQ 0
        GOTO HALTINST
   ENDIF
   EXISTS B:\CML.EXE
   IF SYS IO NE 0
        GOTO NOEXE
   ENDIF
LABEL ISEXE
   INVOKE NEWCML.EXE "-e -y b:\ CML.EXE"
   CLS
   BOX 1 1 23 79
   BOX 1 16 2 46
   SHOWXY 2 18 "Christine Memorial Library System Installer"
   EXISTS B:\CMLHELP.DBF
   IF SYS IO NE 0
        GOTO NOHELPDBF
   ENDIF
LABEL ISHELPDBF
   INVOKE NEWCML.EXE "-e -y B:\ CMLHELP.DBF"
   CLS
   BOX 1 1 23 79
   BOX 1 16 2 46
   SHOWXY 2 18 "Christine Memorial Library System Installer"
   EXISTS B:\CMLHELP.DBT
   IF SYS IO NE 0
        GOTO NOHELPDBT
   ENDIF
LABEL ISHELPDBT
   INVOKE NEWCML.EXE "-e -y b:\ CMLHELP.DBT"

LABEL REGEN
   CLS
   BOX 1 1 23 79
   BOX 1 16 2 46
   SHOWXY 2 18 "Christine Memorial Library System Installer"
   SHOWXY 5 10 "Please place CML DATA diskette in drive B:"
   GOTOXY 6 10
   YESNO "Ready to regenerate indexes for updated CML system (Y/N)? "
   IF SYS YESNO EQ 0
        GOTO HALTINST
   ENDIF
   EXISTS B:\CML.DBF
   IF SYS IO NE 0
        GOTO NOCMLDBF
   ENDIF

   INVOKE REGEN.EXE "B:\CML.DBF ACCESSION B:CACCESS"
   INVOKE REGEN.EXE "B:\CML.DBF UPPER(SUBSTR(AUTHOR,1,15)) B:CAUTHOR"
   INVOKE REGEN.EXE "B:\CML.DBF UPPER(SUBSTR(TITLE,1,15)) b:CTITLE"
   INVOKE REGEN.EXE "B:\CML.DBF TRIM(STR(VAL(DEWEY),10,3)-CODE) b:CDEWCOD"

   CLS
   BOX 1 1 23 79
   BOX 1 16 2 46
   SHOWXY 2 18 "Christine Memorial Library System Installer"
   GOTOXY 11 10
   YESNO "Are there any other CML data diskettes (Y/N)? "
   IF SYS YESNO NE 0
        GOTO REGEN
   ENDIF

   BOX 12 28 2 25
   SHOWXY 13 30 "Installation complete!"
   GOTOXY 23 0
   HALT

LABEL NOEXE
   SHOWXY 8 10 "Cannot find CML.EXE on the diskette in drive B:"
   GOTOXY 9 10
   YESNO "Are you sure you want to continue the installation (Y/N)? "
   IF SYS YESNO EQ 0
      GOTO HALTINST
   ENDIF
   GOTO ISEXE

LABEL NOHELPDBF
        SHOWXY 11 10 "Cannot find CMLHELP.DBF on the diskette in drive B:"
        GOTOXY 12 10
        YESNO "Are you sure you want to continue the installation (Y/N)? "
        IF SYS YESNO EQ 0
                GOTO HALTINST
        ENDIF
        GOTO ISHELPDBF

LABEL NOHELPDBT
        SHOWXY 14 10 "Cannot find CMLHELP.DBT on the diskette in drive B:"
        GOTOXY 15 10
        YESNO "Are you sure you want to continue the installation (Y/N)? "
        IF SYS YESNO EQ 0
                GOTO HALTINST
        ENDIF
        GOTO ISHELPDBT

LABEL NOCMLDBF
        SHOWXY 8 10 "Cannot find CML.DBF on the diskette in drive B:"
        GOTOXY 9 10
        YESNO "Are you sure you want to continue the installation (Y/N)? "
        IF SYS YESNO EQ 0
                GOTO HALTINST
        ENDIF
        GOTO REGEN

LABEL HALTINST
   BOX 12 28 2 23
   SHOWXY 13 30 "Installation halted!"
   GOTOXY 23 0
   HALT


