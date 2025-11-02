# Jenkins AI Optimizer

[![PyPI version](https://badge.fury.io/py/jenkins-ai-optimizer.svg)](https://badge.fury.io/py/jenkins-ai-optimizer)
[![Python 3.10+](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/downloads/)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![MCP Compatible](https://img.shields.io/badge/MCP-Compatible-green.svg)](https://modelcontextprotocol.io)

> **Enterprise-grade Model Context Protocol (MCP) server for Jenkins CI/CD integration** — Empowering AI assistants with deep Jenkins insights, intelligent build diagnostics, and semantic log analysis.

Transform how you interact with Jenkins through AI. This production-ready MCP server enables AI assistants like Claude to understand your Jenkins environment, diagnose build failures, analyze complex pipelines, and search massive logs—all through natural conversation.

## 🚀 Quick Install

```bash
pip install jenkins-ai-optimizer
```

**See [Quick Start](#quick-start) for complete setup instructions.**

---

## Table of Contents

- [Installation](#-quick-install)
- [Overview](#overview)
- [Key Features](#key-features)
- [Architecture](#architecture)
- [Quick Start](#quick-start)
  - [Prerequisites](#prerequisites)
  - [Docker Deployment (Recommended)](#docker-deployment-recommended)
  - [Local Development Setup](#local-development-setup)
- [Configuration](#configuration)
- [Available Tools](#available-tools)
- [Usage Examples](#usage-examples)
- [Advanced Features](#advanced-features)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [Troubleshooting](#troubleshooting)
- [License](#license)

---

## Overview

**Jenkins AI Optimizer** is a sophisticated MCP (Model Context Protocol) server that bridges AI assistants with Jenkins CI/CD infrastructure. Unlike simple API wrappers, this server provides:

- **Intelligent failure diagnosis** using configurable error pattern recognition
- **Multi-instance Jenkins management** with automatic credential resolution
- **Semantic log search** powered by vector embeddings (Qdrant)
- **Deep pipeline analysis** including complex sub-build tree traversal
- **Enterprise-grade caching** with compression and intelligent cleanup
- **Real-time streaming** capabilities for large log processing

### What is MCP?

[Model Context Protocol](https://modelcontextprotocol.io) is an open standard that enables AI assistants to securely connect to external tools and data sources. This server implements MCP to expose Jenkins functionality to AI assistants, allowing them to interact with your CI/CD infrastructure intelligently.

### Why Jenkins AI Optimizer?

**Traditional Approach:**

```
Developer → Jenkins UI → Browse jobs → Find failed build →
Download logs → Search manually → Google errors → Debug
⏱️ Time: 30-60 minutes per failure
```

**With Jenkins AI Optimizer:**

```
Developer → Ask AI: "Why did my build fail?" →
AI analyzes automatically → Get actionable diagnosis
⏱️ Time: 10-30 seconds
```

---

## Key Features

### 🔍 **Intelligent Diagnostics**

- **AI-Powered Failure Analysis**: Automatically categorizes build failures using configurable regex patterns
- **Error Pattern Recognition**: Pre-configured patterns for compilation, timeout, permission, and dependency errors
- **Contextual Recommendations**: Provides actionable suggestions based on failure type
- **Data Extraction**: Automatically extracts error codes, version numbers, file paths, and timestamps

### 🏢 **Multi-Jenkins Management**

- **Centralized Configuration**: Manage multiple Jenkins instances from a single config file
- **Automatic Credential Resolution**: Routes requests to the correct Jenkins instance based on job URLs
- **Instance Health Monitoring**: Tracks availability and performance of each Jenkins server
- **Flexible Authentication**: Supports individual API tokens and SSL verification per instance

### 🧠 **Vector-Powered Search**

- **Semantic Log Search**: Find relevant log sections using natural language queries
- **Qdrant Integration**: High-performance vector database for embedding storage
- **Chunk-Based Indexing**: Efficiently processes and searches logs of any size
- **Configurable Embedding Models**: Defaults to `all-MiniLM-L6-v2` with options for customization

### 🚀 **Performance & Scalability**

- **Streaming Log Processing**: Handles multi-gigabyte logs without memory issues
- **Smart Caching**: Compresses and stores frequently accessed logs locally
- **Parallel Build Analysis**: Process multiple pipeline branches concurrently
- **Automatic Cleanup**: Scheduled maintenance of cache and vector store
- **Connection Pooling**: Efficient HTTP session management with retry logic

### 🛠️ **Developer Experience**

- **FastMCP Framework**: Built on modern async Python with FastAPI
- **Comprehensive Tool Set**: 10+ specialized tools for different Jenkins operations
- **Dependency Injection**: Clean architecture with testable components
- **Health Endpoints**: Built-in monitoring for Docker deployments
- **Extensive Logging**: Configurable logging levels with structured output

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        AI Assistant (Claude)                     │
│                     Natural Language Interface                   │
└───────────────────────────┬─────────────────────────────────────┘
                            │ MCP Protocol (SSE/stdio)
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Jenkins MCP Enterprise Server                 │
│  ┌──────────────┐  ┌──────────────┐  ┌─────────────────────┐   │
│  │ Tool Factory │  │ DI Container │  │ Multi-Jenkins Mgr   │   │
│  └──────────────┘  └──────────────┘  └─────────────────────┘   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │              Tool Registry (10+ Tools)                   │   │
│  │  • Diagnostics  • Logs       • Search   • Subbuilds     │   │
│  │  • Trigger      • Parameters • Ripgrep  • Navigation    │   │
│  └──────────────────────────────────────────────────────────┘   │
│  ┌──────────────┐  ┌──────────────┐  ┌─────────────────────┐   │
│  │ Cache Mgr    │  │ Vector Mgr   │  │ Cleanup Scheduler   │   │
│  └──────────────┘  └──────────────┘  └─────────────────────┘   │
└───────┬──────────────────────────────────────┬─────────────────┘
        │                                       │
        ▼                                       ▼
┌──────────────────────┐            ┌────────────────────────┐
│   Jenkins Instances  │            │   Qdrant Vector DB     │
│  • Production        │            │  • Semantic Search     │
│  • Staging           │            │  • Log Embeddings      │
│  • Development       │            │  • 6333 (HTTP/REST)    │
│  • API: REST/JSON    │            │  • 6334 (gRPC)         │
└──────────────────────┘            └────────────────────────┘
```

**Component Breakdown:**

- **FastMCP Server**: HTTP/SSE and stdio transport support
- **Tool Factory**: Dynamic tool instantiation with dependency injection
- **DI Container**: Manages lifecycle of Jenkins clients, caches, and managers
- **Multi-Jenkins Manager**: Routes requests to appropriate Jenkins instance
- **Cache Manager**: Local filesystem cache with LRU eviction and compression
- **Vector Manager**: Qdrant client for semantic search operations
- **Cleanup Scheduler**: APScheduler-based maintenance tasks

---

## Quick Start

### Prerequisites

- **Python 3.10+** (for local development)
- **Docker & Docker Compose** (for production deployment)
- **Jenkins instance(s)** with REST API access
- **Jenkins API Token(s)** - [How to generate →](https://www.jenkins.io/doc/book/system-administration/authenticating-scripted-clients/)

### Docker Deployment (Recommended)

**1. Clone the repository:**

```bash
git clone https://github.com/karadHub/jenkins-ai-optimizer.git
cd jenkins-ai-optimizer
```

**2. Configure Jenkins instances:**

```bash
# Copy example configuration
cp config/mcp-config.example.yml config/mcp-config.yml

# Edit with your Jenkins credentials
# Windows: notepad config/mcp-config.yml
# Linux/Mac: nano config/mcp-config.yml
```

**Example configuration:**

```yaml
jenkins_instances:
  production:
    url: "https://jenkins.company.com"
    username: "your.email@company.com"
    token: "11a1b2c3d4e5f6789012345678901234" # From Jenkins: User → Configure → API Token
    display_name: "Production Jenkins"
    timeout: 30
    verify_ssl: true
    max_log_size: 100000000 # 100MB

  staging:
    url: "https://jenkins-staging.company.com"
    username: "your.email@company.com"
    token: "another-api-token-here"
    display_name: "Staging Environment"
    timeout: 30
    verify_ssl: true

default_instance:
  id: "production"

vector:
  disable_vector_search: false
  host: "http://qdrant:6333"
  collection_name: "jenkins-logs"
  embedding_model: "all-MiniLM-L6-v2"
```

**3. Start the services:**

```bash
# Linux/Mac
./start-jenkins.sh

# Windows (PowerShell)
docker-compose up -d
```

**4. Verify deployment:**

```bash
# Check service health
curl http://localhost:3008/health
# Expected: OK

# Check Qdrant
curl http://localhost:6333/health
# Expected: {"title":"qdrant - vector search engine","version":"..."}

# View logs
docker-compose logs -f jenkins_mcp_enterprise-server
```

**Access Points:**

- MCP Server: `http://localhost:3008`
- MCP SSE Endpoint: `http://localhost:3008/sse`
- Health Check: `http://localhost:3008/health`
- Qdrant Dashboard: `http://localhost:6333/dashboard`
- Qdrant API: `http://localhost:6333`

### Local Development Setup

```bash
# Create virtual environment
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Install in editable mode with dev tools
pip install -e .[dev]

# Configure (same as Docker setup)
cp config/mcp-config.example.yml config/mcp-config.yml
# Edit config/mcp-config.yml with your Jenkins details

# Start Qdrant separately (optional, for vector search)
docker run -p 6333:6333 -p 6334:6334 qdrant/qdrant:latest

# Run the server
python -m jenkins_mcp_enterprise.server --transport stdio --config config/mcp-config.yml

# Or with HTTP transport
python -m jenkins_mcp_enterprise.server --transport http --config config/mcp-config.yml
```

---

## Configuration

### Configuration Files

| File                               | Purpose                                                      | Required              |
| ---------------------------------- | ------------------------------------------------------------ | --------------------- |
| `config/mcp-config.yml`            | Main configuration (Jenkins instances, vector search, cache) | ✅ Yes                |
| `config/diagnostic-parameters.yml` | Error patterns for failure analysis                          | ✅ Yes (bundled)      |
| `docker-compose.yml`               | Docker service orchestration                                 | For Docker deployment |
| `pyproject.toml`                   | Python package metadata and dependencies                     | For development       |

### Environment Variables

| Variable                | Default                 | Description                                     |
| ----------------------- | ----------------------- | ----------------------------------------------- |
| `QDRANT_HOST`           | `http://localhost:6333` | Qdrant vector database URL                      |
| `CACHE_DIR`             | `/tmp/mcp-jenkins`      | Local cache directory path                      |
| `LOG_LEVEL`             | `INFO`                  | Logging verbosity (DEBUG, INFO, WARNING, ERROR) |
| `UVICORN_HOST`          | `0.0.0.0`               | HTTP server bind address (Docker mode)          |
| `UVICORN_PORT`          | `8000`                  | HTTP server port (mapped to 3008 in Docker)     |
| `DISABLE_VECTOR_SEARCH` | `false`                 | Disable Qdrant integration if true              |

### Multi-Instance Configuration

Configure multiple Jenkins servers for centralized management:

```yaml
jenkins_instances:
  prod-main:
    url: "https://jenkins-prod.company.com"
    username: "ci-bot@company.com"
    token: "prod-token-here"
    display_name: "Production Main"
    description: "Primary production Jenkins"
    timeout: 30
    verify_ssl: true
    max_log_size: 104857600 # 100MB
    default_timeout: 120

  prod-backup:
    url: "https://jenkins-prod-dr.company.com"
    username: "ci-bot@company.com"
    token: "prod-backup-token"
    display_name: "Production DR"
    timeout: 30
    verify_ssl: true

  staging:
    url: "https://jenkins-staging.company.com"
    username: "dev-bot@company.com"
    token: "staging-token"
    display_name: "Staging"
    timeout: 20
    verify_ssl: false # Self-signed cert

settings:
  fallback_instance: "prod-main"
  enable_health_checks: true
  health_check_interval: 300 # 5 minutes
```

### Diagnostic Patterns

Customize error detection in `jenkins_mcp_enterprise/diagnostic_config/diagnostic-parameters.yml`:

```yaml
error_patterns:
  compilation:
    - pattern: "error: .* undeclared"
      severity: high
      category: "Compilation Error"
      guidance: "Check for missing imports or variable declarations"

  timeout:
    - pattern: "timeout|timed out|took too long"
      severity: medium
      category: "Timeout"
      guidance: "Increase timeout values or investigate performance bottlenecks"

  permission:
    - pattern: "permission denied|access denied|403 Forbidden"
      severity: high
      category: "Permission Error"
      guidance: "Verify service account permissions and file access rights"
```

See [`config/README-diagnostic-config.md`](config/README-diagnostic-config.md) for complete documentation.

---

## Available Tools

The MCP server exposes the following tools to AI assistants:

### Core Jenkins Operations

| Tool                     | Description                                       | Key Parameters                                  |
| ------------------------ | ------------------------------------------------- | ----------------------------------------------- |
| `diagnose_build_failure` | Analyzes build failures using AI pattern matching | `job_name`, `build_number`, `instance_id`       |
| `get_build_info`         | Retrieves comprehensive build metadata            | `job_name`, `build_number`, `instance_id`       |
| `get_job_parameters`     | Lists configurable parameters for a job           | `job_name`, `instance_id`                       |
| `trigger_build`          | Initiates a new build with optional parameters    | `job_name`, `parameters`, `instance_id`         |
| `trigger_build_async`    | Starts build and monitors completion              | `job_name`, `parameters`, `wait_for_completion` |

### Log Analysis

| Tool              | Description                                  | Key Parameters                                         |
| ----------------- | -------------------------------------------- | ------------------------------------------------------ |
| `get_log_context` | Fetches log sections with line number ranges | `job_name`, `build_number`, `start_line`, `num_lines`  |
| `filter_errors`   | Extracts error lines using pattern matching  | `job_name`, `build_number`, `pattern`                  |
| `ripgrep_search`  | Fast regex search across logs                | `job_name`, `build_number`, `pattern`, `context_lines` |
| `navigate_log`    | Interactive log navigation with sections     | `job_name`, `build_number`, `section`, `offset`        |

### Advanced Features

| Tool                   | Description                            | Key Parameters                          |
| ---------------------- | -------------------------------------- | --------------------------------------- |
| `search_logs_semantic` | Vector-based semantic log search       | `query`, `top_k`, `instance_id`         |
| `get_sub_build_tree`   | Traverses complex pipeline hierarchies | `job_name`, `build_number`, `max_depth` |

### Example Tool Usage (via AI Assistant)

**User:** "Why did the Deploy-Production job build #47 fail?"

**AI Assistant calls:**

```python
diagnose_build_failure(
    job_name="Deploy-Production",
    build_number=47,
    instance_id="production"  # Auto-resolved if only one instance
)
```

**AI receives structured response:**

```json
{
  "build_info": {
    "job_name": "Deploy-Production",
    "build_number": 47,
    "status": "FAILURE",
    "duration_ms": 342500
  },
  "failure_analysis": {
    "category": "Timeout",
    "severity": "medium",
    "matched_patterns": ["Connection timeout after 300 seconds"],
    "guidance": "Increase timeout values or investigate network connectivity",
    "extracted_data": {
      "timeout_value": "300",
      "service": "database-prod.company.internal"
    }
  },
  "recommendations": [
    "Check database server health and response times",
    "Verify network connectivity to database-prod.company.internal",
    "Consider increasing connection timeout in deployment configuration"
  ]
}
```

---

## Usage Examples

### With Claude Desktop

**1. Configure Claude Desktop:**

Edit `%APPDATA%\Claude\claude_desktop_config.json` (Windows) or `~/Library/Application Support/Claude/claude_desktop_config.json` (Mac):

```json
{
  "mcpServers": {
    "jenkins-optimizer": {
      "url": "http://localhost:3008/sse"
    }
  }
}
```

**2. Restart Claude Desktop**

**3. Start conversations:**

> **User:** "List all my Jenkins jobs"
>
> **Claude:** _[Uses MCP to fetch and format job list]_

> **User:** "Why did Windows_Health_Check build #2 fail?"
>
> **Claude:** _[Calls diagnose_build_failure, analyzes logs, provides detailed diagnosis]_

> **User:** "Find all timeout errors in recent builds"
>
> **Claude:** _[Uses semantic_search to find relevant failures]_

> **User:** "Show me the sub-build tree for Main-Pipeline #15"
>
> **Claude:** _[Traverses pipeline hierarchy and displays tree structure]_

### Direct API Usage

```python
import requests

# Health check
response = requests.get("http://localhost:3008/health")
print(response.text)  # "OK"

# Call tools via MCP protocol (requires MCP client library)
from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client

async def diagnose_build():
    server_params = StdioServerParameters(
        command="python",
        args=["-m", "jenkins_mcp_enterprise.server", "--transport", "stdio"]
    )

    async with stdio_client(server_params) as (read, write):
        async with ClientSession(read, write) as session:
            await session.initialize()

            result = await session.call_tool(
                "diagnose_build_failure",
                arguments={
                    "job_name": "Deploy-Production",
                    "build_number": 47
                }
            )
            print(result)
```

---

## Advanced Features

### Semantic Log Search

Vector-powered search allows natural language queries:

```yaml
# Enable in config/mcp-config.yml
vector:
  disable_vector_search: false
  host: "http://qdrant:6333"
  collection_name: "jenkins-logs"
  embedding_model: "all-MiniLM-L6-v2"
  chunk_size: 50 # Lines per chunk
  chunk_overlap: 5
  top_k_default: 5
```

**Usage through AI:**

- "Find connection timeout errors"
- "Show me database migration failures"
- "What builds had out of memory issues?"

### Custom Diagnostic Patterns

Add organization-specific error patterns:

```yaml
# In diagnostic-parameters.yml
error_patterns:
  custom_service:
    - pattern: 'ServiceX: ERROR \[(?P<code>\d+)\]'
      severity: high
      category: "ServiceX Failure"
      guidance: "Check ServiceX documentation for error code {code}"
      extract_fields:
        - error_code: '\[(\d+)\]'
        - service_name: "(ServiceX)"
```

### Pipeline Sub-Build Analysis

Automatically discovers and maps complex pipeline structures:

```python
# Through AI assistant
"Analyze the complete build tree for Main-Pipeline build #150,
including all sub-builds and their status"

# Returns hierarchical tree with:
# - Build status at each level
# - Failure points highlighted
# - Build durations
# - Artifact locations
```

### Intelligent Caching

Automatic caching with compression:

```yaml
cache:
  cache_dir: "/tmp/mcp-jenkins"
  max_size_mb: 1000 # 1GB total cache
  retention_days: 7
  compression: true # gzip compression for logs
```

**Cache Benefits:**

- 10x faster repeated log access
- Reduced Jenkins server load
- Offline analysis capability

### Scheduled Cleanup

Automatic maintenance runs daily:

```yaml
cleanup:
  interval_hours: 24
  retention_days: 7
  max_concurrent: 5 # Parallel cleanup tasks
```

---

## Documentation

| Document                                                                   | Description                                                     |
| -------------------------------------------------------------------------- | --------------------------------------------------------------- |
| [`GETTING-STARTED.md`](GETTING-STARTED.md)                                 | Detailed setup guide with examples                              |
| [`PROJECT.md`](PROJECT.md)                                                 | Architecture, development workflow, and contribution guidelines |
| [`config/README.md`](config/README.md)                                     | Configuration file reference                                    |
| [`config/README-diagnostic-config.md`](config/README-diagnostic-config.md) | Diagnostic pattern documentation                                |
| [`README-Docker.md`](README-Docker.md)                                     | Docker deployment details                                       |
| [`MONITORING-AND-ACCESS.md`](MONITORING-AND-ACCESS.md)                     | Operational monitoring guide                                    |

---

## Contributing

We welcome contributions! Please see our [Code of Conduct](CODE_OF_CONDUCT.md) and [`PROJECT.md`](PROJECT.md) for development workflow and coding standards.

### Development Setup

```bash
# Clone and setup
git clone https://github.com/karadHub/jenkins-ai-optimizer.git
cd jenkins-ai-optimizer

# Create environment
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Install with dev dependencies
pip install -e .[dev]

# Run tests
pytest

# Run linting
ruff check .

# Format code
ruff format .
```

### Pull Request Process

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Make changes with tests
4. Ensure all tests pass: `pytest`
5. Lint your code: `ruff check .`
6. Commit with conventional commits: `feat(diagnostics): add new error pattern`
7. Push and create Pull Request

---

## Troubleshooting

### Server Won't Start

```bash
# Check Docker containers
docker-compose ps

# View server logs
docker-compose logs jenkins_mcp_enterprise-server

# Common issues:
# 1. Port 3008 in use → Change in docker-compose.yml
# 2. Config file missing → Copy from config/mcp-config.example.yml
# 3. Invalid Jenkins credentials → Verify token in Jenkins
```

### Vector Search Not Working

```bash
# Check Qdrant health
curl http://localhost:6333/health

# Verify Qdrant container
docker-compose logs qdrant

# Check configuration
# Ensure DISABLE_VECTOR_SEARCH=false in docker-compose.yml
# Verify QDRANT_HOST=http://qdrant:6333
```

### Connection to Jenkins Fails

```bash
# Test Jenkins API manually
curl -u "username:token" https://your-jenkins.com/api/json

# Common issues:
# 1. Incorrect URL → Verify in config/mcp-config.yml
# 2. Invalid token → Regenerate in Jenkins → User → Configure → API Token
# 3. SSL certificate issues → Set verify_ssl: false (staging only!)
# 4. Firewall blocking → Check network connectivity
```

### AI Assistant Not Connecting

**Claude Desktop:**

```bash
# Check server health
curl http://localhost:3008/health

# Verify Claude config file location:
# Windows: %APPDATA%\Claude\claude_desktop_config.json
# Mac: ~/Library/Application Support/Claude/claude_desktop_config.json

# Check Claude Desktop logs
# Windows: %APPDATA%\Claude\logs\
# Mac: ~/Library/Logs/Claude/

# Ensure MCP server URL is correct: http://localhost:3008/sse
```

### Performance Issues

```bash
# Monitor resource usage
docker stats jenkins_mcp_enterprise-server-1

# Check cache size
du -sh /tmp/mcp-jenkins  # Linux/Mac
# Windows: Check Docker volume size

# Optimize:
# 1. Reduce cache retention: retention_days: 3
# 2. Lower max_log_size: max_log_size: 50000000 (50MB)
# 3. Disable vector search if unused: disable_vector_search: true
```

---

## License

This project is licensed under the **GNU General Public License v3.0** - see the [LICENSE](LICENSE) file for details.

### Key Points:

- ✅ Free to use, modify, and distribute
- ✅ Must disclose source code when distributing
- ✅ Must use same GPL-3.0 license for derivatives
- ❌ No warranty provided

---

## Acknowledgments

- **FastMCP** - Modern MCP server framework
- **Qdrant** - High-performance vector database
- **Anthropic** - Model Context Protocol specification and Claude AI
- **Jenkins Community** - Robust CI/CD platform

### Special Thanks

This project was developed with assistance from **Claude AI** (Anthropic), demonstrating the power of AI-assisted development in creating production-ready tools.

---

## Contributing

We welcome contributions! Here's how you can help:

### Ways to Contribute

- 🐛 **Report bugs** via [GitHub Issues](https://github.com/karadHub/jenkins-ai-optimizer/issues)
- 💡 **Suggest features** or improvements
- 📖 **Improve documentation**
- 🔧 **Submit pull requests** with bug fixes or features
- ⭐ **Star the repository** to show your support
- 📣 **Share** with others who might find it useful

### Development Process

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Make your changes with tests
4. Ensure all tests pass: `pytest`
5. Lint your code: `ruff check .`
6. Format code: `ruff format .`
7. Commit with conventional commits: `feat(diagnostics): add new error pattern`
8. Push and create a Pull Request

See [PROJECT.md](PROJECT.md) for detailed development guidelines and [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) for community standards.

---

## Support

- **Issues**: [GitHub Issues](https://github.com/karadHub/jenkins-ai-optimizer/issues)
- **Discussions**: [GitHub Discussions](https://github.com/karadHub/jenkins-ai-optimizer/discussions)
- **Code of Conduct**: [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)
- **Documentation**: See [Documentation](#documentation) section above for detailed guides

---

**Built with ❤️ for DevOps engineers who deserve better debugging tools.**

_Stop spending hours hunting through Jenkins logs. Let AI do the heavy lifting._
