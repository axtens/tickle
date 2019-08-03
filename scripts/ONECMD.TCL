    VAR CMD
    INPUT "Command: " CMD
    IF VAR CMD NE ""
        SHELL "&'VAR CMD'"
        PAUSE
    ENDIF
    HALT

