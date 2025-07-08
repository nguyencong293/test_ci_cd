#!/bin/bash
# Script to update GitHub repository references in workflows

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔧 GitHub Repository Configuration Setup${NC}"
echo "=========================================="

# Get GitHub username and repository name
read -p "Enter your GitHub username: " GITHUB_USERNAME
read -p "Enter your repository name (default: student-manager): " REPO_NAME
REPO_NAME=${REPO_NAME:-student-manager}

echo ""
echo -e "${YELLOW}📝 Updating configuration files...${NC}"

# Update CI/CD workflow
echo "Updating .github/workflows/ci-cd.yml..."
if [ -f ".github/workflows/ci-cd.yml" ]; then
    sed -i "s/\${{ github.repository }}/$GITHUB_USERNAME\/$REPO_NAME/g" .github/workflows/ci-cd.yml
    echo "✅ Updated CI/CD workflow"
else
    echo "⚠️  CI/CD workflow file not found"
fi

# Update deployment workflow
echo "Updating .github/workflows/deploy.yml..."
if [ -f ".github/workflows/deploy.yml" ]; then
    sed -i "s/\${{ github.repository }}/$GITHUB_USERNAME\/$REPO_NAME/g" .github/workflows/deploy.yml
    echo "✅ Updated deployment workflow"
else
    echo "⚠️  Deployment workflow file not found"
fi

# Update Makefile
echo "Updating Makefile..."
if [ -f "Makefile" ]; then
    sed -i "s/your-username/$GITHUB_USERNAME/g" Makefile
    sed -i "s/student-manager/$REPO_NAME/g" Makefile
    echo "✅ Updated Makefile"
else
    echo "⚠️  Makefile not found"
fi

# Update docker-compose.prod.yml
echo "Updating docker-compose.prod.yml..."
if [ -f "docker-compose.prod.yml" ]; then
    sed -i "s/student-backend:latest/ghcr.io\/$GITHUB_USERNAME\/$REPO_NAME\/student-backend:latest/g" docker-compose.prod.yml
    sed -i "s/student-frontend:latest/ghcr.io\/$GITHUB_USERNAME\/$REPO_NAME\/student-frontend:latest/g" docker-compose.prod.yml
    echo "✅ Updated docker-compose.prod.yml"
else
    echo "⚠️  docker-compose.prod.yml not found"
fi

# Update deployment script
echo "Updating scripts/deploy.sh..."
if [ -f "scripts/deploy.sh" ]; then
    sed -i "s/your-username/$GITHUB_USERNAME/g" scripts/deploy.sh
    sed -i "s/student-manager/$REPO_NAME/g" scripts/deploy.sh
    echo "✅ Updated deployment script"
else
    echo "⚠️  Deployment script not found"
fi

# Create .env.example file
echo "Creating .env.example..."
cat > .env.example << EOF
# Database Configuration
DB_HOST=db
DB_PORT=3306
DB_NAME=student_manager
DB_USERNAME=root
DB_PASSWORD=your_secure_password_here

# Application Configuration
SPRING_PROFILES_ACTIVE=prod
SERVER_PORT=8080
JPA_DDL_AUTO=validate

# Logging Configuration
LOG_LEVEL=INFO
LOG_LEVEL_WEB=WARN
LOG_LEVEL_SQL=WARN
HEALTH_SHOW_DETAILS=when_authorized

# Database Pool Configuration
DB_POOL_SIZE=10
DB_POOL_MIN_IDLE=5

# Registry Configuration (for production)
REGISTRY=ghcr.io
IMAGE_NAME_BACKEND=ghcr.io/$GITHUB_USERNAME/$REPO_NAME/student-backend
IMAGE_NAME_FRONTEND=ghcr.io/$GITHUB_USERNAME/$REPO_NAME/student-frontend

# Backup Configuration (optional)
BACKUP_BUCKET=your-backup-bucket
GCP_CREDENTIALS=your-gcp-credentials-json

# Notification Configuration (optional)
SLACK_WEBHOOK=your-slack-webhook-url
EOF
echo "✅ Created .env.example"

# Update README with correct URLs
echo "Creating updated README.md..."
cat > README.md << EOF
# Student Manager

A complete student management system with Spring Boot backend, React frontend, and MySQL database.

## 🚀 Quick Start

### Prerequisites
- Docker & Docker Compose
- Git
- Node.js 20+ (for local development)
- Java 17+ (for local development)

### Local Development

\`\`\`bash
# Clone repository
git clone https://github.com/$GITHUB_USERNAME/$REPO_NAME.git
cd $REPO_NAME

# Start development environment
make setup

# Access applications
# Frontend: http://localhost:3000
# Backend: http://localhost:8080
# Database: localhost:3306
\`\`\`

### Production Deployment

1. **Setup server:**
   \`\`\`bash
   chmod +x scripts/server-setup.sh
   ./scripts/server-setup.sh
   \`\`\`

2. **Configure environment:**
   \`\`\`bash
   cp .env.example .env
   nano .env  # Edit configuration
   \`\`\`

3. **Deploy:**
   \`\`\`bash
   make prod-up
   \`\`\`

## 📚 Documentation

- [Deployment Guide](DEPLOYMENT_GUIDE.md) - Complete deployment instructions
- [API Documentation](http://localhost:8080/swagger-ui.html) - Swagger API docs
- [Architecture](docs/ARCHITECTURE.md) - System architecture overview

## 🛠️ Development Commands

\`\`\`bash
make dev-up          # Start development environment
make dev-down        # Stop development environment
make test            # Run all tests
make build           # Build Docker images
make clean           # Clean up Docker resources
make backup          # Create database backup
make status          # Check system status
\`\`\`

## 🏗️ Architecture

- **Backend**: Spring Boot 3.4.7 + JPA + MySQL
- **Frontend**: React 19 + TypeScript + Tailwind CSS
- **Database**: MySQL 8.0
- **Infrastructure**: Docker + Docker Compose
- **CI/CD**: GitHub Actions

## 📊 Features

- ✅ Student management (CRUD operations)
- ✅ Subject management
- ✅ Grade tracking
- ✅ RESTful API
- ✅ Responsive web interface
- ✅ Database migrations
- ✅ Health checks & monitoring
- ✅ Automated testing
- ✅ CI/CD pipeline
- ✅ Production-ready Docker setup

## 🔐 Security

- Non-root Docker containers
- Input validation
- SQL injection prevention
- CORS configuration
- Health check endpoints
- Security headers

## 📈 Monitoring

- Application health checks
- Database health monitoring
- Prometheus metrics
- Structured logging
- Resource monitoring

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (\`git checkout -b feature/amazing-feature\`)
3. Commit changes (\`git commit -m 'Add amazing feature'\`)
4. Push to branch (\`git push origin feature/amazing-feature\`)
5. Open Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- 📧 Email: your-email@example.com
- 🐛 Issues: [GitHub Issues](https://github.com/$GITHUB_USERNAME/$REPO_NAME/issues)
- 📖 Documentation: [Wiki](https://github.com/$GITHUB_USERNAME/$REPO_NAME/wiki)

## 🙏 Acknowledgments

- Spring Boot team for the excellent framework
- React team for the amazing frontend library
- Docker for containerization
- GitHub Actions for CI/CD
EOF
echo "✅ Created README.md"

echo ""
echo -e "${GREEN}🎉 Configuration completed successfully!${NC}"
echo "======================================="
echo ""
echo -e "${YELLOW}📋 Next steps:${NC}"
echo "1. Review and commit the changes:"
echo "   git add ."
echo "   git commit -m 'feat: configure repository settings'"
echo ""
echo "2. Push to GitHub:"
echo "   git remote add origin https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
echo "   git push -u origin main"
echo ""
echo "3. Configure GitHub Secrets:"
echo "   - Go to Settings > Secrets and variables > Actions"
echo "   - Add required secrets (see DEPLOYMENT_GUIDE.md)"
echo ""
echo "4. Test the CI/CD pipeline:"
echo "   - Create a Pull Request"
echo "   - Watch GitHub Actions run tests"
echo ""
echo -e "${GREEN}✨ Your repository is now ready for CI/CD!${NC}"
EOF
