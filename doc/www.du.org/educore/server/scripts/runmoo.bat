ECHO OFF
REM This batch file will save the most recent MOO log files, 
REM and then launch the MOO.
REM
REM You must pass it two parameters.  The first should be the 
REM MOO filename prefix, which is what is before the ".db" in 
REM the MOO database file's name.  The second is the port on 
REM which the MOO should start listening for connections.  If 
REM you omit the second parameter, the MOO will listen on 
REM whatever port was specified when the MOO Server was 
REM compiled.  Note that the opening lines the MOO sends to 
REM the log file will state what port the MOO is listening on.
REM
REM Change the path in the line 'cd "C:\mymoo\database"'
REM given below so that it points to the directory where your MOO 
REM database is found.
REM
REM Copyright 1997 Diversity University
REM

cd "C:\mymoo\database"

IF "%1"=="" ECHO ### ERROR: No MOO name specified for first parameter.
IF "%1"=="" EXIT

REM Moving Log Files...
IF NOT EXIST backup.logs\nul.ext MKDIR backup.logs
IF NOT EXIST %1.log GOTO RUNSERVER

ECHO ### Saving old log file...
MOVE %1.log backup.logs\%1.log
CD backup.logs
REM Concatenate old and new logs into tempfile
IF NOT EXIST %1.old_logs COPY %1.log tempfile.old_logs
IF EXIST %1.old_logs COPY %1.old_logs + %1.log tempfile.old_logs
IF EXIST %1.old_logs DEL %1.old_logs
RENAME tempfile.old_logs %1.old_logs
DEL %1.log
CD ..
ECHO ### ...done saving old log file.
ECHO:

:RUNSERVER
REM ECHO ### Saving a copy of the MOO database...
REM IF EXISTS %1.last.db DEL %1.last.db
REM COPY %1.db %1.last.db
REM ECHO ### ... done saving database copy.
REM ECHO:
REM You might want to remove the "REM " from the previous five lines, 
REM if you wish to have a copy of the MOO database set aside every 
REM time you run it. This is especially wise if you aren't going 
REM to use a periodically running script to make a nightly archived 
REM copy of the database (though you should be doing that!).

ECHO ### Starting MOO Server...
ECHO:
WinMOO.exe -o -l %1.log %1.db %1.db %2
ECHO ### ...MOO server shut down.


