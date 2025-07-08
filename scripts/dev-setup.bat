@echo off
REM Development environment setup script for Windows

echo 🚀 Setting up Student Manager development environment...

REM Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not installed. Please install Docker Desktop first.
    exit /b 1
)

REM Check if Docker Compose is available
docker compose version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker Compose is not available. Please ensure Docker Desktop is running.
    exit /b 1
)

echo ✅ Docker and Docker Compose are available

REM Create necessary directories
if not exist "logs" mkdir logs
if not exist "data" mkdir data

REM Start the development environment
echo 🔧 Starting development environment...
docker compose up -d

REM Wait for services to be ready
echo ⏳ Waiting for services to be ready...
timeout /t 30 /nobreak >nul

REM Check service health
echo 🏥 Checking service health...

REM Check database
docker compose exec -T db mysqladmin ping -h localhost -u root -pbaby >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Database is ready
) else (
    echo ❌ Database is not ready
)

REM Check backend
curl -f http://localhost:8080/actuator/health >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Backend is ready
) else (
    echo ⚠️  Backend might not be ready yet (this is normal on first startup^)
)

REM Check frontend
curl -f http://localhost:3000/health >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Frontend is ready
) else (
    echo ⚠️  Frontend might not be ready yet
)

echo.
echo 🎉 Development environment is set up!
echo.
echo 📋 Service URLs:
echo    Frontend: http://localhost:3000
echo    Backend:  http://localhost:8080
echo    Database: localhost:3306
echo.
echo 🔧 Useful commands:
echo    View logs:     docker compose logs -f
echo    Stop services: docker compose down
echo    Restart:       docker compose restart
echo    Clean up:      docker compose down -v
echo.
pause
