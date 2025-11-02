# Environment Variables Setup Guide

This guide explains how to securely configure your Jenkins API token using environment variables.

## Quick Setup

### Step 1: Copy the Example File

```bash
# Copy .env.example to .env
cp .env.example .env
```

### Step 2: Get Your Jenkins API Token

1. Log into your Jenkins instance
2. Click your username (top right corner)
3. Click **"Configure"**
4. Scroll down to **"API Token"** section
5. Click **"Add new Token"**
6. Give it a name (e.g., "MCP Server")
7. Click **"Generate"**
8. **Copy the token** (you can only see it once!)

### Step 3: Add Token to .env File

Edit the `.env` file and paste your token:

```bash
# .env file
JENKINS_TOKEN=11a1b2c3d4e5f6789012345678901234
```

### Step 4: Verify Configuration

Your `config/mcp-config.yml` should reference the environment variable:

```yaml
jenkins_instances:
  production:
    url: "http://172.26.128.1:8080"
    username: "jenkins"
    token: "${JENKINS_TOKEN}" # <-- This fetches from .env
```

## How It Works

The system automatically loads environment variables from the `.env` file when it starts:

1. **Startup**: Server loads `.env` file using `python-dotenv`
2. **Config Parsing**: When reading `mcp-config.yml`, variables like `${JENKINS_TOKEN}` are replaced
3. **Runtime**: The actual token value is used to authenticate with Jenkins

### Environment Variable Syntax

In your YAML config files, use this syntax to reference environment variables:

```yaml
token: "${JENKINS_TOKEN}"
url: "${JENKINS_URL}"
username: "${JENKINS_USER}"
```

## Security Best Practices

### ✅ DO:

- ✅ Keep `.env` file local (it's already in `.gitignore`)
- ✅ Use different tokens for different environments (dev, staging, prod)
- ✅ Rotate tokens periodically
- ✅ Use restrictive permissions on Jenkins API tokens
- ✅ Use `.env.example` as a template (safe to commit)

### ❌ DON'T:

- ❌ Commit `.env` file to git (it's git-ignored)
- ❌ Share your `.env` file with others
- ❌ Put tokens directly in `mcp-config.yml`
- ❌ Use admin tokens (create dedicated tokens with minimal permissions)

## Multiple Environment Variables

You can override multiple configuration values:

```bash
# .env
JENKINS_TOKEN=your-token-here
JENKINS_URL=http://172.26.128.1:8080
JENKINS_USERNAME=jenkins
QDRANT_HOST=http://qdrant:6333
LOG_LEVEL=DEBUG
CACHE_DIR=/tmp/mcp-jenkins
```

Then reference them in your config:

```yaml
jenkins_instances:
  production:
    url: "${JENKINS_URL}"
    username: "${JENKINS_USERNAME}"
    token: "${JENKINS_TOKEN}"
```

## Docker Deployment

When using Docker, environment variables are passed differently:

### Option 1: Docker Compose (Recommended)

Edit `docker-compose.yml`:

```yaml
services:
  jenkins_mcp_enterprise-server:
    environment:
      - JENKINS_TOKEN=${JENKINS_TOKEN}
    env_file:
      - .env # Automatically loads .env file
```

### Option 2: Command Line

```bash
docker-compose --env-file .env up -d
```

## Troubleshooting

### Problem: "No token for Jenkins instance"

**Solution**: Verify your `.env` file exists and contains `JENKINS_TOKEN=your-token`

```bash
# Check if .env exists
ls -la .env

# View .env content (be careful not to expose it!)
cat .env
```

### Problem: Token not being loaded

**Cause**: Environment variable syntax incorrect in YAML

**Solution**: Use `"${JENKINS_TOKEN}"` with quotes and exact syntax

```yaml
# ✅ Correct
token: "${JENKINS_TOKEN}"

# ❌ Wrong
token: $JENKINS_TOKEN
token: {JENKINS_TOKEN}
token: "${JENKINS_TOKEN"
```

### Problem: "Environment variable JENKINS_TOKEN not set"

**Solution**:

1. Check `.env` file has the variable defined
2. Ensure no spaces around `=`: `JENKINS_TOKEN=value` not `JENKINS_TOKEN = value`
3. Restart the server after modifying `.env`

### Problem: Works locally but not in Docker

**Solution**: Docker needs environment variables passed explicitly

```yaml
# docker-compose.yml
services:
  jenkins_mcp_enterprise-server:
    env_file:
      - .env
    environment:
      - JENKINS_TOKEN=${JENKINS_TOKEN}
```

## Testing Your Configuration

### 1. Verify .env is loaded:

```python
# test_env.py
import os
from dotenv import load_dotenv

load_dotenv()
token = os.getenv('JENKINS_TOKEN')
print(f"Token loaded: {'Yes' if token else 'No'}")
print(f"Token length: {len(token) if token else 0}")
```

Run: `python test_env.py`

### 2. Test Jenkins connection:

```bash
# Using curl
curl -u "jenkins:${JENKINS_TOKEN}" http://172.26.128.1:8080/api/json
```

### 3. Check server startup logs:

```bash
docker-compose logs jenkins_mcp_enterprise-server | grep -i "token\|jenkins\|loaded"
```

## Advanced: Multiple Jenkins Instances

You can use different tokens for different instances:

```bash
# .env
JENKINS_PROD_TOKEN=prod-token-here
JENKINS_STAGING_TOKEN=staging-token-here
JENKINS_DEV_TOKEN=dev-token-here
```

```yaml
# config/mcp-config.yml
jenkins_instances:
  production:
    url: "https://jenkins-prod.company.com"
    token: "${JENKINS_PROD_TOKEN}"

  staging:
    url: "https://jenkins-staging.company.com"
    token: "${JENKINS_STAGING_TOKEN}"

  development:
    url: "http://jenkins-dev.local:8080"
    token: "${JENKINS_DEV_TOKEN}"
```

## Example Complete Setup

Here's a full working example:

**1. .env file:**

```bash
JENKINS_TOKEN=11a1b2c3d4e5f6789012345678901234
LOG_LEVEL=INFO
```

**2. config/mcp-config.yml:**

```yaml
jenkins_instances:
  production:
    url: "http://172.26.128.1:8080"
    username: "jenkins"
    token: "${JENKINS_TOKEN}"
    display_name: "Jenkins Production"
    timeout: 30
    verify_ssl: true

default_instance:
  url: "http://172.26.128.1:8080"
  username: "jenkins"
  token: "${JENKINS_TOKEN}"
  timeout: 30
  verify_ssl: true

vector:
  disable_vector_search: false
  host: "http://qdrant:6333"

settings:
  fallback_instance: "production"
```

**3. Start the server:**

```bash
./start-jenkins.sh
```

**4. Verify it works:**

```bash
curl http://localhost:3008/health
# Expected: OK
```

## Need Help?

- Check server logs: `docker-compose logs -f jenkins_mcp_enterprise-server`
- Verify environment: `docker-compose exec jenkins_mcp_enterprise-server env | grep JENKINS`
- Test Jenkins API: Use the curl command above with your credentials

## Reference

- **python-dotenv**: [https://github.com/theskumar/python-dotenv](https://github.com/theskumar/python-dotenv)
- **Jenkins API Token**: [https://www.jenkins.io/doc/book/system-administration/authenticating-scripted-clients/](https://www.jenkins.io/doc/book/system-administration/authenticating-scripted-clients/)
