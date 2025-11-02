# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2025-11-02

### 🎉 Initial Release

This is the first public release of Jenkins AI Optimizer - an enterprise-grade Model Context Protocol (MCP) server for Jenkins CI/CD integration.

### ✨ Features

#### Core Jenkins Operations
- **Multi-Instance Management**: Connect and manage multiple Jenkins servers from a single configuration
- **Build Information Retrieval**: Get comprehensive build metadata including status, duration, and artifacts
- **Job Parameter Discovery**: List and understand configurable parameters for any Jenkins job
- **Build Triggering**: Start new builds with optional parameters, both synchronously and asynchronously
- **Async Build Monitoring**: Trigger builds and monitor completion status automatically

#### Intelligent Diagnostics
- **AI-Powered Failure Analysis**: Automatic categorization of build failures using configurable regex patterns
- **Error Pattern Recognition**: Pre-configured patterns for compilation, timeout, permission, and dependency errors
- **Contextual Recommendations**: Actionable suggestions based on failure type
- **Data Extraction**: Automatically extracts error codes, version numbers, file paths, and timestamps
- **Custom Pattern Support**: Extensible diagnostic configuration for organization-specific error patterns

#### Advanced Log Analysis
- **Contextual Log Fetching**: Retrieve specific log sections with line number ranges
- **Error Filtering**: Extract error lines using pattern matching
- **Ripgrep Integration**: Fast regex search across logs with context lines
- **Interactive Navigation**: Navigate logs by sections with offset support
- **Streaming Processing**: Handle multi-gigabyte logs without memory issues

#### Vector-Powered Semantic Search
- **Natural Language Queries**: Search logs using natural language instead of exact keywords
- **Qdrant Integration**: High-performance vector database for embedding storage
- **Chunk-Based Indexing**: Efficient processing and searching of logs of any size
- **Configurable Models**: Uses `all-MiniLM-L6-v2` by default with customization options

#### Pipeline Analysis
- **Sub-Build Tree Traversal**: Automatically discovers and maps complex pipeline hierarchies
- **Recursive Discovery**: Finds all nested builds in multi-stage pipelines
- **Status Mapping**: Highlights failure points in pipeline trees
- **Build Duration Tracking**: Records execution time at each pipeline level

#### Performance & Reliability
- **Smart Caching**: Compresses and stores frequently accessed logs locally with LRU eviction
- **Automatic Cleanup**: Scheduled maintenance of cache and vector store
- **Connection Pooling**: Efficient HTTP session management with automatic retry logic
- **Health Monitoring**: Built-in health endpoints for Docker deployments
- **Configurable Timeouts**: Per-instance timeout settings for different Jenkins servers

#### Developer Experience
- **FastMCP Framework**: Built on modern async Python with FastAPI
- **Multiple Transport Modes**: Supports both stdio and HTTP/SSE transports
- **Dependency Injection**: Clean architecture with testable components
- **Comprehensive Logging**: Configurable logging levels with structured output
- **Docker Support**: Production-ready Docker Compose deployment
- **Configuration Validation**: Automatic validation of YAML configuration files

### 🏗️ Architecture

- **MCP Server**: FastMCP-based server with HTTP/SSE and stdio transport
- **Tool Factory**: Dynamic tool instantiation with dependency injection
- **Multi-Jenkins Manager**: Intelligent routing to appropriate Jenkins instances
- **Cache Manager**: Local filesystem cache with compression and LRU eviction
- **Vector Manager**: Qdrant client for semantic search operations
- **Cleanup Scheduler**: APScheduler-based maintenance tasks

### 📦 Available Tools

1. `diagnose_build_failure` - AI-powered build failure analysis
2. `get_build_info` - Comprehensive build metadata retrieval
3. `get_job_parameters` - List configurable job parameters
4. `trigger_build` - Start builds with parameters
5. `trigger_build_async` - Async build triggering with monitoring
6. `get_log_context` - Fetch specific log sections
7. `filter_errors` - Extract error lines from logs
8. `ripgrep_search` - Fast regex search across logs
9. `navigate_log` - Interactive log navigation
10. `search_logs_semantic` - Vector-based semantic search
11. `get_sub_build_tree` - Pipeline hierarchy traversal

### 🐳 Deployment Options

- **Docker Compose**: Production-ready deployment with Qdrant
- **Local Development**: Virtual environment with pip installation
- **Claude Desktop Integration**: Direct MCP connection via SSE

### 📚 Documentation

- Comprehensive README with architecture diagrams
- Detailed configuration guides
- Docker deployment instructions
- Diagnostic pattern documentation
- API usage examples
- Troubleshooting guides

### 🔧 Configuration

- YAML-based configuration for Jenkins instances
- Per-instance settings (timeouts, SSL verification, log size limits)
- Diagnostic pattern customization
- Vector search configuration
- Cache management settings
- Cleanup scheduling options

### 🧪 Testing

- Integration tests with real Jenkins instances
- MCP protocol validation tests
- Performance benchmarks
- Tool scenario testing
- Error handling validation

### 📝 Requirements

- Python 3.10 or higher
- Docker and Docker Compose (for production deployment)
- Jenkins instance(s) with REST API access
- Jenkins API token(s)
- Qdrant (included in Docker Compose, optional for local dev)

### 🔐 Security

- Token-based authentication for Jenkins
- Per-instance SSL verification settings
- No credentials stored in code
- Configuration file-based secret management
- GPL v3.0 license

### 🙏 Acknowledgments

- FastMCP for modern MCP server framework
- Qdrant for high-performance vector database
- Anthropic for Model Context Protocol specification
- Jenkins Community for robust CI/CD platform

---

## [Unreleased]

### Planned Features
- GitHub Actions integration
- GitLab CI/CD support
- Enhanced AI diagnostics with LLM integration
- Build artifact analysis
- Performance metrics dashboard
- Webhook support for real-time updates

---

[1.0.1]: https://github.com/karadHub/jenkins-ai-optimizer/releases/tag/v1.0.1
