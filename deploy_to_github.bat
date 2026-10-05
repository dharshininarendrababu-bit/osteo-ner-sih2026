@echo off
setlocal enabledelayedexpansion
title Deploy OsteoNER Prototype to GitHub

echo =========================================================================
echo       Deploy OsteoNER Prototype to GitHub (SIH26004 - NexGen Minds)
echo =========================================================================
echo.

:: Check if git is installed
where git >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Git is not installed or not in your system PATH!
    echo Please install Git from https://git-scm.com/ and try again.
    echo.
    pause
    exit /b 1
)

echo [1/5] Checking Git repository initialization...
if not exist "%~dp0.git" (
    echo Initializing new Git repository...
    git -C "%~dp0" init
) else (
    echo Git repository already initialized.
)

echo.
echo [2/5] Staging and committing prototype files...
git -C "%~dp0" add .
git -C "%~dp0" commit -m "Deploy OsteoNER AI Early Detection System Prototype (SIH26004)" >nul 2>nul
if %errorlevel% equ 0 (
    echo Changes successfully committed.
) else (
    echo No new changes to commit, continuing...
)

echo.
echo [3/5] Setting main branch...
git -C "%~dp0" branch -M main

echo.
echo =========================================================================
echo  Please enter your GitHub Repository URL.
echo  Example: https://github.com/your-username/osteo-ner.git
echo =========================================================================
set /p REPO_URL="Enter GitHub Repository URL: "

if "%REPO_URL%"=="" (
    echo [ERROR] No GitHub URL provided. Deployment cancelled.
    pause
    exit /b 1
)

echo.
echo [4/5] Configuring remote origin to: %REPO_URL%
git -C "%~dp0" remote remove origin >nul 2>nul
git -C "%~dp0" remote add origin %REPO_URL%

echo.
echo [5/5] Pushing to GitHub (main branch)...
git -C "%~dp0" push -u origin main

if %errorlevel% equ 0 (
    echo.
    echo =========================================================================
    echo  SUCCESS! Your prototype has been uploaded to GitHub!
    echo.
    echo  To view your LIVE website on GitHub Pages:
    echo  1. Go to your repository settings on GitHub.com
    echo  2. Click "Pages" on the left menu
    echo  3. Under "Build and deployment" -> Source, select "GitHub Actions"
    echo     (or select Deploy from branch: main -> /root)
    echo  4. In 1-2 minutes, your prototype will be live at:
    echo     https://<your-username>.github.io/<repo-name>/
    echo =========================================================================
) else (
    echo.
    echo [NOTICE] Push failed or authentication was required.
    echo If prompted, please log in with your GitHub Personal Access Token (PAT)
    echo or configure your SSH key.
)

echo.
pause
