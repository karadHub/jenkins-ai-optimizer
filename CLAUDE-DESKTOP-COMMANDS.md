# Claude Desktop Commands Guide

## Quick Reference for Jenkins AI Optimizer

This guide shows you **exactly what to ask Claude Desktop** to interact with your Jenkins server.

---

## Prerequisites

Before asking questions, tell Claude your Jenkins URL:

```
My Jenkins server is at http://172.26.128.1:8080
```

Or include it in each question:

```
[Your question] at Jenkins http://172.26.128.1:8080
```

---

## Available Commands

### 1. Diagnose Build Failures

**Command:**

```
Diagnose the failure in [job-name] build #[number] at http://172.26.128.1:8080
```

**Examples:**

```
Diagnose the failure in Java_System_Info build #1 at http://172.26.128.1:8080
```

```
Why did Windows_Health_Check build #2 fail at http://172.26.128.1:8080?
```

```
Analyze the failed build Windows_Health_Check #2 at http://172.26.128.1:8080
```

**What it does:**

- ✅ Downloads and analyzes console logs
- ✅ Identifies error patterns (compilation errors, timeouts, permissions, etc.)
- ✅ Provides AI-powered recommendations
- ✅ Categorizes failure types
- ✅ Indexes logs for semantic search

**Response includes:**

- Build status and result
- Error category (e.g., "Artifact Collection", "Compilation Error")
- Key error messages
- Recommended fixes
- Log cache location

---

### 2. Trigger New Builds

**Command:**

```
Trigger a build of [job-name] at http://172.26.128.1:8080
```

**Examples:**

```
Run a new build of Java_System_Info at http://172.26.128.1:8080
```

```
Start Windows_Health_Check job at http://172.26.128.1:8080
```

```
Trigger Java_System_Info with parameters at http://172.26.128.1:8080
```

**With parameters:**

```
Trigger Java_System_Info at http://172.26.128.1:8080 with parameters:
- BRANCH: develop
- ENVIRONMENT: staging
```

**What it does:**

- ✅ Starts a Jenkins build
- ✅ Waits for completion (default: 10 minutes timeout)
- ✅ Returns build number and status
- ✅ Shows build URL

**Response includes:**

- Build number
- Queue ID
- Build URL
- Final status (SUCCESS, FAILURE, ABORTED)

---

### 3. Trigger Build Without Waiting (Async)

**Command:**

```
Start [job-name] asynchronously at http://172.26.128.1:8080
```

**Examples:**

```
Trigger Java_System_Info async at http://172.26.128.1:8080
```

```
Start Windows_Health_Check without waiting at http://172.26.128.1:8080
```

**What it does:**

- ✅ Starts build and returns immediately
- ✅ Doesn't wait for completion
- ✅ Useful for long-running jobs

---

### 4. Search for Errors in Logs

**Command:**

```
Search for [error-pattern] in [job-name] build #[number] at http://172.26.128.1:8080
```

**Examples:**

```
Find all errors in Java_System_Info build #1 at http://172.26.128.1:8080
```

```
Search for "timeout" in Windows_Health_Check build #2 at http://172.26.128.1:8080
```

```
Find compilation errors in Java_System_Info build #1 at http://172.26.128.1:8080
```

```
Search for "OutOfMemory" in Windows_Health_Check #2 at http://172.26.128.1:8080
```

**What it does:**

- ✅ Uses smart grep with relevance scoring
- ✅ Shows context around matches
- ✅ Deduplicates similar errors
- ✅ Scores results by importance

**Presets available:**

- `preset:critical` - High-priority errors only
- `preset:all` - Broad search

---

### 5. Semantic Search (AI-Powered)

**Command:**

```
Semantically search for "[description]" in [job-name] build #[number] at http://172.26.128.1:8080
```

**Examples:**

```
Find stack traces in Java_System_Info build #1 at http://172.26.128.1:8080
```

```
Search for database connection issues in Windows_Health_Check #2 at http://172.26.128.1:8080
```

```
Find deployment failures in Java_System_Info build #1 at http://172.26.128.1:8080
```

**What it does:**

- ✅ Uses AI embeddings to understand context
- ✅ Finds semantically similar content
- ✅ Better than keyword search for complex queries
- ✅ Powered by Qdrant vector database

---

### 6. Navigate to Specific Log Sections

**Command:**

```
Navigate to [section] in [job-name] build #[number] at http://172.26.128.1:8080
```

**Examples:**

```
Show me the deployment section in Java_System_Info #1 at http://172.26.128.1:8080
```

```
Jump to "Building module" in Windows_Health_Check #2 at http://172.26.128.1:8080
```

```
Navigate to "Stage: Deploy" in Java_System_Info #1 at http://172.26.128.1:8080
```

**What it does:**

- ✅ Jumps to specific log sections
- ✅ Shows context around the match
- ✅ Can find Nth occurrence

---

### 7. Get Log Context

**Command:**

```
Show lines [start]-[end] from [job-name] build #[number] at http://172.26.128.1:8080
```

**Examples:**

```
Show lines 100-200 from Java_System_Info build #1 at http://172.26.128.1:8080
```

```
Get the first 50 lines of Windows_Health_Check #2 at http://172.26.128.1:8080
```

```
Show the last 100 lines of Java_System_Info #1 at http://172.26.128.1:8080
```

**What it does:**

- ✅ Reads specific line ranges
- ✅ Fetches logs if not cached
- ✅ Useful for detailed inspection

---

### 8. Analyze Pipeline with Sub-Builds

**Command:**

```
Analyze [pipeline-job] build #[number] with sub-builds at http://172.26.128.1:8080
```

**Examples:**

```
Show sub-builds for Java_System_Info #1 at http://172.26.128.1:8080
```

```
Analyze the pipeline Windows_Health_Check #2 with all sub-builds at http://172.26.128.1:8080
```

**What it does:**

- ✅ Discovers all triggered sub-builds
- ✅ Shows nested build tree
- ✅ Fetches logs for all sub-builds
- ✅ Provides complete pipeline view

---

### 9. Get Job Parameters

**Command:**

```
What are the parameters for [job-name] at http://172.26.128.1:8080?
```

**Examples:**

```
Show me the parameters for Java_System_Info at http://172.26.128.1:8080
```

```
List build parameters for Windows_Health_Check at http://172.26.128.1:8080
```

**What it does:**

- ✅ Lists all job parameters
- ✅ Shows parameter types
- ✅ Shows default values
- ✅ Shows descriptions

---

### 10. Advanced Pattern Search (Ripgrep)

**Command:**

```
Use ripgrep to search for [pattern] in [job-name] build #[number] at http://172.26.128.1:8080
```

**Examples:**

```
Ripgrep search for "ERROR" in Java_System_Info #1 at http://172.26.128.1:8080
```

```
Search case-sensitive for "FATAL" in Windows_Health_Check #2 at http://172.26.128.1:8080
```

**What it does:**

- ✅ Fast regex pattern matching
- ✅ Shows before/after context
- ✅ Supports case-sensitive search
- ✅ Can invert matches

---

## 💡 Pro Tips

### Combine Commands

You can ask Claude to do multiple things:

```
Diagnose Java_System_Info build #1, then search for compilation errors,
and show me the deployment section at http://172.26.128.1:8080
```

### Ask for Recommendations

```
What should I do about the failures in Windows_Health_Check #2
at http://172.26.128.1:8080?
```

### Compare Builds

```
Compare Java_System_Info build #1 and #2 at http://172.26.128.1:8080
```

### Conversational Follow-ups

After diagnosing a build:

```
Show me more details about that compilation error
```

```
Can you search for similar errors?
```

```
What are the next steps to fix this?
```

---

## 📊 Understanding Responses

### Diagnose Build Response Structure

```json
{
  "build_info": {
    "job_name": "Java_System_Info",
    "build_number": 1,
    "result": "FAILURE",
    "duration": "45 seconds"
  },
  "error_category": "Compilation Error",
  "key_errors": ["error: cannot find symbol: variable xyz"],
  "recommendations": [
    "Check if variable 'xyz' is declared",
    "Verify imports are correct"
  ],
  "log_location": "/tmp/mcp-jenkins/instance-xxx/Java_System_Info/1/console.log"
}
```

### Search Results

```
Found 3 matches:

[Line 145] ERROR: Connection timeout
  Context: Attempting to connect to database...

[Line 289] ERROR: Failed to deploy artifact
  Context: Uploading to repository...

[Line 534] ERROR: Build failed with exit code 1
  Context: Compilation finished with errors
```

---

## 🔧 Your Jenkins Jobs

Based on your current setup:

| Job Name                 | Description                        |
| ------------------------ | ---------------------------------- |
| **Java_System_Info**     | Java system information collection |
| **Windows_Health_Check** | Windows health monitoring          |

---

## 🆘 Troubleshooting

### If Claude doesn't respond with MCP tools:

1. **Check MCP server status:**

   - Look for green indicator next to "jenkins" in Claude Desktop
   - Click the MCP icon to see connected servers

2. **Always include Jenkins URL:**

   ```
   at http://172.26.128.1:8080
   ```

3. **Be specific about job name and build number:**

   ```
   ❌ "check my build"
   ✅ "diagnose Java_System_Info build #1 at http://172.26.128.1:8080"
   ```

4. **Restart Claude Desktop if needed:**

   - Close completely (system tray → Quit)
   - Reopen Claude Desktop

5. **Check Docker containers are running:**
   ```powershell
   docker ps
   ```
   Should show:
   - `jenkins_mcp_enterprise-server`
   - `jenkins_mcp_enterprise-qdrant`

---

## 📖 Example Conversation Flow

**You:** My Jenkins is at http://172.26.128.1:8080

**Claude:** Got it! Your Jenkins server is noted. How can I help you today?

**You:** Diagnose the failure in Java_System_Info build #1

**Claude:** _[Uses diagnose_build_failure tool]_

I've analyzed Java_System_Info build #1. The build failed due to:

**Error Category:** Compilation Error

**Key Issues:**

- Line 145: error: cannot find symbol: variable DATABASE_URL
- Missing environment variable configuration

**Recommendations:**

1. Add DATABASE_URL to job parameters
2. Check Jenkins credentials configuration
3. Verify environment setup script

Would you like me to search for similar errors in other builds?

**You:** Yes, search for "DATABASE_URL" errors

**Claude:** _[Uses ripgrep_search tool]_

Found 2 occurrences of "DATABASE_URL":

[Build #1, Line 145] error: cannot find symbol: variable DATABASE_URL
[Build #1, Line 287] Caused by: java.lang.NullPointerException: DATABASE_URL is null

---

## 🎓 Learning Mode

If you're new to this, start with these simple commands:

1. **First:** Tell Claude your Jenkins URL
2. **Second:** Ask it to diagnose a failed build
3. **Third:** Ask follow-up questions about the errors
4. **Fourth:** Try triggering a new build
5. **Fifth:** Explore semantic search and navigation

---

## 🔗 Related Documentation

- **Setup Guide:** `GETTING-STARTED.md`
- **Diagnostic Config:** `config/README-diagnostic-config.md`
- **URLs & Access:** `MONITORING-AND-ACCESS.md`
- **Docker Setup:** `README-Docker.md`

---

**Happy Debugging! 🎉**

_Your AI-powered Jenkins assistant is ready to help!_
