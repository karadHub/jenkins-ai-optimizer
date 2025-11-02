# Release Checklist for v1.0.1

This document guides you through creating your first release of Jenkins AI Optimizer on PyPI.

## ✅ Pre-Release Checklist (Completed)

- [x] Updated author email in `pyproject.toml` to `karadhub@gmail.com`
- [x] Fixed Issues URL typo (JkaradHub → karadHub)
- [x] Updated license format to SPDX identifier (GPL-3.0-or-later)
- [x] Created comprehensive `CHANGELOG.md` with all v1.0.1 features
- [x] Built package locally and verified with `twine check`
- [x] Created GitHub workflow `.github/workflows/publish.yml`

## 🔧 Setup Steps Required (Do These Now)

### Step 1: Create PyPI and Test PyPI Accounts

1. **Create PyPI account**: https://pypi.org/account/register/
   - Use email: `karadhub@gmail.com`
   - Enable 2FA (required for publishing)

2. **Create Test PyPI account**: https://test.pypi.org/account/register/
   - Same email for consistency
   - Enable 2FA

### Step 2: Configure Trusted Publishing on PyPI

**For Test PyPI (do this first):**

1. Go to: https://test.pypi.org/manage/account/publishing/
2. Click **"Add a new pending publisher"**
3. Fill in:
   - **PyPI Project Name**: `jenkins-ai-optimizer`
   - **Owner**: `karadHub`
   - **Repository name**: `jenkins-ai-optimizer`
   - **Workflow filename**: `publish.yml`
   - **Environment name**: `test-pypi`
4. Click **"Add"**

**For Production PyPI (do after testing):**

1. Go to: https://pypi.org/manage/account/publishing/
2. Click **"Add a new pending publisher"**
3. Fill in:
   - **PyPI Project Name**: `jenkins-ai-optimizer`
   - **Owner**: `karadHub`
   - **Repository name**: `jenkins-ai-optimizer`
   - **Workflow filename**: `publish.yml`
   - **Environment name**: `pypi`
4. Click **"Add"**

### Step 3: Create GitHub Environments

1. Go to your repository: https://github.com/karadHub/jenkins-ai-optimizer
2. Click **Settings** → **Environments**
3. Click **"New environment"**
4. Create environment named: `test-pypi`
5. (Optional) Add protection rules:
   - ✓ Required reviewers (yourself)
   - ✓ Wait timer (0 minutes)
6. Click **"Configure environment"**
7. Repeat for environment named: `pypi`

### Step 4: Commit and Push Current Changes

```powershell
# Stage all changes
git add .

# Commit the release preparation
git commit -m "chore: prepare for v1.0.1 release

- Updated author email and fixed URLs in pyproject.toml
- Created CHANGELOG.md with comprehensive feature list
- Added GitHub workflow for PyPI publishing
- Fixed license format to SPDX identifier
- Verified package builds successfully"

# Push to GitHub
git push origin main
```

## 🧪 Testing the Release (Test PyPI First)

### Option A: Test with Manual Workflow Trigger

1. Go to: https://github.com/karadHub/jenkins-ai-optimizer/actions
2. Click **"Publish to PyPI"** workflow
3. Click **"Run workflow"**
4. ✓ Check **"Publish to Test PyPI instead of PyPI"**
5. Click **"Run workflow"** button

### Option B: Test Locally (If workflow fails)

```powershell
# Build the package (already done)
python -m build

# Upload to Test PyPI manually
python -m twine upload --repository testpypi dist/*

# You'll need to create an API token at:
# https://test.pypi.org/manage/account/token/
```

### Verify Test PyPI Installation

```powershell
# Install from Test PyPI
pip install --index-url https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple jenkins-ai-optimizer

# Test the installation
jenkins_mcp_enterprise --help

# Uninstall after testing
pip uninstall jenkins-ai-optimizer -y
```

## 🚀 Production Release

### Create GitHub Release (Triggers Production PyPI)

1. Go to: https://github.com/karadHub/jenkins-ai-optimizer/releases
2. Click **"Draft a new release"**
3. Fill in:
   - **Choose a tag**: `v1.0.1` (create new tag on publish)
   - **Target**: `main`
   - **Release title**: `v1.0.1 - Initial Public Release`
   - **Description**: Copy from CHANGELOG.md (the v1.0.1 section)
4. ✓ Check **"Set as the latest release"**
5. Click **"Publish release"**

This will automatically:
- Trigger the GitHub workflow
- Build the package
- Publish to PyPI
- Make it available via `pip install jenkins-ai-optimizer`

## 📋 Post-Release Verification

1. **Check PyPI page**: https://pypi.org/project/jenkins-ai-optimizer/
   - Verify version shows as 1.0.1
   - Check that README displays correctly
   - Verify all metadata (author, license, links)

2. **Test installation from PyPI**:
   ```powershell
   # In a fresh environment
   pip install jenkins-ai-optimizer
   
   # Verify installation
   jenkins_mcp_enterprise --version
   jenkins_mcp_enterprise --help
   ```

3. **Monitor downloads**: PyPI provides statistics at:
   - https://pypistats.org/packages/jenkins-ai-optimizer

4. **Update README badge** (optional):
   Add to README.md after release:
   ```markdown
   [![PyPI version](https://badge.fury.io/py/jenkins-ai-optimizer.svg)](https://badge.fury.io/py/jenkins-ai-optimizer)
   [![Downloads](https://pepy.tech/badge/jenkins-ai-optimizer)](https://pepy.tech/project/jenkins-ai-optimizer)
   ```

## 🎉 Announcement

After successful release, consider:

1. **GitHub Discussions**: Announce in your repo discussions
2. **Social Media**: Share on Twitter/LinkedIn with #DevOps #Jenkins #AI #MCP tags
3. **Reddit**: r/devops, r/Python, r/opensource
4. **Discord/Slack**: Share in relevant DevOps communities

## 📊 Release Summary

**Package Details:**
- **Name**: jenkins-ai-optimizer
- **Version**: 1.0.1
- **License**: GPL-3.0-or-later
- **Author**: Vaibhav Karad (karadhub@gmail.com)
- **Repository**: https://github.com/karadHub/jenkins-ai-optimizer
- **PyPI**: https://pypi.org/project/jenkins-ai-optimizer/

**Installation Command:**
```bash
pip install jenkins-ai-optimizer
```

**Command Line Usage:**
```bash
jenkins_mcp_enterprise --config config/mcp-config.yml --transport stdio
```

## 🔄 Next Steps After v1.0.1

1. Start working on v1.1.0 features
2. Set up GitHub issue templates
3. Create contributing guidelines
4. Add more comprehensive examples
5. Consider creating a documentation site (GitHub Pages, Read the Docs)

## ⚠️ Important Notes

- **Version Immutability**: Once published to PyPI, you cannot republish the same version
- **Delete Limitation**: You can only delete releases within 24 hours
- **Test First**: Always test on Test PyPI before production
- **Semantic Versioning**: Follow semver for version numbers (MAJOR.MINOR.PATCH)

## 🆘 Troubleshooting

### "Package already exists" error
- You can't republish the same version
- Increment version in pyproject.toml and rebuild

### Trusted Publishing not working
- Verify environment names match exactly (case-sensitive)
- Ensure workflow is pushed to default branch (main)
- Check that you're creating release, not just tags

### Build fails in workflow
- Check Python version compatibility
- Verify all files are committed to git
- Review workflow logs in GitHub Actions

---

**Good luck with your first release! 🚀**

If you encounter any issues, check the GitHub Actions logs or PyPI project dashboard for details.
