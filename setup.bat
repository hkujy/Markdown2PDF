@echo off
setlocal EnableDelayedExpansion

echo ================================================================
echo          Markdown to PDF Converter Setup (Windows)
echo ================================================================
echo.
echo This script will install the required dependencies for the
echo Markdown to PDF conversion system.
echo.
echo Required dependencies:
echo - Pandoc (document converter)
echo - MiKTeX or TeX Live (LaTeX distribution)
echo - Git (if not already installed)
echo.

REM Check if running as administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo WARNING: Not running as administrator. Some installations may fail.
    echo Consider running this script as administrator for best results.
    echo.
    timeout /t 3 >nul
)

echo Checking existing installations...
echo.

REM Check if chocolatey is available
choco --version >nul 2>&1
set CHOCO_AVAILABLE=%errorLevel%

REM Check if winget is available
winget --version >nul 2>&1
set WINGET_AVAILABLE=%errorLevel%

REM Check current installations
echo [1/4] Checking Pandoc installation...
pandoc --version >nul 2>&1
if %errorLevel% equ 0 (
    echo ✓ Pandoc is already installed
    pandoc --version | findstr "pandoc"
    set NEED_PANDOC=0
) else (
    echo ✗ Pandoc not found - will install
    set NEED_PANDOC=1
)

echo.
echo [2/4] Checking LaTeX installation...
pdflatex --version >nul 2>&1
if %errorLevel% equ 0 (
    echo ✓ LaTeX distribution is already installed
    pdflatex --version | findstr -i "tex"
    set NEED_LATEX=0
) else (
    echo ✗ LaTeX distribution not found - will install MiKTeX
    set NEED_LATEX=1
)

echo.
echo [3/4] Checking Git installation...
git --version >nul 2>&1
if %errorLevel% equ 0 (
    echo ✓ Git is already installed
    git --version
    set NEED_GIT=0
) else (
    echo ✗ Git not found - will install
    set NEED_GIT=1
)

echo.
echo [4/4] Checking Python (optional for advanced features)...
python --version >nul 2>&1
if %errorLevel% equ 0 (
    echo ✓ Python is already installed
    python --version
) else (
    echo ✗ Python not found (optional - needed for some pandoc filters)
)

REM Check if anything needs to be installed
if "%NEED_PANDOC%"=="0" if "%NEED_LATEX%"=="0" if "%NEED_GIT%"=="0" (
    echo.
    echo ✓ All dependencies are already installed!
    goto verify_installation
)

echo.
echo ================================================================
echo                    Installation Options
echo ================================================================

if %CHOCO_AVAILABLE% equ 0 (
    echo Found Chocolatey package manager - recommended method
    set INSTALLER=choco
) else (
    if %WINGET_AVAILABLE% equ 0 (
        echo Found Windows Package Manager (winget) - recommended method
        set INSTALLER=winget
    ) else (
        echo No package manager found. Will download and install manually.
        set INSTALLER=manual
    )
)

echo.
echo Choose installation method:
echo 1. Use %INSTALLER% (recommended)
if not "%INSTALLER%"=="manual" (
    echo 2. Manual download and install
    echo 3. Skip installation and show download links
    echo 4. Exit
) else (
    echo 2. Skip installation and show download links  
    echo 3. Exit
)
echo.
set /p choice=Enter your choice (1-4): 

if "%choice%"=="1" goto install_auto
if "%choice%"=="2" goto install_manual
if "%choice%"=="3" goto show_links
if "%choice%"=="4" goto end

:install_auto
echo.
echo Starting automatic installation using %INSTALLER%...
echo.

if "%NEED_PANDOC%"=="1" (
    echo Installing Pandoc...
    if "%INSTALLER%"=="choco" (
        choco install pandoc -y
    ) else (
        if "%INSTALLER%"=="winget" (
            winget install --id JohnMacFarlane.Pandoc
        )
    )
)

if "%NEED_LATEX%"=="1" (
    echo Installing MiKTeX (this may take several minutes)...
    if "%INSTALLER%"=="choco" (
        choco install miktex -y
    ) else (
        if "%INSTALLER%"=="winget" (
            winget install --id MiKTeX.MiKTeX
        )
    )
)

if "%NEED_GIT%"=="1" (
    echo Installing Git...
    if "%INSTALLER%"=="choco" (
        choco install git -y
    ) else (
        if "%INSTALLER%"=="winget" (
            winget install --id Git.Git
        )
    )
)

goto verify_installation

:install_manual
echo.
echo Manual Installation Instructions:
echo.
echo Please download and install the following software:
echo.

if "%NEED_PANDOC%"=="1" (
    echo 1. Pandoc:
    echo    - Download: https://pandoc.org/installing.html
    echo    - Choose "Windows" and download the MSI installer
    echo    - Run the installer with default settings
    echo.
)

if "%NEED_LATEX%"=="1" (
    echo 2. MiKTeX LaTeX Distribution:
    echo    - Download: https://miktex.org/download
    echo    - Choose "MiKTeX for Windows" - Basic Installer
    echo    - Run the installer and install for all users
    echo    - This is a large download (several hundred MB)
    echo.
)

if "%NEED_GIT%"=="1" (
    echo 3. Git:
    echo    - Download: https://git-scm.com/download/win
    echo    - Run the installer with default settings
    echo.
)

echo After installing all dependencies, run this script again to verify.
pause
goto end

:show_links
echo.
echo Download Links:
echo ===============
echo.
echo Pandoc: https://pandoc.org/installing.html
echo MiKTeX: https://miktex.org/download
echo Git: https://git-scm.com/download/win
echo.
echo Optional:
echo Python: https://python.org/downloads/
echo VS Code: https://code.visualstudio.com/download
echo.
pause
goto end

:verify_installation
echo.
echo ================================================================
echo                    Verifying Installation
echo ================================================================
echo.

echo Testing Pandoc...
pandoc --version >nul 2>&1
if %errorLevel% equ 0 (
    echo ✓ Pandoc installation verified
    pandoc --version | findstr "pandoc"
) else (
    echo ✗ Pandoc verification failed
    echo   You may need to restart your command prompt or add Pandoc to PATH
)

echo.
echo Testing LaTeX...
pdflatex --version >nul 2>&1
if %errorLevel% equ 0 (
    echo ✓ LaTeX installation verified
    pdflatex --version | findstr -i "tex"
) else (
    echo ✗ LaTeX verification failed
    echo   You may need to restart your command prompt or add LaTeX to PATH
)

echo.
echo Testing the converter with template...
if exist "template.md" (
    echo Running test conversion...
    call convert.bat template.md test-output.pdf
    if exist "test-output.pdf" (
        echo ✓ Test conversion successful! Created test-output.pdf
        del test-output.pdf >nul 2>&1
    ) else (
        echo ✗ Test conversion failed
    )
) else (
    echo ⚠ template.md not found - skipping test conversion
)

echo.
echo ================================================================
echo                         Setup Complete
echo ================================================================
echo.
echo Your Markdown to PDF converter is ready to use!
echo.
echo Quick start:
echo 1. Copy template.md to a new file: copy template.md mydocument.md
echo 2. Edit your content in mydocument.md
echo 3. Convert to PDF: convert.bat mydocument.md
echo.
echo For more information, see README.md
echo.

:end
echo.
echo Press any key to exit...
pause >nul