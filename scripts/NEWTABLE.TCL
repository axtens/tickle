        REM NEWTABLE.TCL
        VAR sTemp ""
        VAR sId ""
        VAR sDate SYS ENVAR DATE
        VAR sPurpose ""
        CLS
        NOTIFY "Create .CCT file"
        NOTIFY
        INPUT "Name of file (without extension): " sTemp
        IF VAR sTemp EQ ""
            HALT No name given.
        ENDIF
        CREATE "&'VAR sTemp'.TMP"
        INPUT "Identification: " sId
        INPUT "Purpose: " sPurpose
        VAR sDate SYS ENVAR DATE
        IF VAR sDate EQ ""
            INPUT "Date: " sDate
        ENDIF
        APPEND "&'VAR sTemp'.tmp" "c &'VAR sTemp'.CCT - &'VAR sId'"
        APPEND  "&'VAR sTemp'.tmp" "c Author: Bruce M. Axtens."
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
        INVOKE "c:\tools\INCLUDE.EXE" ".i &'VAR sTemp'.tmp &'VAR sTemp'.cct"
        DELETE "&'VAR sTemp'.tmp"
        HALT Processing complete


