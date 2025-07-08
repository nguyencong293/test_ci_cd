#!/bin/bash
# Production deployment script

set -e

REGISTRY="ghcr.io"
REPO_NAME="your-username/student-manager"
VERSION=${1:-latest}

echo "🚀 Deploying Student Manager to production..."
echo "📦 Version: $VERSION"

# Pull latest images
echo "📥 Pulling latest images..."
docker pull $REGISTRY/$REPO_NAME/student-backend:$VERSION
docker pull $REGISTRY/$REPO_NAME/student-frontend:$VERSION

# Update docker-compose.prod.yml with new image tags
echo "🔄 Updating image tags..."
sed -i "s|student-backend:latest|$REGISTRY/$REPO_NAME/student-backend:$VERSION|g" docker-compose.prod.yml
sed -i "s|student-frontend:latest|$REGISTRY/$REPO_NAME/student-frontend:$VERSION|g" docker-compose.prod.yml

# Create backup of current deployment
echo "💾 Creating backup..."
BACKUP_DIR="backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p $BACKUP_DIR

# Backup database
if docker ps --filter "name=student-manager-db" --format "{{.ID}}" | grep -q .; then
    DB_CONTAINER=$(docker ps --filter "name=student-manager-db" --format "{{.ID}}")
    docker exec $DB_CONTAINER mysqladump -u root -p$DB_PASSWORD --single-transaction student_manager > $BACKUP_DIR/pre_deploy_backup.sql
    echo "✅ Database backup created"
fi

# Deploy new version
echo "🚀 Deploying new version..."
docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d --wait

# Health check
echo "🏥 Running health checks..."
sleep 30

# Check backend health
for i in {1..30}; do
    if curl -f http://localhost:8080/actuator/health &> /dev/null; then
        echo "✅ Backend is healthy"
        break
    fi
    echo "⏳ Waiting for backend... ($i/30)"
    sleep 10
done

# Check frontend health
for i in {1..10}; do
    if curl -f http://localhost:80/health &> /dev/null; then
        echo "✅ Frontend is healthy"
        break
    fi
    echo "⏳ Waiting for frontend... ($i/10)"
    sleep 5
done

# Run smoke tests
echo "🧪 Running smoke tests..."
if curl -f http://localhost:80/health && curl -f http://localhost:8080/actuator/health; then
    echo "✅ Smoke tests passed"
else
    echo "❌ Smoke tests failed"
    echo "🔄 Rolling back..."
    docker-compose -f docker-compose.prod.yml down
    # Restore previous version here if needed
    exit 1
fi

# Cleanup old images
echo "🧹 Cleaning up old images..."
docker image prune -af --filter "until=24h"

echo "🎉 Deployment completed successfully!"
echo "🌐 Application is available at: http://localhost"
