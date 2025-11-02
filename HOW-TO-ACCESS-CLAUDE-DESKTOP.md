# How to Access Claude Desktop

## 🤔 What is Claude Desktop?

**Claude Desktop** is a desktop application (like Microsoft Word or Chrome) that you download and install on your Windows computer. It's an AI chatbot from Anthropic that can connect to your local tools - like this Jenkins system!

Think of it as:

- ✅ **ChatGPT** but running on your computer
- ✅ Can connect to **your Jenkins server**
- ✅ Answers questions in **natural language**
- ✅ **Automatically** calls the MCP server tools

---

## 📥 Step 1: Download Claude Desktop

### Where to Download:

🌐 **Official Download Page:** https://claude.ai/download

Or go to:

- https://www.anthropic.com/claude/download

### Installation:

1. Click "Download for Windows"
2. Save the `.exe` installer file
3. Double-click to run the installer
4. Follow the setup wizard
5. Launch Claude Desktop

### Account Setup:

- You need a **FREE Anthropic account**
- Sign up at: https://claude.ai
- Use any email address
- No credit card required for basic use

---

## 🔌 Step 2: Connect Claude Desktop to Your Jenkins System

### What Does This Mean?

Right now, you have:

- ✅ **Jenkins** running at `http://172.26.128.1:8080`
- ✅ **MCP Server** running in Docker at `http://localhost:3008`
- ❌ **Claude Desktop** - not installed yet

Once you connect them:

```
You → Claude Desktop → MCP Server → Jenkins → Results back to you
```

### Configuration Steps:

#### 1. Find the Config Directory

Open PowerShell and run:

```powershell
explorer "$env:APPDATA\Claude"
```

This opens: `C:\Users\Vaibhav\AppData\Roaming\Claude\`

#### 2. Create the Config File

In that folder, create a new file named:

```
claude_desktop_config.json
```

#### 3. Add This Content:

```json
{
  "mcpServers": {
    "jenkins": {
      "url": "http://localhost:3008/sse"
    }
  }
}
```

**What this does:**

- Tells Claude Desktop to connect to your MCP server
- The MCP server is already running (we started it with Docker)
- `localhost:3008` = your local MCP server
- `/sse` = Server-Sent Events endpoint (how they communicate)

#### 4. Restart Claude Desktop

- Close Claude Desktop **completely** (right-click system tray icon → Exit)
- Open it again
- Look for a **🔌 icon** or "MCP Connected" indicator

---

## 💬 Step 3: Start Using It!

### Example Conversations:

Once Claude Desktop is connected, you can ask it things like:

```
You: "List my Jenkins jobs"

Claude: I can see you have 2 Jenkins jobs:
1. Java_System_Info - Never run
2. Windows_Health_Check - Last build failed (#2)
```

```
You: "Run Java_System_Info"

Claude: ✅ Build triggered!
Job: Java_System_Info
Build #1 is now running...
```

```
You: "Why did Windows_Health_Check fail?"

Claude: Build #2 failed because it couldn't find the artifact files.
The build was looking for: C:\Users\Public\Documents\scan_data_*.txt
but those files weren't created. This usually means...
[detailed analysis]
```

---

## 🆚 Claude Desktop vs Command Line

### With Claude Desktop (Easy):

```
You: "Why did my build fail?"
Claude: [Automatically diagnoses and explains in plain English]
```

### Without Claude Desktop (Manual):

```powershell
# You have to run commands manually
curl http://localhost:3008/api/diagnose -d "job=Windows_Health_Check&build=2"
# Returns raw JSON - harder to understand
```

---

## ✅ Verification

### How to Know It's Working:

1. **Check Docker is Running:**

   ```powershell
   docker ps
   ```

   You should see:

   - `jenkins_mcp_enterprise-server` (Running)
   - `jenkins_mcp_enterprise-qdrant` (Running)

2. **Check MCP Server Health:**

   ```powershell
   curl http://localhost:3008/health
   ```

   Should return: `"OK"`

3. **Check Claude Desktop Connection:**
   - Open Claude Desktop
   - Look for 🔌 icon or "Connected" status
   - Type: "List my Jenkins jobs"
   - If it responds with your jobs, it's working!

---

## 🎯 What You DON'T Need to Do

### ❌ You do NOT need to:

- Modify any Jenkins jobs
- Install Jenkins plugins
- Change Jenkinsfiles
- Configure webhooks
- Edit job configurations
- Set up special permissions

### ✅ Everything works with:

- Your existing Jenkins setup
- Any job you create
- Standard Jenkins REST API
- Your current credentials

---

## 🔧 Troubleshooting

### Problem 1: Claude Desktop Won't Connect

**Check:**

1. Is Docker running? → `docker ps`
2. Is MCP server healthy? → `curl http://localhost:3008/health`
3. Is config file correct? → Check `claude_desktop_config.json`
4. Did you restart Claude Desktop after config change?

**Fix:**

```powershell
# Restart Docker containers
docker-compose restart

# Check logs
docker logs jenkins_mcp_enterprise-server
```

### Problem 2: "No MCP Servers Found"

**This means:**

- Config file is in wrong location
- Config file has wrong syntax
- Claude Desktop didn't load the config

**Fix:**

1. Verify file location: `$env:APPDATA\Claude\claude_desktop_config.json`
2. Verify JSON syntax is correct (no extra commas, proper brackets)
3. Completely close and reopen Claude Desktop

### Problem 3: Claude Says "I don't have access to Jenkins"

**This means:**

- MCP server is not running
- Config points to wrong URL

**Fix:**

```powershell
# Verify MCP server is accessible
curl http://localhost:3008/health

# Check docker
docker ps | findstr jenkins_mcp_enterprise-server
```

---

## 📱 Visual Guide

### What It Looks Like:

```
┌─────────────────────────────────────┐
│  Claude Desktop App                 │
│  ┌───────────────────────────────┐  │
│  │ 🔌 MCP Connected              │  │
│  │                               │  │
│  │ You: List my Jenkins jobs     │  │
│  │                               │  │
│  │ Claude: I can see 2 jobs:     │  │
│  │  1. Java_System_Info          │  │
│  │  2. Windows_Health_Check      │  │
│  │                               │  │
│  │ [Type your message...]        │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

---

## 🚀 Quick Start Checklist

- [ ] Download Claude Desktop from https://claude.ai/download
- [ ] Install and sign in
- [ ] Create config file: `$env:APPDATA\Claude\claude_desktop_config.json`
- [ ] Add the MCP server URL: `http://localhost:3008/sse`
- [ ] Restart Claude Desktop
- [ ] Verify 🔌 connection icon appears
- [ ] Test with: "List my Jenkins jobs"
- [ ] Start using natural language queries!

---

## 💡 Pro Tips

### Useful Queries to Try:

```
"List all my jobs"
"What's the status of Java_System_Info?"
"Run Windows_Health_Check"
"Why did my last build fail?"
"Search for error messages in recent builds"
"Show me all failed builds from today"
"Trigger a new build with parameters X=Y"
```

### Understanding Responses:

Claude will:

- ✅ Automatically identify which job you're talking about
- ✅ Fetch the data from Jenkins
- ✅ Analyze logs for errors
- ✅ Give you recommendations
- ✅ Explain things in plain English

You don't need to:

- ❌ Know API endpoints
- ❌ Format JSON requests
- ❌ Parse log files manually
- ❌ Remember job names exactly (AI understands context)

---

## 🎓 Summary

**Claude Desktop = Your AI Assistant for Jenkins**

1. Download it (free app)
2. Configure it (one JSON file)
3. Connect it (point to localhost:3008)
4. Use it (chat naturally)

**Your Jenkins jobs work exactly as they are - no configuration needed!**

---

## 📞 Need Help?

If you're still confused:

1. Make sure Docker is running (`docker ps`)
2. Check MCP server health (`curl http://localhost:3008/health`)
3. Verify config file exists and is correct
4. Try the manual API approach first (see next section)

---

## 🔧 Alternative: Use Without Claude Desktop

If you don't want to use Claude Desktop, you can still use the system!

### Manual API Calls:

```powershell
# List jobs
curl http://localhost:3008/api/jobs

# Get job status
curl http://localhost:3008/api/job/Java_System_Info

# Trigger build
curl -X POST http://localhost:3008/api/trigger -d "job=Java_System_Info"

# Diagnose failure
curl http://localhost:3008/api/diagnose -d "job=Windows_Health_Check&build=2"
```

**Pros:**

- No extra software
- Works immediately
- Full control

**Cons:**

- No AI analysis
- Raw JSON responses
- Have to know exact commands
- No natural language

---

**Ready to start? Download Claude Desktop and let AI help you manage Jenkins! 🚀**
