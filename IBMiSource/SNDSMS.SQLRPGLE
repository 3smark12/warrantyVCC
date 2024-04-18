000100231121     H Option( *SrcStmt: *NoDebugIo )  BndDir( 'QC2LE' ) DFTACTGRP(*NO)
000101231121
000102231121
000103231121       dcl-s w_EMAIL char(50) inz(*blanks);
000104231121       dcl-s w_Server char(5) inz(*blanks);
000105231121       dcl-s w_SMS char(20) inz(*blanks) DIM(3);
000106231121       dcl-s I packed(1:0);
000107231121       dcl-s w_cmdStr char(5000);
000108231121       dcl-s w_cmdLen packed(15:5) inz(%size(w_cmdStr));
000109231121       dcl-s apos char(1) inz(x'7D');
000110231121       dcl-s wkMaxRows packed(3) inz(%elem(Result));
000111231121       dcl-s wkRtvRows like(wkMaxRows);
000112231121       dcl-s sqlstmt char(2000) inz(*blanks);
000113231121
000114231121       dcl-ds Result qualified dim(100);
000115231121            JobName char(28);
000116231121            Subsystem char(10);
000117231121            JobType char(3);
000118231121            JobStatus char(4);
000119231121       end-ds ;
000120231121
000121231121       dcl-ds R3DA498 dtaara('R3DA498');
000123231121            SMS1 CHAR(20);
000124231121            SMS2 CHAR(20);
000125231121            SMS3 CHAR(20);
000126231121            EMAIL CHAR(190);
000127231121       end-ds;
000128231121
000129231121       //Parameter *Entry
000130231121       dcl-pr R3R499 ExtPgm;
000131231121              *n char(10);
000132231121              *n char(10);
000133231121       end-pr;
000134231121
000135231121       //Prototype call command line
000136231121       dcl-pr QCMDEXC extpgm('QCMDEXC');
000137231121            p_cmdStr like(w_cmdStr);
000138231121            p_cmdLen like(w_cmdLen);
000139231121       end-pr;
000140231121
000141231121       in *lock R3DA498;
000142231121           w_SMS(1) = %trim(SMS1);
000143231121           w_SMS(2) = %trim(SMS2);
000144231121           w_SMS(3) = %trim(SMS3);
000145231121           w_EMAIL = %trim(EMAIL);
000146231121       out R3DA498;
000147231121
000148231121       exec sql GET DIAGNOSTICS CONDITION 1 :w_Server = SERVER_NAME ;
000149231121
000150231121       // Send SMS to the mobile no. defined in DTAARA(R3R49)
000151231121       for I = 1 to 3;
000152231121          if %trim(w_SMS(I)) <> *blanks ;
000153231121               w_cmdStr = 'VSNDEMAIL SUBJECT(' + apos + '-=' +
000154231121               %trim(w_Server) + ' Subsytem Ended Alert=-'
000155231121               + apos + ') ' +
000156231121               'RECIPADR(' + %trim(w_SMS(I)) + ') ' +
000157231121               'RECIPDOM(SMS.VOLVO.COM) ' +
000158231121               'RECIPNAME(Support) ' +
000159231121               'SENDERADR(esmark.dublin) ' +
000160231121               'SENDERDOM(VOLVOCARS.COM) ' +
000161231121               'SENDERNAME(Support) ' +
000162231121               'MESSAGE('+ apos + %trim(p_SBS) +
000163231121                ' unplanned end in ' + %trim(w_Server) +  apos +')';
000164231121                QCMDEXC(w_cmdStr:w_cmdLen);
000165231121                w_cmdStr = *blanks;
000166231121           endif;
000167231121         endfor;
000168231121         // V0F81PMMNU  - add this application on the menu to monitor SBS
000169231121       *inlr = *on;
000170231121
