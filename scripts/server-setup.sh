#!/bin/bash
# Production Server Setup Script
# Run this script on your VPS/Cloud server

set -e

echo "🚀 Setting up Student Manager Production Server..."
echo "=================================================="

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    echo "❌ Please run this script as non-root user with sudo privileges"
    exit 1
fi

# Update system
echo "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install required packages
echo "📦 Installing required packages..."
sudo apt install -y curl wget git htop nano

# Install Docker
echo "🐳 Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    echo "✅ Docker installed successfully"
else
    echo "✅ Docker already installed"
fi

# Install Docker Compose
echo "🐳 Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "✅ Docker Compose installed successfully"
else
    echo "✅ Docker Compose already installed"
fi

# Create application directory
echo "📁 Creating application directory..."
sudo mkdir -p /opt/student-manager
sudo chown $USER:$USER /opt/student-manager
cd /opt/student-manager

# Clone repository
echo "📥 Cloning repository..."
if [ ! -d ".git" ]; then
    read -p "Enter your GitHub repository URL: " REPO_URL
    git clone $REPO_URL .
else
    echo "✅ Repository already cloned, pulling latest changes..."
    git pull origin main
fi

# Create environment file
echo "⚙️ Setting up environment configuration..."
if [ ! -f ".env" ]; then
    echo "Creating .env file..."
    cat > .env << 'EOF'
# Production Environment Variables
DB_PASSWORD=change_this_secure_password_123
DB_USERNAME=root
REGISTRY=ghcr.io
IMAGE_NAME_BACKEND=your-username/student-manager/student-backend
IMAGE_NAME_FRONTEND=your-username/student-manager/student-frontend
EOF
    echo "⚠️  IMPORTANT: Please edit .env file and change the default passwords!"
    echo "   nano .env"
else
    echo "✅ .env file already exists"
fi

# Create directories
echo "📁 Creating required directories..."
mkdir -p logs data backups

# Set up firewall
echo "🔥 Configuring firewall..."
sudo ufw --force enable
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 8080/tcp  # Backend API
sudo ufw allow 3000/tcp  # Frontend (development)
echo "✅ Firewall configured"

# Create systemd service for auto-start
echo "🔧 Creating systemd service..."
sudo tee /etc/systemd/system/student-manager.service > /dev/null << EOF
[Unit]
Description=Student Manager Application
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/opt/student-manager
ExecStart=/usr/local/bin/docker-compose -f docker-compose.prod.yml up -d
ExecStop=/usr/local/bin/docker-compose -f docker-compose.prod.yml down
TimeoutStartSec=0
User=$USER
Group=$USER

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable student-manager.service
echo "✅ Systemd service created and enabled"

# Create backup script
echo "💾 Setting up backup script..."
tee /opt/student-manager/backup.sh > /dev/null << 'EOF'
#!/bin/bash
# Backup script for Student Manager

BACKUP_DIR="/opt/student-manager/backups"
DATE=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="$BACKUP_DIR/backup-$DATE.sql"

mkdir -p $BACKUP_DIR

# Create database backup
DB_CONTAINER=$(docker ps --filter "name=student-manager-db" --format "{{.ID}}")
if [ ! -z "$DB_CONTAINER" ]; then
    echo "Creating backup: $BACKUP_FILE"
    docker exec $DB_CONTAINER mysqladmin ping -h localhost -u root -p$(grep DB_PASSWORD .env | cut -d '=' -f2) >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        docker exec $DB_CONTAINER mysqldump -u root -p$(grep DB_PASSWORD .env | cut -d '=' -f2) --single-transaction --routines --triggers student_manager > $BACKUP_FILE
        echo "✅ Backup created successfully: $BACKUP_FILE"
        
        # Compress backup
        gzip $BACKUP_FILE
        echo "✅ Backup compressed: $BACKUP_FILE.gz"
        
        # Remove backups older than 7 days
        find $BACKUP_DIR -name "backup-*.sql.gz" -type f -mtime +7 -delete
        echo "✅ Old backups cleaned up"
    else
        echo "❌ Database is not accessible"
        exit 1
    fi
else
    echo "❌ Database container not found"
    exit 1
fi
EOF

chmod +x /opt/student-manager/backup.sh

# Setup cron job for daily backups
echo "⏰ Setting up daily backup cron job..."
(crontab -l 2>/dev/null; echo "0 2 * * * /opt/student-manager/backup.sh >> /opt/student-manager/logs/backup.log 2>&1") | crontab -
echo "✅ Daily backup cron job created (runs at 2 AM)"

# Install monitoring tools (optional)
echo "📊 Installing monitoring tools..."
sudo apt install -y htop iotop nethogs

# Create useful aliases
echo "🔧 Creating useful aliases..."
cat >> ~/.bashrc << 'EOF'

# Student Manager aliases
alias sm-start='cd /opt/student-manager && docker-compose -f docker-compose.prod.yml up -d'
alias sm-stop='cd /opt/student-manager && docker-compose -f docker-compose.prod.yml down'
alias sm-logs='cd /opt/student-manager && docker-compose -f docker-compose.prod.yml logs -f'
alias sm-status='cd /opt/student-manager && docker-compose -f docker-compose.prod.yml ps'
alias sm-backup='/opt/student-manager/backup.sh'
alias sm-update='cd /opt/student-manager && git pull origin main && docker-compose -f docker-compose.prod.yml pull && docker-compose -f docker-compose.prod.yml up -d'
EOF

echo ""
echo "🎉 Production server setup completed!"
echo "===================================="
echo ""
echo "📋 Next steps:"
echo "1. Edit environment variables:"
echo "   nano /opt/student-manager/.env"
echo ""
echo "2. Update GitHub repository URL in the cloned code"
echo ""
echo "3. Deploy the application:"
echo "   cd /opt/student-manager"
echo "   docker-compose -f docker-compose.prod.yml up -d"
echo ""
echo "4. Check status:"
echo "   docker-compose -f docker-compose.prod.yml ps"
echo ""
echo "📡 Service URLs (after deployment):"
echo "   Frontend: http://$(curl -s ifconfig.me)"
echo "   Backend:  http://$(curl -s ifconfig.me):8080"
echo "   Health:   http://$(curl -s ifconfig.me)/health"
echo ""
echo "🔧 Useful commands (after reloading shell):"
echo "   sm-start   - Start services"
echo "   sm-stop    - Stop services"
echo "   sm-logs    - View logs"
echo "   sm-status  - Check status"
echo "   sm-backup  - Create backup"
echo "   sm-update  - Update and restart"
echo ""
echo "⚠️  IMPORTANT SECURITY NOTES:"
echo "   - Change default passwords in .env file"
echo "   - Setup SSL certificates for HTTPS"
echo "   - Configure domain name"
echo "   - Review firewall settings"
echo ""
echo "🔄 Reload shell to use aliases:"
echo "   source ~/.bashrc"
echo ""
echo "📞 Need help? Check DEPLOYMENT_GUIDE.md"
