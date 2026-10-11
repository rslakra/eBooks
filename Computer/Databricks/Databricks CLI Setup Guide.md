# Databricks CLI Setup Guide

A comprehensive reference guide for installing, configuring, and using the Databricks CLI.



## 1. Overview

The **Databricks CLI** is a command-line interface that enables developers and data engineers to interact with Databricks workspaces programmatically. It provides powerful capabilities for managing notebooks, jobs, clusters, Unity Catalog objects, and DBFS files without needing to use the web UI.

**Why use the Databricks CLI?**

- Automate workspace operations and integrate with CI/CD pipelines
- Quickly explore Unity Catalog structure (catalogs, schemas, tables)
- Export/import notebooks and files programmatically
- Debug and troubleshoot data pipelines from the command line
- Manage jobs, clusters, and workspace objects efficiently


## 2. Installation

### macOS Installation (Homebrew)

The easiest way to install the Databricks CLI on macOS is via Homebrew:

```bash
brew tap databricks/tap
brew install databricks
```

### Verify Installation

Confirm the CLI is installed correctly:

```bash
databricks --version
```

**Version used when this guide was written:** `v0.278.0` (newer versions are fine)

### Upgrade

```bash
brew upgrade databricks
```

> For other operating systems (Linux, Windows), refer to the [official installation guide](https://docs.databricks.com/gcp/en/dev-tools/cli/install).



## 3. Configuration

### Authentication Method

**Token-based authentication** is used for our workspace. OAuth authentication is disabled, so you'll authenticate using a Personal Access Token (PAT).

### Setup Command

Run the configuration command:

```bash
databricks configure --token
```

You'll be prompted for:

**1. Databricks Host (Workspace URL):**

```
https://<workspace_url>.gcp.databricks.com/
```

**2. Token:**

- Generate a Personal Access Token from the Databricks UI:
    - Go to **Settings** → **Developer** → **Access tokens**
    - Click **Generate new token**
    - Copy the token (it's only shown once!)
    - Paste it when prompted by the CLI

### Configuration File

The CLI stores your credentials in:

```
~/.databrickscfg
```

You can view or edit this file directly if needed:

```bash
cat ~/.databrickscfg
```

> **Security:** This file contains your token in plain text. Never commit it to Git or share it, and restrict access with `chmod 600 ~/.databrickscfg`.

### Multiple Profiles (Optional)

To work with more than one workspace or token, create a named profile:

```bash
databricks configure --token --profile <profile_name>
```

Then pass the profile to any command:

```bash
databricks current-user me --profile <profile_name>
```



## 4. Verification Steps

After configuration, verify your setup with these commands:

### Check Current User

```bash
databricks current-user me
```

This should return your user information, confirming authentication is working.

### List Workspace Root

```bash
databricks workspace list /
```

This displays top-level directories in your workspace.

### List Unity Catalog Catalogs

```bash
databricks catalogs list
```

This shows all catalogs you have access to in Unity Catalog. The list varies by user and permissions.



## 5. Common Commands Reference

| Command | Description |
| --- | --- |
| `databricks workspace list <path>` | List workspace objects at the specified path |
| `databricks workspace export <path>` | Export a notebook or file from the workspace |
| `databricks workspace import <path>` | Import a notebook or file to the workspace |
| `databricks catalogs list` | List all Unity Catalog catalogs |
| `databricks schemas list <catalog>` | List schemas within a specific catalog |
| `databricks tables list <catalog> <schema>` | List tables in a schema |
| `databricks clusters list` | List all compute clusters |
| `databricks jobs list` | List all jobs and workflows |
| `databricks fs ls dbfs:/` | List files in DBFS (Databricks File System) |
| `databricks current-user me` | Get information about the current authenticated user |
| `databricks --help` | Show all available commands and usage |

> Argument syntax can differ between CLI versions. Run `databricks <command> --help` to confirm the exact usage for your installed version.



## 6. Troubleshooting Tips

> ⚠️ **Common Issues and Solutions**
>
> **OAuth Authentication Errors:**
>
> - Ensure you're using `databricks configure --token` (not OAuth)
> - Token-based auth is the only supported method for our workspace
>
> **Token Expired:**
>
> - Check token status in the Databricks UI: **Settings** → **Developer** → **Access tokens**
> - Generate a new token if expired and reconfigure: `databricks configure --token`
>
> **Connection Issues:**
>
> - Verify the workspace URL is correct (including `https://`)
> - Check network connectivity and VPN if required
> - View current config: `cat ~/.databrickscfg`
>
> **Permission Denied:**
>
> - Verify your user has appropriate permissions in the workspace
> - Contact the workspace admin if you need elevated access
>
> **Command Not Found:**
>
> - Ensure the Databricks CLI is installed: `databricks --version`
> - Check that PATH includes Homebrew binaries: `echo $PATH`
> - Reinstall if needed: `brew reinstall databricks`



## References

- **Official CLI Tutorial:** <https://docs.databricks.com/gcp/en/dev-tools/cli/tutorial>
- **Official Databricks CLI Documentation:** <https://docs.databricks.com/dev-tools/cli/>
- **Databricks CLI GitHub Repository:** <https://github.com/databricks/cli>
- **Unity Catalog Documentation:** <https://docs.databricks.com/data-governance/unity-catalog/>



## Author

- Rohtash Lakra
