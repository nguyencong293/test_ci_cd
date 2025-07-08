# Student Manager Project Makefile

.PHONY: help dev-up dev-down prod-up prod-down build test clean logs backup

# Default goal
.DEFAULT_GOAL := help

# Variables
REGISTRY = ghcr.io
REPO_NAME = your-username/student-manager
VERSION ?= latest

## Show this help message
help:
	@echo "Student Manager Project"
	@echo "======================="
	@echo ""
	@echo "Available commands:"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"; printf "\033[36m\033[0m"} /^[$$()% a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Development
## Start development environment
dev-up:
	@echo "🚀 Starting development environment..."
	docker compose up -d
	@echo "✅ Development environment started"
	@echo "Frontend: http://localhost:3000"
	@echo "Backend: http://localhost:8080"
	@echo "Database: localhost:3306"

## Stop development environment
dev-down:
	@echo "🛑 Stopping development environment..."
	docker compose down

## View development logs
dev-logs:
	docker compose logs -f

## Restart development environment
dev-restart:
	@echo "🔄 Restarting development environment..."
	docker compose restart

##@ Production
## Start production environment
prod-up:
	@echo "🚀 Starting production environment..."
	docker compose -f docker-compose.prod.yml up -d
	@echo "✅ Production environment started"

## Stop production environment
prod-down:
	@echo "🛑 Stopping production environment..."
	docker compose -f docker-compose.prod.yml down

## View production logs
prod-logs:
	docker compose -f docker-compose.prod.yml logs -f

##@ Build & Test
## Build all images
build:
	@echo "🔨 Building images..."
	docker compose build
	@echo "✅ Build completed"

## Build and tag for production
build-prod:
	@echo "🔨 Building production images..."
	docker build -t $(REGISTRY)/$(REPO_NAME)/student-backend:$(VERSION) ./student-backend
	docker build -t $(REGISTRY)/$(REPO_NAME)/student-frontend:$(VERSION) ./student-frontend
	@echo "✅ Production build completed"

## Push images to registry
push:
	@echo "📤 Pushing images to registry..."
	docker push $(REGISTRY)/$(REPO_NAME)/student-backend:$(VERSION)
	docker push $(REGISTRY)/$(REPO_NAME)/student-frontend:$(VERSION)
	@echo "✅ Images pushed successfully"

## Run backend tests
test-backend:
	@echo "🧪 Running backend tests..."
	cd student-backend && ./mvnw test

## Run frontend tests
test-frontend:
	@echo "🧪 Running frontend tests..."
	cd student-frontend && npm test

## Run all tests
test: test-backend test-frontend

##@ Database
## Create database backup
backup:
	@echo "💾 Creating database backup..."
	@BACKUP_FILE="backup-$$(date +%Y%m%d-%H%M%S).sql"; \
	DB_CONTAINER=$$(docker ps --filter "name=student-manager-db" --format "{{.ID}}"); \
	if [ ! -z "$$DB_CONTAINER" ]; then \
		docker exec $$DB_CONTAINER mysqladmin ping -h localhost -u root -pbaby && \
		docker exec $$DB_CONTAINER mysqldump -u root -pbaby --single-transaction student_manager > $$BACKUP_FILE && \
		echo "✅ Backup created: $$BACKUP_FILE"; \
	else \
		echo "❌ Database container not found"; \
	fi

## Restore database from backup
restore:
	@echo "🔄 Restoring database from backup..."
	@if [ -z "$(FILE)" ]; then \
		echo "❌ Please specify backup file: make restore FILE=backup.sql"; \
		exit 1; \
	fi
	@DB_CONTAINER=$$(docker ps --filter "name=student-manager-db" --format "{{.ID}}"); \
	if [ ! -z "$$DB_CONTAINER" ]; then \
		docker exec -i $$DB_CONTAINER mysql -u root -pbaby student_manager < $(FILE) && \
		echo "✅ Database restored from $(FILE)"; \
	else \
		echo "❌ Database container not found"; \
	fi

##@ Maintenance
## Clean up unused Docker resources
clean:
	@echo "🧹 Cleaning up Docker resources..."
	docker system prune -af
	docker volume prune -f
	@echo "✅ Cleanup completed"

## View system status
status:
	@echo "📊 System Status"
	@echo "==============="
	@echo ""
	@echo "🐳 Docker containers:"
	@docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
	@echo ""
	@echo "💾 Docker volumes:"
	@docker volume ls
	@echo ""
	@echo "🌐 Service health:"
	@echo -n "Frontend: "; curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/health 2>/dev/null || echo "Not accessible"
	@echo -n "Backend:  "; curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/actuator/health 2>/dev/null || echo "Not accessible"

## Monitor system resources
monitor:
	@echo "📈 System Resource Monitoring"
	@echo "============================"
	@docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"

##@ Development Tools
## Open backend shell
shell-backend:
	docker compose exec backend bash

## Open database shell
shell-db:
	docker compose exec db mysql -u root -pbaby student_manager

## Follow application logs
logs-app:
	docker compose logs -f backend frontend

## Install dependencies
install:
	@echo "📦 Installing dependencies..."
	cd student-backend && ./mvnw dependency:resolve
	cd student-frontend && npm install
	@echo "✅ Dependencies installed"

##@ Quick Start
## Complete setup for new developers
setup: dev-up
	@echo "⏳ Waiting for services to initialize..."
	@sleep 30
	@make status
	@echo ""
	@echo "🎉 Setup complete! Your development environment is ready."
	@echo ""
	@echo "Next steps:"
	@echo "  1. Frontend: http://localhost:3000"
	@echo "  2. Backend API: http://localhost:8080"
	@echo "  3. View logs: make dev-logs"
	@echo "  4. Run tests: make test"
