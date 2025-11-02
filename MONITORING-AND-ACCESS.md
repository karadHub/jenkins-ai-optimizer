# Monitoring & Access Guide

## 🌐 URLs and Endpoints Reference

This guide shows you how to access all services, view logs, and monitor your Jenkins AI Optimizer system.

---

## 📍 Service URLs

### Jenkins Server

- **URL:** http://172.26.128.1:8080
- **Username:** jenkins
- **Access:** Web browser
- **Description:** Your main Jenkins instance

**Quick Access:**

```powershell
# Open in browser
Start-Process "http://172.26.128.1:8080"
```

---

### MCP Server

- **Health Check:** http://localhost:3008/health
- **Port:** 3008
- **Transport:** STDIO (via docker exec)
- **Description:** FastMCP server for Claude Desktop

**Test Health:**

```powershell
curl http://localhost:3008/health
# Expected response: OK
```

---

### Qdrant Vector Database

- **Dashboard:** http://localhost:6333/dashboard
- **API:** http://localhost:6333
- **Port:** 6333
- **Description:** Vector database for semantic log search

**Quick Access:**

```powershell
# Open dashboard in browser
Start-Process "http://localhost:6333/dashboard"
```

**API Health Check:**

```powershell
curl http://localhost:6333/healthz
```

---

## 📊 Qdrant Dashboard - What You'll See

### Accessing the Dashboard

1. Open browser: http://localhost:6333/dashboard
2. You'll see the Qdrant web interface

### Main Features

#### 1. **Collections View**

Shows all vector collections:

**Collection:** `jenkins-logs`

- **Purpose:** Stores embedded Jenkins console logs for semantic search
- **Vectors:** Log chunks converted to 384-dimensional embeddings
- **Model:** `all-MiniLM-L6-v2`
- **Status:** Should show as "Green" when healthy

#### 2. **Collection Details**

Click on `jenkins-logs` to see:

```
Collection: jenkins-logs
├── Vectors count: [Number of indexed log chunks]
├── Points count: [Total data points]
├── Indexed vectors: [How many are searchable]
├── Dimensions: 384
├── Distance: Cosine
└── Status: Green
```

#### 3. **Search Console**

You can test semantic search directly:

**Example Query:**

```json
{
  "vector": [0.1, 0.2, ...],  // 384 dimensions
  "limit": 5,
  "with_payload": true
}
```

**Payload Structure:**
Each stored log chunk contains:

```json
{
  "job_name": "Java_System_Info",
  "build_number": 1,
  "chunk_text": "ERROR: Connection timeout...",
  "line_start": 145,
  "line_end": 160,
  "timestamp": "2025-10-30T09:03:48Z"
}
```

#### 4. **Monitoring Metrics**

- **Memory usage:** How much RAM Qdrant is using
- **Disk usage:** Storage for vectors
- **Operations:** Number of search/insert operations
- **Performance:** Query latency

---

## 📂 Log Locations

### Docker Container Logs

#### MCP Server Logs

```powershell
# View live logs
docker logs jenkins_mcp_enterprise-server -f

# Last 100 lines
docker logs jenkins_mcp_enterprise-server --tail 100

# Logs since 1 hour ago
docker logs jenkins_mcp_enterprise-server --since 1h
```

**What you'll see:**

- Server startup messages
- Jenkins connection status
- Tool registrations
- Build analysis activities
- Error patterns detected

**Example Log Entry:**

```
2025-10-30 09:03:42,907 - jenkins_mcp.jenkins.connection - INFO -
Connected to Jenkins as: {'fullName': 'VK', 'id': 'jenkins'}

2025-10-30 09:03:43,109 - jenkins_mcp.vector_manager - INFO -
Connected to Qdrant at http://qdrant:6333

2025-10-30 09:03:48,410 - jenkins_mcp.cache_manager - INFO -
Cache manager initialized with instance UUID: e0dae5f5
```

#### Qdrant Logs

```powershell
# View Qdrant logs
docker logs jenkins_mcp_enterprise-qdrant -f

# Last 50 lines
docker logs jenkins_mcp_enterprise-qdrant --tail 50
```

**What you'll see:**

- Collection initialization
- Vector indexing operations
- Search queries
- Storage statistics

---

### Claude Desktop Logs

#### Location:

```
C:\Users\Vaibhav\AppData\Roaming\Claude\logs\
```

#### Main Log Files:

**1. mcp-server-jenkins.log**

- MCP server communication
- Tool invocations
- Errors and warnings

**View:**

```powershell
Get-Content "$env:APPDATA\Claude\logs\mcp-server-jenkins.log" -Tail 50
```

**2. main.log**

- Claude Desktop main process
- MCP server connection status
- Extension loading

**View:**

```powershell
Get-Content "$env:APPDATA\Claude\logs\main.log" -Tail 50
```

**3. claude.ai-web.log**

- Web interface logs
- UI events

#### Monitor Live:

```powershell
# Watch MCP server log in real-time
Get-Content "$env:APPDATA\Claude\logs\mcp-server-jenkins.log" -Wait -Tail 20
```

---

### Jenkins Build Log Cache

#### Location:

Inside Docker container: `/tmp/mcp-jenkins/instance-[UUID]/`

**Structure:**

```
/tmp/mcp-jenkins/
└── instance-e0dae5f5/
    ├── Java_System_Info/
    │   ├── 1/
    │   │   ├── console.log
    │   │   └── metadata.json
    │   └── 2/
    │       ├── console.log
    │       └── metadata.json
    └── Windows_Health_Check/
        ├── 1/
        │   ├── console.log
        │   └── metadata.json
        └── 2/
            ├── console.log
            └── metadata.json
```

**Access Cached Logs:**

```powershell
# List all cached builds
docker exec jenkins_mcp_enterprise-server ls -R /tmp/mcp-jenkins/

# Read a specific log
docker exec jenkins_mcp_enterprise-server cat /tmp/mcp-jenkins/instance-e0dae5f5/Java_System_Info/1/console.log

# View metadata
docker exec jenkins_mcp_enterprise-server cat /tmp/mcp-jenkins/instance-e0dae5f5/Java_System_Info/1/metadata.json
```

**Metadata Content:**

```json
{
  "job_name": "Java_System_Info",
  "build_number": 1,
  "timestamp": "2025-10-30T09:15:30Z",
  "result": "FAILURE",
  "duration": 45000,
  "cached_at": "2025-10-30T09:16:00Z",
  "log_size_bytes": 15234
}
```

---

## 🔍 Monitoring Commands

### Check System Status

```powershell
# Check all services
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Expected output:
# jenkins_mcp_enterprise-server   Up 2 hours (healthy)   0.0.0.0:3008->8000/tcp
# jenkins_mcp_enterprise-qdrant   Up 2 hours (healthy)   0.0.0.0:6333-6334->6333-6334/tcp
```

### Check Resource Usage

```powershell
# Container resource stats
docker stats --no-stream

# Expected output:
# CONTAINER                        CPU %    MEM USAGE / LIMIT     MEM %
# jenkins_mcp_enterprise-server    0.5%     503MB / 16GB         3.14%
# jenkins_mcp_enterprise-qdrant    0.2%     45MB / 16GB          0.28%
```

### Check Network Connectivity

```powershell
# Test MCP server
curl http://localhost:3008/health

# Test Qdrant
curl http://localhost:6333/healthz

# Test Jenkins
curl http://172.26.128.1:8080/api/json
```

---

## 📈 Qdrant Data Collection Details

### How Logs Are Collected

1. **Trigger:** When you ask Claude to diagnose a build
2. **Fetch:** MCP server downloads console log from Jenkins
3. **Cache:** Saves raw log to `/tmp/mcp-jenkins/`
4. **Chunk:** Splits log into semantic chunks (~200 lines each)
5. **Embed:** Converts chunks to 384-dimensional vectors
6. **Store:** Saves vectors to Qdrant
7. **Index:** Makes searchable for semantic queries

### Data Flow Diagram

```
Jenkins Build
    ↓
[MCP Server Fetches Log]
    ↓
[Cache to /tmp/mcp-jenkins/]
    ↓
[Split into Chunks]
    ↓
[Generate Embeddings (all-MiniLM-L6-v2)]
    ↓
[Store in Qdrant]
    ↓
[Available for Semantic Search]
```

### View Collected Data in Qdrant

**Via Dashboard:**

1. Open http://localhost:6333/dashboard
2. Click "Collections"
3. Click "jenkins-logs"
4. See "Points" count (number of log chunks)

**Via API:**

```powershell
# Get collection info
curl http://localhost:6333/collections/jenkins-logs

# Example response:
{
  "result": {
    "status": "green",
    "vectors_count": 45,
    "points_count": 45,
    "indexed_vectors_count": 45,
    "segments_count": 1
  }
}
```

**Search Example:**

```powershell
# Search for similar content (requires vector)
$body = @{
  "vector" = @(0.1, 0.2, ...) # 384 dimensions
  "limit" = 5
  "with_payload" = $true
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:6333/collections/jenkins-logs/points/search" `
  -Method POST `
  -Body $body `
  -ContentType "application/json"
```

### What Data is Stored

For each log chunk:

| Field          | Description               | Example                        |
| -------------- | ------------------------- | ------------------------------ |
| `job_name`     | Jenkins job name          | "Java_System_Info"             |
| `build_number` | Build number              | 1                              |
| `jenkins_url`  | Jenkins instance URL      | "http://172.26.128.1:8080"     |
| `chunk_text`   | Log content               | "ERROR: Connection timeout..." |
| `line_start`   | Starting line number      | 145                            |
| `line_end`     | Ending line number        | 345                            |
| `chunk_index`  | Chunk sequence            | 2                              |
| `total_chunks` | Total chunks for build    | 8                              |
| `timestamp`    | When indexed              | "2025-10-30T09:16:00Z"         |
| `vector`       | 384-dimensional embedding | [0.123, -0.456, ...]           |

---

## 🧹 Data Cleanup

### Auto Cleanup

The system automatically cleans up:

- **Old cached logs:** After 7 days (configurable)
- **Old vector data:** After 7 days (configurable)

**Configuration:**
In `config/mcp-config.yml`:

```yaml
cleanup:
  enabled: true
  retention_days: 7
  run_on_startup: true
```

### Manual Cleanup

**Clear all cached logs:**

```powershell
docker exec jenkins_mcp_enterprise-server rm -rf /tmp/mcp-jenkins/*
```

**Clear Qdrant collection:**

```powershell
# Delete and recreate collection
curl -X DELETE http://localhost:6333/collections/jenkins-logs

# Restart MCP server to recreate
docker restart jenkins_mcp_enterprise-server
```

**Clear specific build cache:**

```powershell
docker exec jenkins_mcp_enterprise-server rm -rf /tmp/mcp-jenkins/instance-*/Java_System_Info/1/
```

---

## 📊 Monitoring Dashboard Access

### Qdrant Console Features

**1. Collection Browser**

- View all collections
- See vector count
- Check collection health

**2. Points Explorer**

- Browse individual vectors
- See payloads (metadata)
- Inspect embeddings

**3. Search Interface**

- Test semantic search
- View similar vectors
- Debug search quality

**4. Metrics**

- Query latency
- Memory usage
- Disk space
- Operations per second

### Screenshots Guide

When you open http://localhost:6333/dashboard:

**Top Navigation:**

- Collections | Console | Metrics | Settings

**Collections Page:**

- Shows `jenkins-logs` collection
- Green status indicator
- Vector count badge
- Click to explore

**Collection Detail:**

- Schema view
- Payload structure
- Vector configuration
- Sample data

---

## 🔐 Security & Access

### Ports Exposed

| Service     | Port | Access       | Notes               |
| ----------- | ---- | ------------ | ------------------- |
| MCP Server  | 3008 | localhost    | Health check only   |
| Qdrant UI   | 6333 | localhost    | Dashboard access    |
| Qdrant gRPC | 6334 | localhost    | Internal use        |
| Jenkins     | 8080 | 172.26.128.1 | Your Jenkins server |

### Firewall Rules

All services run on localhost and are **not** exposed to external networks by default.

---

## 🆘 Troubleshooting

### Qdrant Dashboard Won't Load

```powershell
# Check if Qdrant is running
docker ps | Select-String qdrant

# Check Qdrant logs
docker logs jenkins_mcp_enterprise-qdrant --tail 50

# Restart Qdrant
docker restart jenkins_mcp_enterprise-qdrant
```

### No Data in Qdrant

**Reason:** Logs aren't indexed yet

**Solution:** Ask Claude to diagnose a build:

```
Diagnose Java_System_Info build #1 at http://172.26.128.1:8080
```

This will:

1. Fetch the log
2. Process it
3. Store in Qdrant

**Verify:**

```powershell
curl http://localhost:6333/collections/jenkins-logs
```

### MCP Server Not Responding

```powershell
# Check health
curl http://localhost:3008/health

# Check logs
docker logs jenkins_mcp_enterprise-server --tail 100

# Restart
docker restart jenkins_mcp_enterprise-server
```

---

## 📝 Log Analysis Examples

### Find When a Build Was Analyzed

```powershell
docker logs jenkins_mcp_enterprise-server | Select-String "diagnose_build_failure"
```

### See All Vector Operations

```powershell
docker logs jenkins_mcp_enterprise-qdrant | Select-String "upsert|search|delete"
```

### Monitor Live Activity

```powershell
# MCP Server activity
docker logs jenkins_mcp_enterprise-server -f --tail 20

# Qdrant operations
docker logs jenkins_mcp_enterprise-qdrant -f --tail 20

# Claude Desktop MCP communication
Get-Content "$env:APPDATA\Claude\logs\mcp-server-jenkins.log" -Wait -Tail 20
```

---

## 🎯 Quick Command Reference

```powershell
# System Status
docker ps
docker stats --no-stream

# Health Checks
curl http://localhost:3008/health
curl http://localhost:6333/healthz
curl http://172.26.128.1:8080/api/json

# Open Dashboards
Start-Process "http://localhost:6333/dashboard"
Start-Process "http://172.26.128.1:8080"

# View Logs
docker logs jenkins_mcp_enterprise-server --tail 100
docker logs jenkins_mcp_enterprise-qdrant --tail 100
Get-Content "$env:APPDATA\Claude\logs\mcp-server-jenkins.log" -Tail 50

# Restart Services
docker-compose restart
docker restart jenkins_mcp_enterprise-server
docker restart jenkins_mcp_enterprise-qdrant

# View Cached Data
docker exec jenkins_mcp_enterprise-server ls -R /tmp/mcp-jenkins/

# Qdrant Collection Info
curl http://localhost:6333/collections/jenkins-logs
```

---

## 📚 Related Documentation

- **Command Reference:** `CLAUDE-DESKTOP-COMMANDS.md`
- **Setup Guide:** `GETTING-STARTED.md`
- **Configuration:** `config/README.md`
- **Diagnostic Config:** `config/README-diagnostic-config.md`

---

**Happy Monitoring! 📊**

_Track your Jenkins builds with AI-powered insights!_
