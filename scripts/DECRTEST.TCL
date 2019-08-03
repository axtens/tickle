    VAR A "a"
    VAR nDec VAR A
    VAR nDecBy 32
    VAR sRETURN "HERE"
    GOTO DECREMENT_SUB
LABEL HERE
    NOTIFY &'VAR nDec'
    halt
LABEL DECREMENT_SUB
        IF VAR nDecBy EQ 0
            GOTO NOMOREINCR
        ENDIF
        DECVAR nDec
        DECVAR nDecBy
        GOTO DECREMENT_SUB
LABEL NOMOREINCR
        GOTO &'VAR sRETURN'

