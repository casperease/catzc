# pwsh/Tooling.Node/Install-NodeJs.ps1

The installer of Node.js, and with it npm, at the locked major version, through the platform package manager. Every other tool in this module
installs through the npm this one provides.

## help

### synopsis

Installs Node.js via the platform package manager.

### description

Installs Node.js (which includes npm) at the locked major version. Windows: winget (OpenJS.NodeJS.LTS). macOS: Homebrew (`node@<major>`).
Linux: the NodeSource apt repository for the locked major (configured inline if not already present), because the distro `nodejs` package
lags the pin badly (Ubuntu jammy ships Node 12). Idempotent — skips if already installed at the correct version.

NOT for CI pipelines. In Azure DevOps, use the native UseNode task which activates pre-cached versions instantly:

- task: UseNode@1 inputs: version: '22.x'

### parameter `Version`

Node.js major version to install. Defaults to the locked version in Get-ToolConfig.

### parameter `Force`

Replace an existing installation at the wrong version.

### example 1

```powershell
Install-NodeJs
```

### example 2

```powershell
Install-NodeJs -Force
```

## Linux source

The distro `nodejs` package trails the pinned major badly (Ubuntu jammy ships Node 12), so the Linux install uses the NodeSource apt
repository for the locked major, set up the way `Install-Terraform` sets up the HashiCorp repository. The repository url embeds the major, so
a new pin rewrites the source.
