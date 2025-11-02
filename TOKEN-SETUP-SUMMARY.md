# 🔐 Jenkins Token Configuration - Quick Reference

## ✅ What Was Done

I've set up your project to securely load Jenkins API tokens from a `.env` file. Here's what changed:

### 📦 **Added Dependencies**

- ✅ `python-dotenv` added to `requirements.txt`
- ✅ Package installed in your Python environment

### 📁 **Files Created/Updated**

1. **`.env`** (Git-ignored)

   - Store your Jenkins API token securely
   - Never committed to git
   - Location: `/jenkins-ai-optimizer/.env`

2. **`config/mcp-config.yml`** (Updated)

   - Changed `token: ""` → `token: "${JENKINS_TOKEN}"`
   - Now fetches token from environment variable

3. **`docker-compose.yml`** (Updated)

   - Added `env_file: - .env` to automatically load variables
   - Added `JENKINS_TOKEN=${JENKINS_TOKEN}` to environment section

4. **Code Updates**

   - `jenkins_mcp_enterprise/config.py` - Now loads .env on startup
   - `jenkins_mcp_enterprise/multi_jenkins_manager.py` - Now loads .env on startup

5. **Documentation**
   - `ENV-SETUP.md` - Comprehensive guide
   - `setup-env.sh` - Bash setup script
   - `setup-env.ps1` - PowerShell setup script

---

## 🚀 How to Use (Quick Start)

### Option 1: Automated Setup (Recommended)

**Windows (PowerShell):**

```powershell
.\setup-env.ps1
```

**Linux/Mac/Git Bash:**

```bash
chmod +x setup-env.sh
./setup-env.sh
```

### Option 2: Manual Setup

**Step 1: Get Your Jenkins Token**

1. Go to: http://172.26.128.1:8080
2. Click your username → **Configure**
3. Scroll to **API Token**
4. Click **Add new Token** → Name it "MCP Server"
5. Click **Generate** and **copy the token**

**Step 2: Add Token to .env**

Edit `.env` file and add your token:

```bash
JENKINS_TOKEN=your-actual-token-here-11a1b2c3d4e5f6
```

**Step 3: Start the Server**

```bash
docker-compose up -d
```

**Step 4: Verify**

```bash
curl http://localhost:3008/health
# Expected: OK
```

---

## 📋 Configuration Flow

```
.env file                    mcp-config.yml                Jenkins
┌────────────────┐          ┌──────────────────┐         ┌─────────┐
│ JENKINS_TOKEN= │  ──────> │ token:           │  ─────> │         │
│ 11a1b2c3...    │          │  "${JENKINS_     │         │ Jenkins │
│                │          │    TOKEN}"       │         │ Server  │
└────────────────┘          └──────────────────┘         └─────────┘
     (Secret)               (References ENV)            (Authenticated)
  Git-ignored!              Safe to commit!
```

---

## 🔍 How It Works

### 1. **Environment Variable Loading**

```python
# Automatic loading when server starts
from dotenv import load_dotenv
load_dotenv()  # Reads .env file
```

### 2. **Variable Resolution**

```yaml
# In mcp-config.yml
token: "${JENKINS_TOKEN}" # <-- Syntax for env variables
```

### 3. **Runtime Substitution**

```python
# multi_jenkins_manager.py automatically replaces
"${JENKINS_TOKEN}" → os.getenv("JENKINS_TOKEN") → actual token value
```

---

## 🛡️ Security

### ✅ What's Protected

- ✅ `.env` file is in `.gitignore` - never committed
- ✅ Tokens stored locally only
- ✅ Docker containers receive tokens via environment (not stored in images)
- ✅ Config files use variable references, not actual secrets

### 🔐 File Permissions (Linux/Mac)

```bash
chmod 600 .env  # Only you can read/write
chmod 600 config/mcp-config.yml  # Protect config too
```

---

## 🧪 Testing

### Test 1: Check .env is loaded

```bash
# In project directory
python -c "from dotenv import load_dotenv; import os; load_dotenv(); print('Token loaded:', 'Yes' if os.getenv('JENKINS_TOKEN') else 'No')"
```

### Test 2: Verify Docker receives token

```bash
docker-compose up -d
docker-compose exec jenkins_mcp_enterprise-server env | grep JENKINS_TOKEN
# Should show: JENKINS_TOKEN=your-token
```

### Test 3: Check server logs

```bash
docker-compose logs jenkins_mcp_enterprise-server | grep -i "jenkins"
# Look for: "Successfully loaded Jenkins instance"
```

---

## 🐛 Troubleshooting

| Problem                         | Solution                                                      |
| ------------------------------- | ------------------------------------------------------------- |
| "No token for Jenkins instance" | Edit `.env`, add `JENKINS_TOKEN=your-token`                   |
| Token not loading in Docker     | Add `env_file: - .env` to `docker-compose.yml`                |
| Empty token value               | Check `.env` has `JENKINS_TOKEN=value` (no spaces around `=`) |
| Config syntax error             | Use `"${JENKINS_TOKEN}"` with quotes and exact syntax         |

### Check Configuration

```bash
# View current setup (without exposing token)
grep "JENKINS_TOKEN" .env | head -c 20
# Should show: JENKINS_TOKEN=11a1b...

grep "token:" config/mcp-config.yml
# Should show: token: "${JENKINS_TOKEN}"
```

---

## 📚 Documentation

| File           | Purpose                              |
| -------------- | ------------------------------------ |
| `ENV-SETUP.md` | Comprehensive guide with all details |
| `README.md`    | Project overview and installation    |
| `.env.example` | Template for environment variables   |

---

## 🔄 Updating Token

If you need to change your Jenkins token:

```bash
# 1. Generate new token in Jenkins
# 2. Edit .env file
nano .env  # or notepad .env on Windows

# 3. Update the token value
JENKINS_TOKEN=new-token-here

# 4. Restart the server
docker-compose restart jenkins_mcp_enterprise-server

# 5. Verify
curl http://localhost:3008/health
```

---

## 💡 Pro Tips

### Multiple Jenkins Instances

```bash
# .env
JENKINS_PROD_TOKEN=prod-token
JENKINS_DEV_TOKEN=dev-token
```

```yaml
# mcp-config.yml
jenkins_instances:
  production:
    token: "${JENKINS_PROD_TOKEN}"
  development:
    token: "${JENKINS_DEV_TOKEN}"
```

### Environment-Specific Files

```bash
.env.development
.env.staging
.env.production
```

Load specific env:

```bash
docker-compose --env-file .env.production up -d
```

---

## ✨ What's Next?

1. ✅ **Configure .env** - Add your Jenkins token
2. ✅ **Start server** - `docker-compose up -d`
3. ✅ **Verify health** - `curl http://localhost:3008/health`
4. ✅ **Connect AI** - Configure Claude Desktop to use the server
5. ✅ **Start debugging** - Ask AI about your Jenkins builds!

---

## 📞 Need Help?

- 📖 **Full Guide**: `ENV-SETUP.md`
- 🐛 **Issues**: Check logs with `docker-compose logs -f`
- 💬 **Questions**: See `README.md` for support channels

---

**🎉 You're all set! Your Jenkins token is now secure and ready to use.**
