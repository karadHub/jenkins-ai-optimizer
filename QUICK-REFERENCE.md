# Quick Reference Card

## ⚡ Jenkins AI Optimizer - Quick Commands

---

### 🔗 URLs

| Service              | URL                             | What It Does            |
| -------------------- | ------------------------------- | ----------------------- |
| **Jenkins**          | http://172.26.128.1:8080        | Your Jenkins server     |
| **Qdrant Dashboard** | http://localhost:6333/dashboard | View collected log data |
| **MCP Health**       | http://localhost:3008/health    | Check MCP server status |

---

### 💬 Claude Desktop Commands

**Always include:** `at http://172.26.128.1:8080`

#### Top 5 Most Used Commands

```
1. Diagnose Java_System_Info build #1 at http://172.26.128.1:8080

2. Trigger a build of Java_System_Info at http://172.26.128.1:8080

3. Search for errors in Java_System_Info build #1 at http://172.26.128.1:8080

4. Show me the parameters for Java_System_Info at http://172.26.128.1:8080

5. Navigate to "deployment" in Java_System_Info build #1 at http://172.26.128.1:8080
```

---

### 🐳 Docker Commands

```powershell
# Start services
docker-compose up -d

# Stop services
docker-compose down

# Check status
docker ps

# View logs
docker logs jenkins_mcp_enterprise-server -f

# Restart MCP server
docker restart jenkins_mcp_enterprise-server
```

---

### 📊 Monitoring

```powershell
# Health checks
curl http://localhost:3008/health
curl http://localhost:6333/healthz

# View Qdrant collection
curl http://localhost:6333/collections/jenkins-logs

# Open Qdrant dashboard
Start-Process "http://localhost:6333/dashboard"
```

---

### 📂 Log Locations

| Type           | Location                                          |
| -------------- | ------------------------------------------------- |
| MCP Server     | `docker logs jenkins_mcp_enterprise-server`       |
| Qdrant         | `docker logs jenkins_mcp_enterprise-qdrant`       |
| Claude Desktop | `$env:APPDATA\Claude\logs\mcp-server-jenkins.log` |
| Cached Builds  | `/tmp/mcp-jenkins/` (inside container)            |

---

### 🆘 Troubleshooting

```powershell
# Claude Desktop not connecting?
1. Check: docker ps  # Containers running?
2. Restart Claude Desktop
3. Check: Get-Content "$env:APPDATA\Claude\logs\mcp-server-jenkins.log" -Tail 50

# No data in Qdrant?
1. Ask Claude to diagnose a build first
2. Check: curl http://localhost:6333/collections/jenkins-logs

# MCP server errors?
1. Check: docker logs jenkins_mcp_enterprise-server --tail 100
2. Restart: docker restart jenkins_mcp_enterprise-server
```

---

### 📚 Full Documentation

- **Commands:** `CLAUDE-DESKTOP-COMMANDS.md`
- **Monitoring:** `MONITORING-AND-ACCESS.md`
- **Setup:** `GETTING-STARTED.md`
- **Config:** `config/README.md`

---

**Your Jenkins Jobs:**

- Java_System_Info
- Windows_Health_Check

**Happy Debugging! 🚀**
