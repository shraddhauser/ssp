@echo off
echo ============================================
echo  Office VPN Resource Access Management System
echo ============================================
echo.

:: Check Java
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Java is not installed or not in PATH.
    echo Please install JDK 8+ and set JAVA_HOME.
    pause
    exit /b 1
)

:: Check Maven
mvn -version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Maven is not installed or not in PATH.
    echo Please install Maven 3.6+ and add to PATH.
    pause
    exit /b 1
)

echo [OK] Java and Maven detected.
echo.
echo [INFO] Starting Office VPN System on http://localhost:8080
echo [INFO] Press Ctrl+C to stop the server.
echo.

cd /d "%~dp0"
mvn clean compile tomcat7:run

pause
