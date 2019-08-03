        VAR N 1
LABEL X
        VAR B SYS CLVAR &'VAR N'
        IF VAR B EQ ""
                HALT
        ELSE
                NOTIFY "&'VAR N': &'VAR B'"
                INCVAR N
                GOTO X
        ENDIF
