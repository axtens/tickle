# tickle
A scripting language written in Turbo Pascal 5.5 

The year was 1989. I had moved over from NE NSW to Perth in Western Australia to get married (here we are 30 years later and still married to the same woman.)

I got a job at Curtin University in their PC Support Group. They were importing PC and PC XT parts and assembling them for sale. One of my jobs was to help set up the computers with DOS and some in-house and third-party tools.

Tickle came out of that process. Tickle was a "Transfer Control Language" for transferring DOS and other software to the PCs we were building. This was before I heard about John Ousterhout's [Tool Command Language](https://en.wikipedia.org/wiki/Tcl), also known as Tcl (which predates my TCL by at least a year.)

Tickle scripts looked like this

```
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
​```
```

The design of the language was simplistic and without much planning, each day adding another component or supporting another workflow. No [yacc](https://www.javatpoint.com/yacc) or [bison](https://en.wikipedia.org/wiki/GNU_Bison). No [ANTLR](https://www.antlr.org/) -- it hadn't been invented yet. All written in Turbo Pascal 3, then 4, then 5, then 5.5. Eventually my contract at Curtin wound up and I had to find work elsewhere. Tickle stopped tickling floppy disks at that point.

I did keep fiddling with Tickle, eventually starting to convert it to Modula-2 and renaming it [TRICKLE](https://github.com/axtens/trickle.git) so as to get away from the naming issue with Tcl.

If you want to build Tickle, you'll have to find a suitable Pascal compiler. Quite a few are listed at [The Free Country](https://www.thefreecountry.com/compilers/pascal.shtml). 

The "units" folder contains a number of pascal source files for units used in the compilation of Tickle.