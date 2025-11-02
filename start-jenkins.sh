#!/bin/bash

# Jenkins AI Optimizer - Docker Startup Script
# Enterprise-grade Jenkins MCP server with Qdrant vector search
# Version: 1.0.1

set -e

# Color codes for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration paths
CONFIG_DIR="config"
CONFIG_FILE="${CONFIG_DIR}/mcp-config.yml"
CONFIG_EXAMPLE="${CONFIG_DIR}/mcp-config.example.yml"
DOCKER_COMPOSE_FILE="docker-compose.yml"

# Service ports (aligned with docker-compose.yml)
QDRANT_PORT=6333
QDRANT_GRPC_PORT=6334
MCP_SERVER_PORT=3008

# Startup banner
echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║         Jenkins AI Optimizer - MCP Enterprise Server          ║"
echo "║                    v1.0.1 by karadHub                          ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Function to print colored messages
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if Docker is running
print_info "Checking Docker availability..."
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running or not accessible!"
    echo ""
    echo "Please ensure Docker Desktop is running and try again."
    exit 1
fi
print_success "Docker is running"

# Check if Docker Compose is available
if ! command -v docker-compose &> /dev/null; then
    print_error "docker-compose command not found!"
    echo ""
    echo "Please install Docker Compose and try again."
    exit 1
fi

# Validate configuration file
print_info "Validating configuration..."

if [ ! -f "${CONFIG_FILE}" ]; then
    print_error "Configuration file not found: ${CONFIG_FILE}"
    echo ""
    echo -e "${CYAN}📋 Quick Setup Instructions:${NC}"
    echo ""
    echo "1. Copy the example configuration:"
    echo -e "   ${GREEN}cp ${CONFIG_EXAMPLE} ${CONFIG_FILE}${NC}"
    echo ""
    echo "2. Edit ${CONFIG_FILE} with your Jenkins details:"
    echo "   - Add your Jenkins instance URLs"
    echo "   - Add your Jenkins API tokens (from User > Configure > API Token)"
    echo "   - Configure instance-specific settings (timeouts, SSL verification, etc.)"
    echo "   - Adjust vector search and cache settings if needed"
    echo ""
    echo "3. Run this script again:"
    echo -e "   ${GREEN}./start-jenkins.sh${NC}"
    echo ""
    print_warning "Security Note: ${CONFIG_FILE} contains credentials and is git-ignored"
    exit 1
fi

# Validate config file is not empty
if [ ! -s "${CONFIG_FILE}" ]; then
    print_error "Configuration file is empty: ${CONFIG_FILE}"
    echo ""
    echo "Please configure at least one Jenkins instance in ${CONFIG_FILE}"
    exit 1
fi

# Check if config contains default/example values
if grep -q "your-api-token-here\|jenkins.example.com\|your.username@example.com" "${CONFIG_FILE}" 2>/dev/null; then
    print_warning "Configuration appears to contain example values"
    echo ""
    echo "Please update ${CONFIG_FILE} with your actual Jenkins credentials:"
    echo "  - Replace 'jenkins.example.com' with your Jenkins URL"
    echo "  - Replace 'your.username@example.com' with your Jenkins username"
    echo "  - Replace 'your-api-token-here' with your Jenkins API token"
    echo ""
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

print_success "Configuration file validated"

# Check if Docker Compose file exists
if [ ! -f "${DOCKER_COMPOSE_FILE}" ]; then
    print_error "Docker Compose file not found: ${DOCKER_COMPOSE_FILE}"
    exit 1
fi

# Clean up any existing containers
print_info "Cleaning up any existing containers..."
docker-compose -f "${DOCKER_COMPOSE_FILE}" down --remove-orphans > /dev/null 2>&1 || true

# Build the containers
print_info "Building Docker images (this may take a few minutes)..."
if ! docker-compose -f "${DOCKER_COMPOSE_FILE}" build --no-cache; then
    print_error "Failed to build Docker images"
    exit 1
fi
print_success "Docker images built successfully"

# Start the services
print_info "Starting services..."
if ! docker-compose -f "${DOCKER_COMPOSE_FILE}" up -d; then
    print_error "Failed to start services"
    exit 1
fi

# Wait for services to become healthy
echo ""
print_info "Waiting for services to become healthy..."

# Wait for Qdrant
echo -n "   • Qdrant Vector Database: "
QDRANT_TIMEOUT=60
QDRANT_COUNTER=0
until curl -sf "http://localhost:${QDRANT_PORT}/health" > /dev/null 2>&1; do
    sleep 2
    QDRANT_COUNTER=$((QDRANT_COUNTER + 2))
    if [ ${QDRANT_COUNTER} -ge ${QDRANT_TIMEOUT} ]; then
        print_error "Qdrant failed to start within ${QDRANT_TIMEOUT} seconds"
        echo ""
        print_info "Qdrant logs:"
        docker-compose -f "${DOCKER_COMPOSE_FILE}" logs --tail=50 qdrant
        exit 1
    fi
done
print_success "Ready"

# Wait for MCP Server
echo -n "   • Jenkins MCP Server: "
MCP_TIMEOUT=90
MCP_COUNTER=0
until curl -sf "http://localhost:${MCP_SERVER_PORT}/health" > /dev/null 2>&1; do
    sleep 2
    MCP_COUNTER=$((MCP_COUNTER + 2))
    if [ ${MCP_COUNTER} -ge ${MCP_TIMEOUT} ]; then
        print_error "MCP Server failed to start within ${MCP_TIMEOUT} seconds"
        echo ""
        print_info "MCP Server logs:"
        docker-compose -f "${DOCKER_COMPOSE_FILE}" logs --tail=50 jenkins_mcp_enterprise-server
        exit 1
    fi
done
print_success "Ready"

echo ""
print_success "All services started successfully!"

# Display service information
echo ""
echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                    🌐 Service Access Points                    ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${GREEN}Qdrant Dashboard:${NC}    http://localhost:${QDRANT_PORT}/dashboard"
echo -e "  ${GREEN}Qdrant API:${NC}          http://localhost:${QDRANT_PORT}"
echo -e "  ${GREEN}MCP Server:${NC}          http://localhost:${MCP_SERVER_PORT}"
echo -e "  ${GREEN}MCP Health Check:${NC}    http://localhost:${MCP_SERVER_PORT}/health"
echo ""

# Display container status
echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                      📊 Service Status                         ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
docker-compose -f "${DOCKER_COMPOSE_FILE}" ps

# Display useful commands
echo ""
echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                     📋 Useful Commands                         ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${YELLOW}View all logs:${NC}"
echo -e "    docker-compose -f ${DOCKER_COMPOSE_FILE} logs -f"
echo ""
echo -e "  ${YELLOW}View specific service logs:${NC}"
echo -e "    docker-compose -f ${DOCKER_COMPOSE_FILE} logs -f jenkins_mcp_enterprise-server"
echo -e "    docker-compose -f ${DOCKER_COMPOSE_FILE} logs -f qdrant"
echo ""
echo -e "  ${YELLOW}Check service status:${NC}"
echo -e "    docker-compose -f ${DOCKER_COMPOSE_FILE} ps"
echo ""
echo -e "  ${YELLOW}Restart services:${NC}"
echo -e "    docker-compose -f ${DOCKER_COMPOSE_FILE} restart"
echo ""
echo -e "  ${YELLOW}Stop all services:${NC}"
echo -e "    docker-compose -f ${DOCKER_COMPOSE_FILE} down"
echo ""
echo -e "  ${YELLOW}Stop and remove volumes:${NC}"
echo -e "    docker-compose -f ${DOCKER_COMPOSE_FILE} down -v"
echo ""

# Display next steps
echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                        🚀 Next Steps                           ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "1. Configure your AI assistant to connect to the MCP server"
echo "2. Use the server for Jenkins build debugging and analysis"
echo "3. Explore the Qdrant dashboard for vector search insights"
echo ""
print_info "For detailed documentation, see: README.md and GETTING-STARTED.md"
echo ""
