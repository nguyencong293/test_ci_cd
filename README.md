# Student Manager System 🎓

**Hệ thống quản lý sinh viên hoàn chỉnh với CI/CD Pipeline**

## ✅ Trạng thái hiện tại: **READY TO USE**

### 🚀 **Quick Start - Chạy ngay bây giờ:**

```bash
# 1. Clone repository
git clone https://github.com/nguyencong293/test_ci_cd.git
cd student-manager

# 2. Chạy toàn bộ hệ thống
docker-compose up -d

# 3. Truy cập ứng dụng
# Frontend: http://localhost:3000
# Backend API: http://localhost:8080/api/students
# Health Check: http://localhost:8080/actuator/health
```

### 🏗️ **Tech Stack:**

**Frontend:**
- ⚛️ React 18 + TypeScript
- ⚡ Vite (Build tool)
- 🎨 Tailwind CSS
- 🐳 Docker + Nginx

**Backend:**
- ☕ Spring Boot 3.x
- 🗃️ Spring Data JPA
- 🔒 Spring Security
- 📊 MySQL 8.0
- 🐳 Docker

**DevOps:**
- 🚀 GitHub Actions CI/CD
- 🐳 Docker Compose
- 📊 Health Checks
- 🔧 Automated Testing

### 🔐 **2. GitHub Secrets Configuration**

Vào **GitHub Repository > Settings > Secrets and variables > Actions**:

**Required:**
- `DB_PASSWORD`: `your_secure_password_123`
- `DB_USERNAME`: `root`

**Optional:**
- `SLACK_WEBHOOK`: `https://hooks.slack.com/...`
- `BACKUP_BUCKET`: `your-backup-bucket`
- `GCP_CREDENTIALS`: `{...json...}`

### 💻 **3. Local Development**

```bash
# One-command setup
make setup

# Start development
make dev-up

# Access:
# - Frontend: http://localhost:3000
# - Backend: http://localhost:8080
# - Database: localhost:3306
```

### 🖥️ **4. Production Server Setup**

```bash
# On your VPS/Cloud server
wget https://raw.githubusercontent.com/YOUR_USERNAME/student-manager/main/scripts/server-setup.sh
chmod +x server-setup.sh
./server-setup.sh

# Edit configuration
cd /opt/student-manager
nano .env

# Deploy
docker-compose -f docker-compose.prod.yml up -d
```
│   (Port 3000)   │    │   (Port 8080)   │    │   (Port 3306)   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🚀 Quick Start

### Prerequisites
- Docker & Docker Compose
- Git
- Make (optional, for easier commands)

### Development Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd student-manager
   ```

2. **Start development environment**
   ```bash
   # Using Make (recommended)
   make setup
   
   # Or using Docker Compose directly
   docker compose up -d
   ```

3. **Access the application**
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:8080
   - Database: localhost:3306

### Using Make Commands

```bash
# Development
make dev-up        # Start development environment
make dev-down      # Stop development environment
make dev-logs      # View development logs

# Testing
make test          # Run all tests
make test-backend  # Run backend tests only
make test-frontend # Run frontend tests only

# Production
make prod-up       # Start production environment
make build-prod    # Build production images
make push          # Push images to registry

# Maintenance
make backup        # Create database backup
make clean         # Clean up Docker resources
make status        # View system status
make monitor       # Monitor resource usage

# Help
make help          # Show all available commands
```

## 🐳 Docker Configuration

### Development Environment
- Uses `docker-compose.yml`
- Hot reloading enabled
- Debug ports exposed
- Volume mounts for development

### Production Environment
- Uses `docker-compose.prod.yml`
- Optimized for performance
- Security hardening
- Resource limits configured

### Container Features
- **Multi-stage builds** for optimized image size
- **Non-root users** for security
- **Health checks** for monitoring
- **Resource limits** for stability

## 🔄 CI/CD Pipeline

The project uses GitHub Actions for automated CI/CD:

### Continuous Integration
- **Code quality checks** (linting, formatting)
- **Automated testing** (unit, integration)
- **Security scanning** (vulnerability detection)
- **Build validation** (Docker images)

### Continuous Deployment
- **Automated deployment** to staging/production
- **Database backups** before deployment
- **Health checks** after deployment
- **Rollback capability** on failure

### Workflows
- `ci-cd.yml` - Main CI/CD pipeline
- `deploy.yml` - Production deployment
- `backup.yml` - Automated database backups

## 📁 Project Structure

```
student-manager/
├── .github/workflows/          # GitHub Actions workflows
├── student-backend/            # Spring Boot backend
│   ├── src/
│   ├── Dockerfile
│   └── pom.xml
├── student-frontend/           # React frontend
│   ├── src/
│   ├── Dockerfile
│   ├── nginx.conf
│   └── package.json
├── mysql-init/                 # Database initialization
├── scripts/                    # Deployment scripts
├── docker-compose.yml          # Development environment
├── docker-compose.prod.yml     # Production environment
└── Makefile                    # Command shortcuts
```

## 🔧 Configuration

### Environment Variables

#### Backend
- `SPRING_PROFILES_ACTIVE` - Active Spring profile (dev/prod)
- `DB_HOST` - Database host
- `DB_PORT` - Database port
- `DB_NAME` - Database name
- `DB_USERNAME` - Database username
- `DB_PASSWORD` - Database password

#### Database
- `MYSQL_DATABASE` - Database name
- `MYSQL_ROOT_PASSWORD` - Root password
- `MYSQL_CHARSET` - Character set
- `MYSQL_COLLATION` - Collation

### Application Profiles

#### Development (`dev`)
- Debug logging enabled
- Hot reloading
- H2 console available
- DDL auto-update

#### Production (`prod`)
- Optimized performance
- Security hardening
- Connection pooling
- Monitoring enabled

## 🚀 Deployment

### Local Development
```bash
# Start all services
make dev-up

# View logs
make dev-logs

# Stop services
make dev-down
```

### Production Deployment

#### Option 1: Using Make
```bash
# Build and deploy
make build-prod VERSION=v1.0.0
make push VERSION=v1.0.0
make prod-up
```

#### Option 2: Using Scripts
```bash
# Setup environment
./scripts/dev-setup.sh

# Deploy to production
./scripts/deploy.sh v1.0.0
```

#### Option 3: GitHub Actions
Push to `main` branch to trigger automatic deployment.

### Manual Production Setup

1. **Prepare environment**
   ```bash
   # Create production directory
   mkdir -p /opt/student-manager
   cd /opt/student-manager
   
   # Copy production files
   cp docker-compose.prod.yml .
   cp -r mysql-init .
   ```

2. **Configure environment**
   ```bash
   # Create .env file
   cat > .env << EOF
   DB_PASSWORD=your_secure_password
   DB_USERNAME=root
   REGISTRY=ghcr.io
   IMAGE_NAME_BACKEND=your-username/student-manager/student-backend
   IMAGE_NAME_FRONTEND=your-username/student-manager/student-frontend
   EOF
   ```

3. **Deploy application**
   ```bash
   # Pull and start services
   docker compose -f docker-compose.prod.yml pull
   docker compose -f docker-compose.prod.yml up -d
   ```

## 📊 Monitoring & Maintenance

### Health Checks
- Frontend: http://localhost/health
- Backend: http://localhost:8080/actuator/health
- Database: Built-in MySQL health check

### Monitoring Endpoints
- `/actuator/health` - Application health
- `/actuator/metrics` - Application metrics
- `/actuator/info` - Application info

### Database Backup
```bash
# Create backup
make backup

# Restore from backup
make restore FILE=backup-20240101-120000.sql
```

### Log Management
```bash
# View all logs
make logs-app

# View specific service logs
docker compose logs -f backend
docker compose logs -f frontend
docker compose logs -f db
```

## 🔒 Security

### Container Security
- Non-root users in containers
- Read-only file systems where possible
- Security scanning with Trivy
- Regular base image updates

### Application Security
- Input validation
- SQL injection prevention
- XSS protection headers
- CORS configuration
- Authentication & authorization

### Network Security
- Internal Docker network
- Firewall rules
- HTTPS in production
- Database access restrictions

## 🧪 Testing

### Backend Testing
```bash
# Run all backend tests
cd student-backend
./mvnw test

# Run with coverage
./mvnw test jacoco:report
```

### Frontend Testing
```bash
# Run all frontend tests
cd student-frontend
npm test

# Run with coverage
npm test -- --coverage
```

### Integration Testing
```bash
# Test complete system
make test
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

### Development Workflow
1. `make dev-up` - Start development environment
2. Make changes to code
3. `make test` - Run tests
4. `make dev-logs` - Check logs
5. Commit and push changes

## 📝 Troubleshooting

### Common Issues

#### Services won't start
```bash
# Check Docker status
docker ps

# Check logs for errors
make dev-logs

# Reset environment
make dev-down
make clean
make dev-up
```

#### Database connection issues
```bash
# Check database health
docker compose exec db mysqladmin ping -h localhost -u root -pbaby

# Reset database
docker compose down -v
docker compose up -d
```

#### Build failures
```bash
# Clean and rebuild
make clean
make build
```

### Getting Help
- Check logs: `make dev-logs`
- View system status: `make status`
- Monitor resources: `make monitor`

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- Backend Developer
- Frontend Developer
- DevOps Engineer
- Database Administrator

---

For more information, please check the individual component READMEs:
- [Backend README](student-backend/README.md)
- [Frontend README](student-frontend/README.md)
"# CI/CD Test - $(date)" 
