# pwsh/Tooling.Toolchain/Install-Dotnet.ps1

The installer of the .NET SDK in user space, through the install scripts Microsoft publishes, side by side with any other .NET.

## help

### synopsis

Installs the .NET SDK via official Microsoft install scripts (user-space).

### description

Uses the vendored dotnet-install scripts shipped in this module's assets/scripts/ (resolved through Get-CatzcModuleRoot, so the same in
source and build mode) instead of package managers. Install directory resolved by Get-ScriptInstallDir (LOCALAPPDATA on Windows, HOME on
Unix — overridable in tools.yml). No admin required. Persists DOTNET_ROOT and PATH for future sessions. Idempotent — converges to the
desired state on every run: when our install dir already holds the locked version the download is skipped, but the environment (session +
persistent PATH, DOTNET_ROOT) is still converged, so a machine whose PATH persistence was lost is repaired by re-running. Only a
right-version dotnet from elsewhere on PATH (a system-wide install we do not manage) is a true no-op.

NOT for CI pipelines. In Azure DevOps, use the native UseDotNet task which activates pre-cached versions instantly:

- task: UseDotNet@2 inputs: version: '10.x'

### parameter `Version`

.NET SDK version to install. Defaults to the locked version in Get-ToolConfig.

### parameter `Force`

Replace an existing installation at the wrong version.

### example 1

```powershell
Install-Dotnet
```

### example 2

```powershell
Install-Dotnet -Version '10.0'
```

## Deciding to install

The command's own install directory wins the check. When it already holds the locked version the download is skipped, but the environment is
still converged: re-running repairs a lost `PATH` or `DOTNET_ROOT` persistence instead of returning past it
([ADR-AUTO-IDEM-CHECKBEFOREACTING](../../../drs/automation/idempotent-state-functions.md#rule-adr-auto-idem-checkbeforeacting)). Without
that, a session where dotnet resolves through the session janitor's PATH hints would mask a broken persistent PATH forever, and every
non-repo process, such as an editor's language server, would fail to find dotnet.

When the own directory holds nothing but a dotnet is on PATH, an install at the right version, wherever it lives, satisfies the tool contract
and is not this command's to manage: it skips without touching `PATH` or `DOTNET_ROOT`. A wrong version elsewhere does not block the install,
since it goes in side by side and its directory is prepended to PATH.

## The install script

The install script is the vendored one that ships in this module's `assets/`
([ADR-AUTO-ASSETDEP-INTERNALASSETDEPENDENCY](../../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-internalassetdependency)).

## The environment

On every run that owns the install, the session and the persistent environment are converged, both idempotent. The persistent PATH is the one
that non-repo processes resolve dotnet through. Each change is announced where it happens, and only when it changes something
([ADR-AUTO-CONSOLE-ANNOUNCELASTINGCHANGES](../../../drs/automation/console-output-matters.md#rule-adr-auto-console-announcelastingchanges)).
