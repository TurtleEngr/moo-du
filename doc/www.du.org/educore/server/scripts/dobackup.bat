ECHO OFF
REM This batch file makes a copy of your MOO database file for archiving.  It compresses the database file and also deletes any archives beyond the number you specify.
REM
REM The parameters for the batch file are:
REM first: the file name prefix for the database (e.g. "mymoo" for 
REM "mymoo.db")
REM second: the number of archives to retain, up to seven.  Older 
REM archives beyond this number are deleted. If the second parameter is 
REM omitted, then the last 5 archives are retained.  Generally, this 
REM batch file is run daily, so one archive is saved for each day.
REM
REM The script uses the GNU gzip DOS utility, since it is free and 
REM widely available.  You must modify the line below that runs the 
REM gzip compression utility (near the bottom of the batch file) so its 
REM path correctly points to the executable file.
REM
REM Change the path in the line 'cd "C:\mymoo\database"' given 
REM below so that it points to the directory where your MOO 
REM database is found.
REM
REM Copyright 1997 Diversity University

ECHO ### Running backup script ...

cd "C:\mymoo\database\"

IF "%1"=="" ECHO ### ERROR: No file name prefix for the MOO database was specified.
IF "%1"=="" EXIT

IF NOT EXIST %1.db ECHO ### ERROR: The file %1.db does not exist.
IF NOT EXIST %1.db EXIT

IF NOT EXIST backup.dbs\nul.ext MKDIR backup.dbs

IF EXIST backup.dbs\temp.db DEL backup.dbs\temp.db
ECHO ### ... copying database ...
COPY %1.db backup.dbs\temp.db
CD backup.dbs

REM Rename the existing archive files
ECHO ### ... renaming older archives ...
IF "%2"=="" GOTO FIVE
IF "%2"=="1" GOTO ONE
IF "%2"=="2" GOTO TWO
IF "%2"=="3" GOTO THREE
IF "%2"=="4" GOTO FOUR
IF "%2"=="5" GOTO FIVE
IF "%2"=="6" GOTO SIX
IF "%2"=="7" GOTO SEVEN
ECHO ### ERROR: An invalid number of days of backups was specified: %2 (assuming 5 and proceeding).
GOTO FIVE

:SEVEN
IF EXIST %1.backup7.db.gz DEL %1.backup7.db.gz
IF EXIST %1.backup6.db.gz RENAME %1.backup6.db.gz %1.backup7.db.gz
IF EXIST %1.backup5.db.gz RENAME %1.backup5.db.gz %1.backup6.db.gz
IF EXIST %1.backup4.db.gz RENAME %1.backup4.db.gz %1.backup5.db.gz
IF EXIST %1.backup3.db.gz RENAME %1.backup3.db.gz %1.backup4.db.gz
IF EXIST %1.backup2.db.gz RENAME %1.backup2.db.gz %1.backup3.db.gz
IF EXIST %1.backup1.db.gz RENAME %1.backup1.db.gz %1.backup2.db.gz
GOTO DONE

:SIX
IF EXIST %1.backup6.db.gz DEL %1.backup6.db.gz
IF EXIST %1.backup5.db.gz RENAME %1.backup5.db.gz %1.backup6.db.gz
IF EXIST %1.backup4.db.gz RENAME %1.backup4.db.gz %1.backup5.db.gz
IF EXIST %1.backup3.db.gz RENAME %1.backup3.db.gz %1.backup4.db.gz
IF EXIST %1.backup2.db.gz RENAME %1.backup2.db.gz %1.backup3.db.gz
IF EXIST %1.backup1.db.gz RENAME %1.backup1.db.gz %1.backup2.db.gz
GOTO DONE

:FIVE
IF EXIST %1.backup5.db.gz DEL %1.backup5.db.gz
IF EXIST %1.backup4.db.gz RENAME %1.backup4.db.gz %1.backup5.db.gz
IF EXIST %1.backup3.db.gz RENAME %1.backup3.db.gz %1.backup4.db.gz
IF EXIST %1.backup2.db.gz RENAME %1.backup2.db.gz %1.backup3.db.gz
IF EXIST %1.backup1.db.gz RENAME %1.backup1.db.gz %1.backup2.db.gz
GOTO DONE

:FOUR
IF EXIST %1.backup4.db.gz DEL %1.backup4.db.gz
IF EXIST %1.backup3.db.gz RENAME %1.backup3.db.gz %1.backup4.db.gz
IF EXIST %1.backup2.db.gz RENAME %1.backup2.db.gz %1.backup3.db.gz
IF EXIST %1.backup1.db.gz RENAME %1.backup1.db.gz %1.backup2.db.gz
GOTO DONE

:THREE
IF EXIST %1.backup3.db.gz DEL %1.backup3.db.gz
IF EXIST %1.backup2.db.gz RENAME %1.backup2.db.gz %1.backup3.db.gz
IF EXIST %1.backup1.db.gz RENAME %1.backup1.db.gz %1.backup2.db.gz
GOTO DONE

:TWO
IF EXIST %1.backup2.db.gz DEL %1.backup2.db.gz
IF EXIST %1.backup1.db.gz RENAME %1.backup1.db.gz %1.backup2.db.gz
GOTO DONE

:ONE
IF EXIST %1.backup1.db.gz DEL %1.backup1.db.gz

:DONE
IF EXIST temp.dbz DEL temp.dbz
ECHO ### ... compressing latest archive ...

REM ****
REM **** Adjust the following line so the path points to your gzip 
REM ****  compression utility ("gzip.exe")
REM ****
"C:\Utilities\GZip\gzip" temp.db

IF EXIST temp.dbz RENAME temp.dbz %1.backup1.db.gz
IF EXIST temp.db ECHO ### ERROR: Backup file temp.db was not compressed (possibly because the gzip utility wasn't found).

CD ..
ECHO ### ... done performing backup.
