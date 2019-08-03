{$m $9000,$ffff,$ffff}
uses crt, xansi, xdos, dos, xstring, xparam;
const
        copyright = '(c)Copyright Bruce M. Axtens, 1989.';
        limit = 600;
        sysvars = 'YESNO,RET  ,IO   ,PARAM,ENVAR,CLVAR,KEYPR,';
type
    progptr = ^progrec;
    progrec = record
                    progtext : string[127]
              end;
    lablptr = ^lablrec;
    lablrec = record
                lablname : string[20];
                lablnum  : word
              end;

    variptr = ^varirec;
    varirec = record
                variname : string[20];
                varival  : string;
              end;

var
   prog : array [1..limit] of progptr;
   labl : array [1..limit] of lablptr;
   vari : array [1..limit] of variptr;
   
   buff : text;
   p0, filename1, filename2, inrec, kwdlist, kwd : string;
   i,j,k,l : word;
   ch : char;
   inif, transif : boolean;
   verifyrec, m, appendrec : string;
   varicounter, last, iostatus, returncode : word;
   keywaspressed, userbreak, verifyflag, yesnoflag : boolean;
   x : word;

procedure novar(x:string);
begin
        writeln('Variable ',x,' not found')

end;
function parse(cmd:string):word;
const  parselim = 36;
       parselst : array [1..parselim] of string[15] =
       ('.REM',
        '.INVOKE',
        '.PAUSE',
        '.MKDIR',
        '.RMDIR',
        '.CHDIR',
        '.IF',
        '.ENDIF',
        '.APPEND',
        '.DELETE',
        '.CLS',
        '.NOTIFY',
        '.REBOOT',
        '.CREATE',
        '.LABEL',
        '.GOTO',
        '.YESNO',
        '.VAR',
        '.VERIFY',
        '.ELSE',
        '.INCVAR',
        '.DECVAR',
        '.INPUT',
        '.SHELL',
        '.BOX',
        '.SHOWXY',
        '.GOTOXY',
        '.RANGE?',
        '.WIPE',
        '.HALT',
        '.EXISTS',
        '.USERBREAK',
        '.BEEP',
        '.WAIT',
        '.GETCHAR',
        '.PUTCHAR');
var
       i, j    : word;
       f       : boolean;
begin
       i := 1;
       j := 0;
       cmd := '.'+cmd;
       while i<=parselim do
               if cmd=parselst[i] then
               begin
                       j := i;
                       i := parselim+1
               end
               else
                       inc(i);
        parse := j
end;
function varexist(vname:string):word;
var     i : word;
        varifound : boolean;
begin
        upper(vname);
        i := 1;
        varifound := false;
        while vari[i]<>nil {i<varicounter} do
        begin
                if vname=vari[i]^.variname then
                begin
                        varexist := i;
                        i := varicounter;
                        varifound := true
                end
                else
                        inc(i)
        end;
        if not varifound then
                varexist := 0
end;

function convert_text(cvt:string):string;
const  percent = '&';
var    k : word;
       f0, f1, f2, f3 : string;
function converter(s:string):string;
var    s1, s2, s3 : string;
       j,k,l : word;
begin
       s1 := uppercase(car(s));
       s2 := uppercase(car(s));
       s3 := '';
       if s1='VAR' then
       begin
               j := varexist(s2);
               if j<>0 then
                       s3 := vari[j]^.varival (* str(vari[j]^.varival,s3) *)
               else
                       novar(s2)
       end
       else
               if s1='SYS' then
               begin
               j := listindex(rightfill(s2,5)+',',sysvars,6);
               case j of
                       0 : writeln('SYS ',s2,' NOT KNOWN.');
                       1 : str(ord(yesnoflag),s3);
                       2 : str(returncode,s3);
                       3 : str(iostatus,s3);
                       4 : str(pcnt-1,s3);
		       5 : s3 := getenv(uppercase(car(s)));
		       6 : begin
                    val(car(s),k,l);
                    if k<=pcnt then
                       s3 := pstr[k]
			   end;
		       7 : str(ord(keywaspressed),s3);
               end
               end
                else
                       if s[1]=percent then
                               s3 := percent
                       else
                               writeln('CONVERT "',s,'" NOT KNOWN');
       converter := s3
end;
var lastpos : word;
begin
       k := 1;
        lastpos := 0;
       while (k<>0) do
       begin
               k := pos(percent,cvt);
               if (k<>0) and (k<>lastpos) then
               begin
                       f0:= copy(cvt,1,k-1);
                       f1:= copy(cvt,k+1,255);
                       f2:= car(f1);
                       f3:= f1;
                        cvt := f0+converter(f2)+f3;
               end;
                if k=lastpos then k:=0;
                lastpos := k;

       end;
       convert_text := cvt
end;


procedure do_message(s:string);
begin
       write((s))
end;
procedure do_gotoxy(x:string);
var
        i, x1, y1 : word;
begin
        val(car(x),x1,i);
        val(car(x),y1,i);
        xdos.gotoxy(x1,y1)
end;
procedure do_wipe(x:string);
var     i, x1, x2, y1, y2 : word;
begin
        val(car(x),x1,i);
        val(car(x),y1,i);
        val(car(x),x2,i);
        val(car(x),y2,i);
       for i := 0 to x2-x1 do
       begin
               xdos.gotoxy(x1+i,y1);
               write(repeatstring(y2-y1+1,' '))
       end;
end;
procedure do_box(x:string);
var     i, x1, x2, y1, y2 : word;
procedure write_xy( row, col :word; txt:string);
begin
     xdos.gotoxy(row,col);
     write(txt)
end;
procedure draw_box(toprow, topcol, height, width : word);
var
        i : word;
begin

        write_xy(toprow,topcol,topleft);
        write_xy(toprow,topcol+1,repeatstring(width-1,lyingdown));
        write_xy(toprow,topcol+width,topright);

        for i := 1 to height-1 do
        begin
             write_xy(toprow+i,topcol,upright);
             write_xy(toprow+i,topcol+width,upright);
        end;
        write_xy(toprow+height,topcol,bottomleft);
        write_xy(toprow+height,topcol+1,repeatstring(width-1,lyingdown));
        write_xy(toprow+height,topcol+width,bottomright);
end;
begin
        val(car(x),x1,i);
        val(car(x),y1,i);
        val(car(x),x2,i);
        val(car(x),y2,i);
        draw_box(x1,y1,x2,y2);
end;
procedure do_printat(x:string);
var
        i, x1, y1 : word;
        m       : string;
begin
        val(car(x),x1,i);
        val(car(x),y1,i);
        m := car(x);
        xdos.gotoxy(x1,y1);
        do_message(m)
end;

procedure do_input(cmdline:string);
var     m,v,i : string;
        j,k : word;
begin
        m := car(cmdline);
        v := car(cmdline);
        if m<>'' then
           do_message(m);
        readln(i);
        {val(i,j,k);}
        k := varexist(v);
        if k<>0 then
                vari[k]^.varival := i
        else
                novar(v)

end;
procedure do_getchar(cmdline:string);
var     regs : registers;
	v,i : string;
        k : word;
        c : char;
begin
        v := car(cmdline);
        k := varexist(v);
        if k<>0 then
	begin
		fillchar(regs,sizeof(regs),0);
		regs.ah := 8;
		msdos(regs);
		vari[k]^.varival := chr(regs.al);
{
                read(input,c);
                vari[k]^.varival := c;
                if eof(input) then iostatus := 1}
	end
        else
                novar(v)

end;
procedure do_putchar(cmdline:string);
var     v : string;
        k : word;
begin
        v := car(cmdline);
        k := varexist(v);
        if k<>0 then
                write(vari[k]^.varival)
        else
                novar(v)

end;

procedure do_incvar(vname:string);
var     i,j,k : word;
        varifound : boolean;
begin
        k := varexist(vname);
        if k<>0 then
        begin
                (* inc(vari[k]^.varival) *)
                val(vari[k]^.varival,i,j);
                inc(i);
                str(i,vari[k]^.varival)
        end
        else
                novar(vname)
end;
procedure do_decvar(vname:string);
var     i,j,k : word;
        varifound : boolean;
begin
        k := varexist(vname);
        if k<>0 then
        begin
                (* dec(vari[k]^.varival) *)
                val(vari[k]^.varival,i,j);
                dec(i);
                str(i,vari[k]^.varival)
        end
        else
                novar(vname)
end;
procedure do_var(s: string);
var     i, k, l, m, n: word;
        j, vname, t1, t2 : string;
begin
       vname := uppercase(car(s));
       t1 := uppercase(car(s));
       t2 := uppercase(car(s));
        k := varexist(vname);
        if k<>0 then
        begin
          j := '';
          i := listindex(rightfill(t1,3)+',','SYS,VAR,CMD,',4);
          case i of
               0 : (* {assume value} val(t1,j,m); *)
                        j := t1;
               1 : begin
                       m := listindex(rightfill(t2,5)+',',sysvars,6);
                       case m of
                               0 : writeln('SYS ',t2,' NOT KNOWN');
                               1 : str(ord(yesnoflag),j); 
                               2 : str(returncode,j);
                               3 : str(iostatus,j);
                               4 : str(pcnt-1,j);
			       5 : j := getenv(uppercase(car(s)));
		               6 : begin
				       val(car(s),l,n);
					if l<=pcnt then
				       		j := pstr[l]
			           end;
			       7 : str(ord(keywaspressed),j);

                       end;
                   end;
               2 : begin
                       m := varexist(t2);
                       if m<>0 then
                                j := vari[m]^.varival
                        else
                                novar(t2)
                      end;
               3 : begin

                       val(t2,l,m);
                       j := pstr[l+1];
                   end;
           end;
           vari[k]^.varival := j
        end
        else novar(vname)

end;

procedure setif(s:string);
var
       t1, t2, t3, t4, t5, t6 : string;
       val1, val2 : string;
       i, j, k, l, n : word;
begin
       t1 := '';
       t2 := '';
       t3 := '';
       t4 := '';
       t5 := '';
       t6 := '';
       val1 := '';
       val2 := '';
        inif := true;

       t1 := uppercase(car(s));
       j := listindex(rightfill(t1,3)+',','VAR,CMD,SYS,',4);
       case j of
               0 : writeln('CANNOT UNDERSTAND IF');
               1 : begin
                       t2 := car(s);
                       k := varexist(t2);
                       if k<>0 then
                               val1 := vari[k]^.varival
                       else
                               novar(t2);
                       t3 := car(s);
                       i := listindex(rightfill(t3,2)+',','EQ,NE,LT,LE,GT,GE,IN,NI,',3);
                       t4 := car(s);
                       if t4<>'VAR' then
                               val2 := t4
                       else
                       begin
                               t5 := car(s);
                               k := varexist(t5);
                               if k<>0 then
                                       val2 := vari[k]^.varival
                               else
                                       novar(t5)
                       end;
                       case i of
                               0 : writeln('COULD NOT UNDERSTAND OPERATOR');
                               1 : transif := val1=val2;
                               2 : transif := val1<>val2;
                               3 : transif := val1<val2;
                               4 : transif := val1<=val2;
                               5 : transif := val1>val2;
                               6 : transif := val1>=val2;
                              7 : transif := (pos(val1,val2)<>0);
                              8 : transif := (pos(val1,val2)=0);
                       end;
                       end;
               2 : begin
                       for k := 2 to pcnt do
                               val1 := val1 + pstr[k] + chr(0);
                       t2 := uppercase(car(s));
                       transif := pos(t2,val1)<>0
                   end;
               3 : begin
                       t2 := uppercase(car(s));
                       k := listindex(rightfill(t2,5)+',',sysvars,6);
                       case k of
                               0 : writeln('SYS ',t2,' NOT KNOWN');
                               1 : str(ord(yesnoflag),val1);
                               2 : str(returncode,val1);
                               3 : str(iostatus,val1);
                               4 : str(pcnt-1,val1);
			       5 : val1 := getenv(uppercase(car(s)));
		               6 : begin
					val(car(s),l,n);
					if l<=pcnt then
						val1 := pstr[l]
			           end;
			       7 : str(ord(keywaspressed),val1);
                       end;
                       t3 := car(s);
                       i := listindex(rightfill(uppercase(t3),2)+',','EQ,NE,LT,LE,GT,GE,',3);
                       t4 := car(s);
                       if t4<>'VAR' then
                               val2 := t4
                       else
                       begin
                               t5 := car(s);
                               k := varexist(t5);
                               if k<>0 then
                                       val2 := vari[k]^.varival
                               else
                                       novar(t5)
                       end;
                       case i of
                               0 : writeln('COULD NOT UNDERSTAND OPERATOR');
                               1 : transif := val1=val2;
                               2 : transif := val1<>val2;
                               3 : transif := val1<val2;
                               4 : transif := val1<=val2;
                               5 : transif := val1>val2;
                               6 : transif := val1>=val2;
                       end;
                       end;
               end;
end;
procedure unknown(s:string);
begin
       writeln('Keyword ',s,' not known.');
end;
procedure do_invoke(s:string);
begin
       if s<>'' then
               returncode := invoke(car(s),car(s))
       else
               writeln('INVOKE with no commands')
end;
procedure do_pause(s:string);
begin
       if s<>'' then
               do_message(car(s))
       else
               write('Press any key');
       while not keypressed do;
       ch := readkey;
       writeln
end;
procedure do_mkdir(s:string);
begin
       if s<>'' then
       begin
               {$i-} mkdir((car(s))); {$i+}
               iostatus := ioresult
       end
       else
               writeln('MKDIR with no directory')
end;
procedure do_rmdir(s:string);
begin
       if s<>'' then
        begin
               {$i-} rmdir((car(s))); {$i+}
                iostatus := ioresult
        end
        else
               writeln('RMDIR with no directory')
end;
procedure do_chdir(s:string);
begin
       if s<>'' then
               chdir((car(s)))
       else
               writeln('CHDIR with no directory')
end;
procedure do_setif(s:string);
begin
       setif(s);
       if verifyflag then
               if transif then
                       writeln('<<<< TRUE >>>>')
               else
                       writeln('<<<< FALSE >>>>')
end;
procedure do_endif;
begin
       if not inif then
               writeln('ENDIF but no IF')
end;
procedure do_append(s:string);
begin
       if s<>'' then
       begin
               assign(buff,(car(s)));
               {$i-}
               append(buff);
               {$i+}
               iostatus := ioresult;
               if iostatus <>0 then
                       writeln('APPEND couldn''t find file')
               else
               begin
                       appendrec := car(s);
                       while appendrec<>'' do
                       begin
                               writeln(buff,(appendrec));
                               appendrec := car(s)
                       end;
                       close(buff)
               end
       end
       else
               writeln('APPEND without filename')
end;
procedure do_delete(s:string);
begin
        if s<>'' then
        begin
                assign(buff,(car(s)));
                {$i-} erase(buff); {$i+}
                iostatus := ioresult
        end
        else
                writeln('DELETE with no file name.')
end;
procedure do_cls;
begin
       crt.clrscr
end;
procedure do_notify(s:string);
begin
       do_message(car(s));
        writeln
end;
procedure do_create(s:string);
var f : string;
begin
     f := convert_text(car(s));
       if f<>'' then
       begin
               assign(buff,f);
                {$i-} rewrite(buff); {$i+}
                iostatus := ioresult;
                {$i-} close(buff); {$i+}
                iostatus := ioresult
        end
        else
                writeln('CREATE without filename')
end;
procedure do_goto(s:string);
var flag : boolean;
begin
        flag := false;
       l := 1;
       m := (uppercase(s));
       while labl[l]<>nil {l<last} do
               if labl[l]^.lablname <> m then
                       inc(l)
               else
               begin
                       i := labl[l]^.lablnum-1;
                       l := limit+1;
                       inif := false;
                       transif := false;
                        flag := true;
               end;
        if flag=false then
        begin
                writeln('Label ',s,' not found.');
                halt
        end;

end;
procedure do_yesno(s:string);
begin
       do_message(car(s));
        yesnoflag := yesno('')
end;
procedure do_verify(s:string);
begin
       m := uppercase(first(s));
       if m='ON' then
               verifyflag := true
       else
               if m='OFF' then
                       verifyflag := false
               else
                       writeln('VERIFY ',m,' DOESN''T MAKE SENSE.')
end;
procedure do_userbreak(s:string);
begin
       m := uppercase(first(s));
       if m='ON' then
               userbreak := true
       else
               if m='OFF' then
                       userbreak := false
               else
                       writeln('USERBREAK ',m,' DOESN''T MAKE SENSE.')
end;
procedure do_else;
begin
       if inif then
               transif := not transif
        else
                writeln('ELSE OUTSIDE OF IF')
end;
procedure do_shell(s:string);
begin
       if s<>'' then
               returncode := command((car(s)))
       else
               writeln('SHELL without command')
end;
procedure do_exists(s:string);
var f : string;
begin
       f := (car(s));
       assign(buff,f);
       {$i-}
       reset(buff);
       {$i+}
       iostatus :=ioresult
end;
procedure do_wait(s:string);
var milliseconds : word;
    i            : word;
begin
     val(car(s),milliseconds,i);
     delay(milliseconds);
end;
procedure do_beep(s:string);
var hertz : word;
    i : word;
begin
     val(car(s),hertz,i);
     sound(hertz);
     do_wait(s);
     nosound
end;

procedure build_pstr(s:string);
var i : word;
begin
	i := 0;
	while s<>'' do
	begin
		pstr[i] := car(s);
		inc(i)
	end;
	pcnt := i-1
end;



begin
     p0 := getcommandline;
     verifyflag := param_qualify(p0,'V');
     userbreak := param_qualify(p0,'B');
     load_parameters(p0);
     
     assign(input,'');
     reset(input);
     assign(output,'');
     rewrite(output);
     keywaspressed := false;
     inif := false;
     transif := false;
     for i := 1 to limit do
     begin
       prog[i] := nil;
       vari[i] := nil;
       labl[i] := nil
     end;
     inrec := p0;
     filename1 := addfiletype(car(inrec),'.TCL');
     assign(buff,filename1);
     {$i-}
     reset(buff);
     {$i+}
     if ioresult<>0 then
     begin
        writeln(filename1,' not found.');
        halt
     end;
     j := 1;
     last := 1;
     varicounter := 1;
     while not eof(buff) do
     begin
          readln(buff,inrec);
          ltrim(inrec);
          if inrec<>'' then
          begin
               new(prog[j]);
               prog[j]^.progtext := inrec;
               if uppercase(first(inrec))='LABEL' then
               begin
                new(labl[last]);
                labl[last]^.lablname := uppercase(butfirst(inrec));
                labl[last]^.lablnum := j;
                inc(last);
               end;
               if uppercase(first(inrec))='VAR' then
               begin
                new(vari[varicounter]);
                vari[varicounter]^.variname := uppercase(first(butfirst(inrec)));
                vari[varicounter]^.varival  := '';
                inc(varicounter)
               end;
               inc(j);
          end
     end;
     close(buff);
     dec(j);
     i := 1;
     while prog[i]<>nil do
     begin
	if keypressed then
	begin
		keywaspressed := true;
		if userbreak then
			if yesno('Stop processing (Y/N)?') then
				halt;
	end
	else
		keywaspressed := false;

          inrec := (prog[i]^.progtext);
	  if uppercase(first(inrec))<>'REM' then
		inrec := convert_text(inrec);
          verifyrec := inrec;
          kwd := car(inrec);
          upper(kwd);
          if transif or (not inif) then
          begin
              if verifyflag then writeln((verifyrec));
               k := parse(uppercase(kwd));
               case k of
               0 : unknown(kwd);
               1 : ;
               2 : do_invoke(inrec);
               3 : do_pause(inrec);
               4 : do_mkdir(inrec);
               5 : do_rmdir(inrec);
               6 : do_chdir(inrec);
               7 : do_setif(inrec);
               8 : do_endif;
               9 : do_append(inrec);
               10: do_delete(inrec);
              11: do_cls;
               12: do_notify(inrec);
               13: warmboot;
               14: do_create(inrec);
               15: ;
               16: do_goto(inrec);
               17: do_yesno(inrec);
              18: do_var(inrec);
               19: do_verify(inrec);
               20: do_else;
               21: do_incvar(car(inrec));
               22: do_decvar(car(inrec));
               23: do_input(inrec);
               24: do_shell(inrec);
              25: do_box(inrec);
               26: do_printat(inrec);
               27: do_gotoxy(inrec);
               28: writeln('RANGE? no longer supported.');
               29: do_wipe(inrec);
               30: begin
			writeln(inrec);
			halt
		   end;
               31: do_exists(inrec);
	       32: do_userbreak(inrec);
               33: do_beep(inrec);
               34: do_wait(inrec);
	       35: do_getchar(inrec);
               36: do_putchar(inrec);
           end;
       end
       else
           if kwd = 'ENDIF' then
           begin
                transif := false;
                inif := false
           end
           else if kwd = 'ELSE' then
                transif := not transif;
      inc(i);
      end;
end.
