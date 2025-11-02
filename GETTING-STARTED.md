# Getting Started with Jenkins AI Optimizer

## 📖 What is This?

Jenkins AI Optimizer is an **AI-powered assistant** that connects to your Jenkins server and helps you:

- 🔍 **Diagnose build failures** automatically
- 📊 **Analyze complex pipelines** with sub-builds
- 🔎 **Search logs** using natural language
- 🚀 **Trigger builds** with AI assistance
- 📝 **Get recommendations** for fixing issues

**The best part?** You don't need to configure your Jenkins jobs! The system works with **ANY existing Jenkins job** - no changes needed.

---

## 🎯 Two Ways to Use This System

### Method 1: Claude Desktop (Recommended - Fully Automated)

**Best for:** Everyone who wants AI-powered assistance

✅ **No manual work needed**
✅ **Natural language queries**
✅ **AI analyzes everything for you**
✅ **Works with existing jobs**

**How it works:**

1. You chat with Claude Desktop
2. Claude automatically calls the MCP server
3. MCP server talks to Jenkins
4. Results come back to you in plain English

### Method 2: Direct MCP Server API (Advanced)

**Best for:** Developers integrating with other tools

✅ **REST API access**
✅ **JSON responses**
✅ **Can be integrated into CI/CD**

---

## 🚀 Quick Start Guide

### Step 1: Start the System

```powershell
# Navigate to the project directory
cd C:\Users\Vaibhav\Documents\GitHub\jenkins-ai-optimizer

# Start Docker containers (MCP Server + Qdrant)
docker-compose up -d

# Verify everything is running
docker ps
```

**You should see:**

- `jenkins_mcp_enterprise-server-1` (Running)
- `jenkins_mcp_enterprise-qdrant-1` (Running)

**Health Check:**

```powershell
curl http://localhost:3008/health
# Should return: "OK"
```

---

### Step 2: Configure Your Jenkins Connection

**File:** `config/mcp-config.yml`

```yaml
jenkins_instances:
  production: # You can name this anything
    url: "http://172.26.128.1:8080" # Your Jenkins URL
    username: "your-username"
    token: "your-api-token" # Get from Jenkins: User → Configure → API Token
    timeout: 30

default_instance: "production" # Which Jenkins to use by default
```

**Important Notes:**

- ⚠️ **You don't need to modify your Jenkins jobs!**
- ⚠️ **This works with any existing job**
- ⚠️ **No plugins required in Jenkins**

**How to get Jenkins API Token:**

1. Log into Jenkins
2. Click your username (top right)
3. Click "Configure"
4. Scroll to "API Token"
5. Click "Add new Token"
6. Copy the token (you can only see it once!)

---

### Step 3: Connect Claude Desktop (Recommended)

**File:** `C:\Users\Vaibhav\AppData\Roaming\Claude\claude_desktop_config.json`

```json
{
  "mcpServers": {
    "jenkins": {
      "url": "http://localhost:3008/sse"
    }
  }
}
```

**Then:**

1. Close Claude Desktop completely
2. Restart Claude Desktop
3. Look for 🔌 icon (MCP servers connected)

---

## 💬 How to Use with Claude Desktop

### Example 1: List All Jobs

**You ask:**

> "Show me all my Jenkins jobs"

**Claude does:**

- Calls `list_jobs()` tool
- Fetches from your Jenkins
- Shows you formatted list

**You get:**

```
Here are your Jenkins jobs:

1. Windows_Health_Check
   - Status: Last build failed
   - Last Run: Build #2, 2 hours ago

2. Deploy_Production
   - Status: Success
   - Last Run: Build #45, 1 day ago
```

---

### Example 2: Diagnose a Failed Build

**You ask:**

> "Why did Windows_Health_Check build #2 fail?"

**Claude does:**

- Calls `diagnose_build_failure(job_name="Windows_Health_Check", build_number=2)`
- Downloads console log
- Analyzes errors using AI patterns
- Categorizes the failure type

**You get:**

```
Your Windows_Health_Check build #2 failed during artifact archiving.

🔍 Root Cause:
The build couldn't find expected output files at:
C:\Users\Public\Documents\scan_data_*.txt

💡 This usually means:
• The health scan didn't run or crashed before creating output
• The file path configuration is incorrect
• Permission issues prevented file creation

🛠️ Recommendations:
1. Check if the scan process completed successfully
2. Verify the output directory exists and is writable
3. Look for earlier errors in the log that stopped the scan

Would you like me to search the full logs for scan-related errors?
```

---

### Example 3: Search Logs Semantically

**You ask:**

> "Find all timeout errors in my recent builds"

**Claude does:**

- Calls `search_logs_semantic(query="timeout errors", limit=10)`
- Uses AI vector search (Qdrant)
- Finds relevant log sections

**You get:**

```
Found 3 builds with timeout-related errors:

1. Deploy_Production #43
   "Read timed out after 300 seconds waiting for database"

2. Windows_Health_Check #1
   "Connection timeout: Failed to reach health endpoint"

3. Integration_Tests #12
   "Test execution exceeded timeout of 600 seconds"
```

---

### Example 4: Analyze Complex Pipelines

**You ask:**

> "Show me the sub-builds for my latest pipeline"

**Claude does:**

- Calls `get_sub_build_tree(job_name="Main_Pipeline")`
- Discovers all triggered sub-builds
- Maps the entire build tree

**You get:**

```
Main_Pipeline #15 (SUCCESS)
├── Build_Frontend #120 (SUCCESS)
├── Build_Backend #98 (SUCCESS)
├── Run_Tests #203 (FAILED) ⚠️
│   ├── Unit_Tests #145 (SUCCESS)
│   └── Integration_Tests #87 (FAILED) ⚠️
└── Deploy_Staging #56 (NOT_RUN)

The pipeline stopped at Integration_Tests. Would you like me to diagnose why it failed?
```

---

### Example 5: Trigger New Builds

**You ask:**

> "Start a new build of Windows_Health_Check"

**Claude does:**

- Calls `trigger_build(job_name="Windows_Health_Check")`
- Queues the build in Jenkins
- Monitors until it starts

**You get:**

```
✅ Build triggered successfully!

Job: Windows_Health_Check
Build Number: #3
Queue ID: 1234
Status: Build is now running

I'll keep an eye on it. Want me to notify you when it completes?
```

---

## 🔧 Do You Need to Configure Your Jenkins Jobs?

### ❌ NO - Jobs Work As-Is!

**The system requires ZERO changes to your Jenkins jobs:**

- ✅ Works with Freestyle projects
- ✅ Works with Pipeline jobs
- ✅ Works with Multibranch pipelines
- ✅ Works with Folder structures
- ✅ Works with any plugins you're already using

### How Does It Work?

The MCP server uses **Jenkins REST API** to:

1. Fetch build information
2. Download console logs
3. Trigger builds
4. Discover sub-builds

**It doesn't require:**

- ❌ Special Jenkins plugins
- ❌ Modifications to Jenkinsfiles
- ❌ Changes to job configurations
- ❌ Webhooks or callbacks

### Optional: Enhanced Features

If you want **advanced features**, you can optionally add:

#### 1. Build Description (For Better Context)

In your Jenkins job configuration, you can add:

```groovy
// In Jenkinsfile
currentBuild.description = "Feature: User Authentication, PR #123"
```

This helps the AI understand what the build was for.

#### 2. Artifact Patterns (For Better Analysis)

If you archive artifacts, the AI can analyze them:

```groovy
archiveArtifacts artifacts: 'logs/**/*.log, reports/**/*.xml'
```

#### 3. Custom Build Parameters (For Smarter Triggers)

The AI can trigger builds with parameters:

```groovy
parameters {
    string(name: 'BRANCH', defaultValue: 'main')
    booleanParam(name: 'RUN_TESTS', defaultValue: true)
}
```

**But again - all of this is OPTIONAL!**

---

## 🆚 Manual vs Automated Workflow

### Before (Manual):

```
1. ❌ Open Jenkins in browser
2. ❌ Navigate to job
3. ❌ Find failed build
4. ❌ Click "Console Output"
5. ❌ Scroll through 1000s of lines
6. ❌ Search for "ERROR" or "FAILED"
7. ❌ Read stack traces
8. ❌ Google the error
9. ❌ Try to understand the context
10. ❌ Spend 30+ minutes debugging
```

### After (Automated with Claude):

```
1. ✅ Ask: "Why did my build fail?"
2. ✅ Get instant diagnosis with recommendations
3. ✅ Done in 10 seconds!
```

---

## 🛠️ Advanced Configuration

### Diagnostic Parameters

**File:** `jenkins_mcp_enterprise/diagnostic_config/diagnostic-parameters.yml`

This file contains **AI patterns** for recognizing errors:

```yaml
error_patterns:
  compilation:
    - pattern: "error: .* undeclared"
      severity: "high"
      category: "Compilation Error"

  timeout:
    - pattern: "timeout|timed out"
      severity: "medium"
      category: "Timeout"

  permission:
    - pattern: "permission denied|access denied"
      severity: "high"
      category: "Permission Error"
```

**You can customize these patterns** for your specific needs!

See: `config/README-diagnostic-config.md` for details.

---

### Vector Search Configuration

**File:** `config/mcp-config.yml`

```yaml
vector:
  enabled: true
  host: "http://qdrant:6333" # Qdrant vector database
  collection_name: "jenkins_logs"
  embedding_model: "all-MiniLM-L6-v2" # AI model for semantic search
```

**What this does:**

- Enables semantic log search
- "Find timeout errors" → AI understands context
- Better than simple keyword search

---

## 🔍 Troubleshooting

### MCP Server Not Starting

```powershell
# Check logs
docker logs jenkins_mcp_enterprise-server-1

# Common issues:
# 1. Wrong Jenkins URL → Check config/mcp-config.yml
# 2. Invalid API token → Regenerate in Jenkins
# 3. Port 3008 already in use → Change in docker-compose.yml
```

### Claude Desktop Not Connecting

```powershell
# 1. Verify MCP server is running
curl http://localhost:3008/health

# 2. Check Claude Desktop config location
echo $env:APPDATA\Claude\claude_desktop_config.json

# 3. Check Claude Desktop logs
Get-Content "$env:APPDATA\Claude\logs\*.log" -Tail 50

# 4. Restart Claude Desktop completely
```

### Jenkins Connection Failed

```powershell
# Test Jenkins connection manually
curl -u "username:token" http://172.26.128.1:8080/api/json

# If this fails:
# - Check Jenkins URL is accessible
# - Verify API token is valid
# - Check firewall rules
# - Confirm Jenkins is running
```

---

## 📚 Available MCP Tools

| Tool                     | What It Does                | Example                           |
| ------------------------ | --------------------------- | --------------------------------- |
| `list_jobs`              | Lists all Jenkins jobs      | "Show my jobs"                    |
| `diagnose_build_failure` | Analyzes why a build failed | "Why did build #5 fail?"          |
| `search_logs_semantic`   | AI-powered log search       | "Find connection errors"          |
| `get_sub_build_tree`     | Maps pipeline dependencies  | "Show sub-builds"                 |
| `trigger_build`          | Starts a new build          | "Run the deploy job"              |
| `get_build_info`         | Gets build metadata         | "What's the status of build #10?" |
| `search_logs`            | Keyword-based log search    | "Find 'OutOfMemory' in logs"      |

---

## 🎓 Learning Path

### Beginner: Just Getting Started

1. ✅ Set up Docker containers
2. ✅ Configure Jenkins connection
3. ✅ Connect Claude Desktop
4. ✅ Try: "List my Jenkins jobs"
5. ✅ Try: "Diagnose my last failed build"

### Intermediate: Power User

1. ✅ Use semantic search for complex queries
2. ✅ Analyze multi-level pipelines
3. ✅ Trigger builds with parameters
4. ✅ Customize diagnostic patterns

### Advanced: Integration

1. ✅ Use MCP API directly
2. ✅ Integrate with Slack/Teams
3. ✅ Build custom dashboards
4. ✅ Automate remediation workflows

---

## 🤔 Common Questions

### Q: Do I need to change my existing Jenkins jobs?

**A:** No! The system works with any existing Jenkins job without modifications.

### Q: What if my Jenkins is behind a firewall?

**A:** As long as your computer can access Jenkins, the MCP server can too (it runs locally).

### Q: Can I use this with multiple Jenkins servers?

**A:** Yes! Add multiple entries to `jenkins_instances` in `mcp-config.yml`.

### Q: Does this work with Jenkins plugins?

**A:** Yes, it uses standard Jenkins REST API which works with all plugins.

### Q: Is my Jenkins token secure?

**A:** Yes, it's stored locally in your config file and never sent anywhere except your Jenkins server.

### Q: Can I use this without Claude Desktop?

**A:** Yes, you can call the MCP server API directly (see REST API docs).

### Q: What languages does this support?

**A:** All! It analyzes console output regardless of programming language.

---

## 🚦 Next Steps

1. **Start the system:** `docker-compose up -d`
2. **Verify health:** `curl http://localhost:3008/health`
3. **Connect Claude Desktop** and restart it
4. **Ask your first question:** "Show me my Jenkins jobs"
5. **Try diagnosing a build:** "Why did [job-name] fail?"

---

## 📞 Need Help?

- 📖 **Detailed Config Guide:** `config/README.md`
- 🔍 **Diagnostic Patterns:** `config/README-diagnostic-config.md`
- 🐳 **Docker Setup:** `README-Docker.md`
- 🐛 **Issues:** Check logs with `docker logs jenkins_mcp_enterprise-server-1`

---

**Happy Debugging! 🎉**

Now you have an AI assistant that understands your Jenkins builds better than you do! 😄
