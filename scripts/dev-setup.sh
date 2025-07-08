#!/bin/bash
# Development environment setup script

set -e

echo "🚀 Setting up Student Manager development environment..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

echo "✅ Docker and Docker Compose are installed"

# Create necessary directories
mkdir -p logs
mkdir -p data

# Start the development environment
echo "🔧 Starting development environment..."
docker-compose up -d

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 30

# Check service health
echo "🏥 Checking service health..."

# Check database
if docker-compose exec -T db mysqladmin ping -h localhost -u root -pbaby &> /dev/null; then
    echo "✅ Database is ready"
else
    echo "❌ Database is not ready"
fi

# Check backend
if curl -f http://localhost:8080/actuator/health &> /dev/null; then
    echo "✅ Backend is ready"
else
    echo "⚠️  Backend might not be ready yet (this is normal on first startup)"
fi

# Check frontend
if curl -f http://localhost:3000/health &> /dev/null; then
    echo "✅ Frontend is ready"
else
    echo "⚠️  Frontend might not be ready yet"
fi

echo ""
echo "🎉 Development environment is set up!"
echo ""
echo "📋 Service URLs:"
echo "   Frontend: http://localhost:3000"
echo "   Backend:  http://localhost:8080"
echo "   Database: localhost:3306"
echo ""
echo "🔧 Useful commands:"
echo "   View logs:     docker-compose logs -f"
echo "   Stop services: docker-compose down"
echo "   Restart:       docker-compose restart"
echo "   Clean up:      docker-compose down -v"
echo ""
