@echo off 
REM # TCS PreP Loader - v0.25 - Copyright (c) 2025 Carl Hopkins

ECHO +====================================================+
ECHO +              TCS PreP Loader - v0.25               +
ECHO +====================================================+

PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command ""iwr -useb https://raw.githubusercontent.com/carlhopkins/TCS-PreP-Tool/main/TCS-PreP-Shell.ps1 | iex""' -Verb RunAs}"
TIMEOUT /T 2