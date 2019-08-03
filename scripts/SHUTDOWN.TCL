rem :Shutdown
chdir c:
chdir \
shell "chkdsk /f"
shell "del \*.chk"
shell "echo yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy | sclean ~*.tmp"
shell "echo yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy | sclean *.tmp"
shell "echo yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy | sclean *.~??"
shell "echo yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy | sclean *.bak"
shell "echo yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy | sclean *.$??"
chdir d:
chdir \
shell "chkdsk /f"
shell "del \*.chk"
shell "echo yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy | sclean ~*.tmp"
shell "echo yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy | sclean *.tmp"
shell "echo yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy | sclean *.~??"
shell "echo yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy | sclean *.bak"
shell "echo yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy | sclean *.$??"
shell 'echo Print "Shutdown at ";Time$;" ";Date$ | GwBasic | Find ":" >>c:\logger.dat'
shell "recorder | tee c:\prevreco.dat | skip 4 >c:\recorder.dat"
shell "sort <c:\recorder.dat | progonly >c:\recorder.dat"
shell "GWBASIC T:RECORDER.BAS"
shell "del c:\recorder.dat"
shell "SORT <C:\RECORDER.CNT | IO >C:\RECORDER.CNT"
shell "hddpark"
