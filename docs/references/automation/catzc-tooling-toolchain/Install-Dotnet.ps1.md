---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/Install-Dotnet.ps1.md
    kind: reference
    body_sha: "6cb97608f78a"
    adrs:
      - ADR-AUTO-ASSETDEP#1
      - ADR-AUTO-CONSOLE#11
      - ADR-AUTO-IDEM#1
---

# automation/Catzc.Tooling.Toolchain/Install-Dotnet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Uses the vendored dotnet-install scripts shipped in this module's assets/scripts/ (resolved
through Get-CatzcModuleRoot, so the same in source and build mode) instead of package managers.
Install directory resolved by Get-ScriptInstallDir (LOCALAPPDATA on
Windows, HOME on Unix — overridable in tools.yml).
No admin required. Persists DOTNET_ROOT and PATH for future sessions.
Idempotent — converges to the desired state on every run: when our
install dir already holds the locked version the download is skipped,
but the environment (session + persistent PATH, DOTNET_ROOT) is still
converged, so a machine whose PATH persistence was lost is repaired by
re-running. Only a right-version dotnet from elsewhere on PATH (a
system-wide install we do not manage) is a true no-op.

NOT for CI pipelines. In Azure DevOps, use the native UseDotNet task
which activates pre-cached versions instantly:

    - task: UseDotNet@2
      inputs:
        version: '10.x'
```

## comment:2

Above `$needsInstall = $true`.

```text
Decide whether to run the install script. Our own install dir wins the check: when it already holds
the locked version the download is skipped, but the environment is STILL converged below — re-running
repairs a lost PATH/DOTNET_ROOT persistence instead of returning past it
([ADR-AUTO-IDEM#1](/docs/adr/automation/idempotent-state-functions.md#rule-adr-auto-idem1)). Without this,
a session where dotnet resolves through the session janitor's PATH hints masks a broken persistent
PATH forever, and every non-repo process (an editor's language server) fails to find dotnet.
```

## comment:3

Above `$installed = Get-ToolVersion -Config $config`.

```text
Nothing in our install dir, but a dotnet is on PATH. At the right version that install —
wherever it lives — satisfies the tool contract and is not ours to manage: skip without touching
PATH or DOTNET_ROOT. A wrong version elsewhere doesn't block us since we install side-by-side
and prepend our dir to PATH.
```

## comment:4

Above `if ($IsWindows) {`.

```text
Resolve the vendored install script shipped in this module's assets/
([ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1))
```

## comment:5

Above `if ($env:DOTNET_ROOT -ne $installDir) {`.

```text
Converge the environment on every run that owns the install — session + persistent, both idempotent.
This is the PATH non-repo processes resolve dotnet through.
Each change is announced where it happens, and only when it changes something
([ADR-AUTO-CONSOLE#11](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console11)).
```
