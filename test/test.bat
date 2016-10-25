@ECHO OFF
SETLOCAL EnableDelayedExpansion
::references
REM http://stackoverflow.com/questions/7425360/batch-file-to-search-for-a-string-within-directory-names
::variables
SET destroot=.\dest
SET isValid=1

CLS
ECHO 1.HGL
ECHO 2.PRD
ECHO.

CHOICE /C 12 /M "Escolha o ambiente:"

:: Note - list ERRORLEVELS in decreasing order
REM IF ERRORLEVEL 2 GOTO Prd
REM IF ERRORLEVEL 1 GOTO Hlg
IF ERRORLEVEL 2 call :Prd isValid
IF ERRORLEVEL 1 call :Hlg isValid

ECHO isValid %isValid%

goto End

::subroutines
:Prd
	SET %1=2323
	ECHO Deploy em PRD
	call :DefineSettings isValid
GOTO Eos

:Hlg
	SET %1=2323
	ECHO Deploy em HLG
	call :DefineSettings isValid
GOTO Eos

:DefineSettings
	SET %1=442456
	set /p include=Incluir apenas(todas):
	set /p exclude=Excluir apenas(nenhuma):

	if "%include%"=="" (
		REM ECHO "inclui todas"
	) 
	if NOT "%include%"=="" (
		REM ECHO "%include%"
	)

	if "%exclude%"=="" (
		REM ECHO "exclui nenhuma"
	) 
	if NOT "%exclude%"=="" (
		REM ECHO "%exclude%"
	)
	call :Run isValid
	
GOTO Eos

:Run
	SETLOCAL EnableDelayedExpansion
	REM SET %1=6nivel
	FOR /f "delims=" %%i IN ( ' dir /ad/b "%destroot%"' ) DO (
		REM echo "%%i"
		REM SET isValid=1
		REM SET %1=1
		SET %1=0
		ECHO fst isValidpri %isValid% !%1!
		SET "folder=%%i"
		if /I NOT "!folder:corecommerce=!"=="!folder!" (
			REM robocopy ".\origin" "%destroot%\%%i" /IS /s 
			REM TODO: stop here
			ECHO isValid =second= %isValid% !isValid!
			call :EvaluateParam isValid %%i
			ECHO isValid =third= %isValid% !isValid!
			if "!isValid!"=="1" (
				ECHO "copiado em %%i com sucessoooooooooooooooooo" 
			)
		)
	   
	)
	SET %1=6nive--out
GOTO End

:EvaluateParam
	REM SET isValid=1
	SET candidate=%2
	call :EvaluateInclude isValid %candidate%
	if "!isValid!"=="1" (
		call :EvaluateExclude isValid %candidate%
	) 
	REM SET %1=%isValid%
	REM SET %1=1
GOTO Eos

:EvaluateInclude
	SET candidate=%2
	if "%include%"=="" (
		SET %1=1
	) 
	if NOT "%include%"=="" (
		call :ParseInclude "%include%" %2 isValid
		REM set "%1=0"
	)
GOTO Eos

:EvaluateExclude
	SET candidate=%2
	if "%exclude%"=="" (
		set %1=1
	) 
	if NOT "%exclude%"=="" (
		call :ParseExclude "%exclude%" %2 isValid
		REM set "%1=0"
	)
GOTO Eos

:ParseInclude
	SET list=%1
	SET list=%list:"=%
	SET __isValid=0
	SET %3=0
	FOR /f "tokens=1* delims= " %%a IN ("%list%") DO (
		SET "_candidate=%2"
		ECHO in for include "%%a" "%%b" %_candidate% !_candidate! %2
		if /I NOT "!_candidate:%%a%=!"=="!_candidate!" (
		REM if /i not x%_candidate:%_folder%=%==x%_candidate%  (

			SET __isValid=1
			SET %3=1
			REM call :sub %%a
			ECHO find include "%%a" "%%b" %_candidate% !_candidate! %2
			GOTO Eos
		)
		if not "%%b"=="" call :ParseInclude "%%b" %2 %3
	)
	
	SET %3=%__isValid%

GOTO Eos

:ParseExclude
	SET list=%1
	SET list=%list:"=%
	SET __isValid=1
	SET %3=1
	FOR /f "tokens=1* delims= " %%a IN ("%list%") DO (
		SET "_candidate=%2"
		ECHO in for exclude %%a %_candidate% !_candidate! %2
		if /I NOT "!_candidate:%%a%=!"=="!_candidate!" (

			SET __isValid=0
			SET %3=0

			ECHO find exclude %%a %_candidate% !_candidate! %2
			GOTO Eos
		)
		if not "%%b"=="" call :ParseExclude "%%b" %2 %3
	)
	
	SET %3=%__isValid%

GOTO Eos



:End
PAUSE

:Eos
endlocal
