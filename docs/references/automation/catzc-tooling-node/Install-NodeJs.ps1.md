# automation/Catzc.Tooling.Node/Install-NodeJs.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Installs Node.js via the platform package manager.

### description

Installs Node.js (which includes npm) at the locked major version. Windows: winget (OpenJS.NodeJS.LTS). macOS: Homebrew (`node@<major>`).
Linux: the NodeSource apt repository for the locked major (configured inline if not already present), because the distro `nodejs` package
lags the pin badly (Ubuntu jammy ships Node 12). Idempotent — skips if already installed at the correct version.

NOT for CI pipelines. In Azure DevOps, use the native UseNode task which activates pre-cached versions instantly:

- task: UseNode@1 inputs: version: '22.x'

### parameter Version

Node.js major version to install. Defaults to the locked version in Get-ToolConfig.

### parameter Force

Replace an existing installation at the wrong version.

### example 1

```powershell
Install-NodeJs
```

### example 2

```powershell
Install-NodeJs -Force
```

## comment:1

Above `$sourcePath = '/etc/apt/sources.list.d/nodesource.list'`, written with `#`.

```text
The distro `nodejs` package trails the pinned major badly (Ubuntu jammy ships Node 12), so install
from the NodeSource apt repository for the locked major — mirroring the HashiCorp repo setup in
Install-Terraform. The repo URL embeds the major, so re-write the source when the pin changes.
```
