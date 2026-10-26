# pwsh/Base.Exporter/Install-Catzc.ps1

The command that installs a Catzc build, either two-part beside a working root or into the current user's module path.

## help

### synopsis

Installs a Catzc build — two-part beside a working root, or into the current user's module path.

### description

Places a build (Build-Modules' `Catzc/<version>/` folder) where it is consumed
([ADR-AUTO-BUNDLE-TWOARTIFACTINSTALL](../../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-twoartifactinstall)):

```text
-Root <dir>            the two-part install. The build is copied to <dir>/.vendor/Catzc/<version>/, and a
                       root importer.ps1 is written at <dir> that dot-sources the installed Import-Catzc.ps1
                       with -RepositoryRoot set to <dir> — so <dir> is the working root (out/ and
                       repo-relative paths resolve there) and the installed build is the code root.
                       Dot-source <dir>/importer.ps1 to load the platform.
-Scope CurrentUser     the build is copied to <user module path>/Catzc/<version>/, after which
                       Import-Module Catzc loads it from any shell.
```

The build is verified first (Assert-CatzcBundle), before the destination is touched. The version is the build's own (build.json).
Idempotent: when the target already holds the same content hash the copy is skipped (and a -Root install only refreshes its importer.ps1);
-Force copies anyway. On Linux and macOS a copy makes every shipped shell script with a shebang executable again, since the copy drops the
bit bash needs.

### parameter `Root`

The destination working root for a two-part install. Not the mono repo.

### parameter `Scope`

CurrentUser — install into the user's PowerShell module path instead of beside a working root.

### parameter `Bundle`

Whose devbox build to install when -Source is not given (an exporter.yml bundles key). Defaults to default_bundle.

### parameter `Source`

The build to install (default: the bundle's devbox build, `<Get-OutputRoot>/automation/built/<bundle>/Catzc/<direct_install_version>`).

### parameter `Force`

Copy the build even when the target already holds the same content hash.

### parameter `DryRun`

Report the plan without copying or writing.

### parameter `Silent`

Suppress the summary line.

### example 1

```powershell
Install-Catzc -Root C:\work\project
```

### example 2

```powershell
Install-Catzc -Scope CurrentUser
```

## Dry run

The command takes `-DryRun`, not `ShouldProcess` or `-WhatIf`, because the branch comes before any side effect
([ADR-AUTO-DRYRUN-BRANCHBEFORESIDEEFFECT](../../../drs/automation/dry-run.md#rule-adr-auto-dryrun-branchbeforesideeffect)).

## Executable bits on Unix

A copy drops the executable bit, which an engine whose scripts need it (bash) requires on Unix
([ADR-AUTO-ENGINE-DIFFERENCESDECLAREDONCE](../../../drs/automation/execution-engines.md#rule-adr-auto-engine-differencesdeclaredonce)).
Every shipped script of such an engine that starts with its shebang is made executable again. The walk that finds them is a named whole-tree
walk ([ADR-PWSH-ENUM-ALWAYSBOUNDED](../../../drs/automation/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-alwaysbounded)): every shebang
script of the installed module is re-marked.
