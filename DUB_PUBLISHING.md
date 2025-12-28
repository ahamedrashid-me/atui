# DUB Publishing Guide

## Overview

ATUI is ready for publishing to the DUB Package Registry (https://code.dlang.org).

## Pre-Publishing Checklist

- ✅ `dub.json` properly configured
- ✅ `README.md` created and comprehensive
- ✅ `LICENSE` file included (MIT)
- ✅ `CHANGELOG.md` created
- ✅ All source files in `src/` directory
- ✅ No build artifacts in repo
- ✅ `.gitignore` configured
- ✅ Version number set (0.1.0)
- ✅ Package builds cleanly

## DUB Package Information

### Package Details

| Field | Value |
|-------|-------|
| **Name** | atui |
| **Version** | 0.1.0 |
| **Description** | ATUI - Advanced Terminal User Interface Framework for D |
| **License** | MIT |
| **Type** | Library |
| **Repository** | GitHub (yourusername/atui) |
| **Homepage** | https://github.com/yourusername/atui |

### dub.json Configuration

```json
{
  "name": "atui",
  "description": "ATUI - Advanced Terminal User Interface Framework for D",
  "authors": ["ATUI Development Team"],
  "license": "MIT",
  "copyright": "Copyright (c) 2025 ATUI Contributors",
  "homepage": "https://github.com/yourusername/atui",
  "repository": {
    "kind": "github",
    "owner": "yourusername",
    "project": "atui"
  },
  "version": "0.1.0",
  "targetType": "library",
  "targetPath": "build",
  "sourcePaths": ["src"],
  "importPaths": ["src"]
}
```

## How to Publish

### Step 1: Verify Repository

Ensure your GitHub repository is set up:

```bash
git remote -v
# Should show your GitHub repository
```

### Step 2: Create DUB Account

1. Visit https://code.dlang.org
2. Register for a DUB account
3. Verify your email

### Step 3: Set Up Git Tags

Tag your release version:

```bash
git tag -a v0.1.0 -m "Release version 0.1.0"
git push origin v0.1.0
```

### Step 4: Create GitHub Release

1. Go to https://github.com/yourusername/atui/releases
2. Click "Draft a new release"
3. Tag: `v0.1.0`
4. Title: `ATUI v0.1.0`
5. Description: Include highlights from CHANGELOG.md
6. Publish release

### Step 5: Register with DUB

1. Login to https://code.dlang.org
2. Click "Register Package"
3. Enter GitHub repository URL: `https://github.com/yourusername/atui`
4. DUB will auto-fetch and validate

### Step 6: Verify Publication

After DUB processes (usually < 5 minutes):

```bash
dub fetch atui
dub list atui
```

Should show: `atui 0.1.0`

## Post-Publishing

### Update Dependencies

Users can now add ATUI to their projects:

```json
{
  "dependencies": {
    "atui": "~>0.1.0"
  }
}
```

### Or via CLI

```bash
dub fetch atui
dub add-dependency myproject atui
```

## Version Updates

### For v0.2.0 or Later

1. Update version in `dub.json`
2. Update `CHANGELOG.md` with changes
3. Commit changes: `git commit -am "Release v0.2.0"`
4. Tag release: `git tag -a v0.2.0 -m "Release v0.2.0"`
5. Push: `git push origin main v0.2.0`
6. Create GitHub release
7. DUB auto-updates from GitHub tags

## Package Page

Once published, ATUI will have a page at:
https://code.dlang.org/packages/atui

This includes:
- Package information
- Dependency graph
- Download statistics
- Documentation links
- Version history

## Maintenance

### Keep Package Updated

- Update version regularly with releases
- Keep CHANGELOG.md current
- Update README.md with new features
- Monitor issue tracker
- Respond to bug reports

### Update DUB Metadata

To update package metadata on DUB:
1. Edit `dub.json`
2. Push changes to GitHub
3. Create a new release tag
4. DUB will auto-discover updates

## Troubleshooting

### Package Validation Failed

Check that:
- ✅ `dub.json` is valid JSON
- ✅ All required fields present
- ✅ Repository URL is correct
- ✅ License is recognized (MIT, Apache, etc.)

### Build Fails on DUB

- Check D compiler compatibility
- Verify dependencies listed
- Test locally: `dub build --config=linux`

### Package Not Appearing

- Wait 5-10 minutes for DUB to process
- Check GitHub release has proper tag
- Verify repository is public
- Check DUB server status

## Best Practices

### Versioning
- Use Semantic Versioning (MAJOR.MINOR.PATCH)
- Example: 0.1.0, 0.2.0, 1.0.0

### Documentation
- Keep README.md current
- Maintain CHANGELOG.md
- Add examples for new features
- Document breaking changes

### Compatibility
- Test with multiple D compilers
- Test on target platforms
- Report compiler requirements

### Release Process
1. Update version in dub.json
2. Update CHANGELOG.md
3. Test build locally
4. Commit & push to main
5. Create GitHub release
6. Tag version
7. Verify on DUB

## DUB Statistics

Once published, ATUI will show:
- Total downloads
- Version-specific downloads
- Dependency graphs
- Usage examples
- Community ratings

## Support After Publishing

### Issue Template

Create `.github/ISSUE_TEMPLATE/bug_report.md`:

```markdown
### Description
Brief description of issue

### Steps to Reproduce
1. ...
2. ...

### Expected Behavior
What should happen

### Actual Behavior
What actually happened

### Environment
- DUB version: 
- D compiler: 
- OS: 
```

### Bug Reporting
Help users report issues effectively by providing:
- Clear reproduction steps
- Error messages
- Environment details
- Related issues

## Resources

- DUB Package Registry: https://code.dlang.org
- Publishing Guide: https://dub.pm/publish
- Semantic Versioning: https://semver.org
- Keep a Changelog: https://keepachangelog.com

## FAQ

### Can I republish the same version?

No. Once published, a version is immutable. Create a new version for updates.

### How do I remove a package?

Contact DUB administrators through the website.

### What if my GitHub username changes?

Update repository URL in dub.json and create a new release.

### Can I use pre-release versions?

Yes, use versions like `0.1.0-alpha` or `0.1.0-rc1`.

## Next Steps

After publishing v0.1.0:

1. ✅ Add ATUI to DUB registry
2. 📢 Announce on D forums
3. 🔗 Share on GitHub social
4. 📝 Write blog post
5. 🎯 Plan v0.2.0 features
6. 👥 Build community

---

**Publication Status**: Ready to publish  
**Version**: 0.1.0  
**Date**: December 29, 2025
