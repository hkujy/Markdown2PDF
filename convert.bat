@echo off

REM Simple Markdown to PDF Converter
REM Usage: convert.bat [input.md] [output.pdf]

if "%~1"=="" (
    echo Usage: convert.bat input.md [output.pdf]
    echo Example: convert.bat template.md
    echo.
    echo Available markdown files:
    for %%f in (*.md) do echo   %%f
    pause
    exit /b 1
)

set "input=%~1"
if "%~2"=="" (
    for %%i in ("%input%") do set "output=%%~ni.pdf"
) else (
    set "output=%~2"
)

if not exist "%input%" (
    echo Error: File "%input%" not found.
    pause
    exit /b 1
)

echo Converting "%input%" to "%output%"...

REM Check for bibliography and citation files
set "options=--pdf-engine=pdflatex"
if exist "refs.bib" (
    set "options=%options% --citeproc --bibliography=refs.bib"
    echo Using bibliography: refs.bib
)
if exist "apa.csl" (
    set "options=%options% --csl=apa.csl"
    echo Using citation style: apa.csl
)

REM Convert
pandoc "%input%" -o "%output%" %options%

if %errorlevel% equ 0 (
    echo.
    echo Success! Created: %output%
    if exist "%output%" (
        for %%i in ("%output%") do echo File size: %%~zi bytes
    )
) else (
    echo.
    echo Conversion failed. Check your markdown file and LaTeX installation.
)

pause