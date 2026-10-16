<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Core/Sync-SessionTools.ps1
    name: sync-session-tools
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-tooling-core/Sync-SessionTools.ps1.md
    test: automation/Catzc.Tooling.Core/tests/Sync-SessionTools.Tests.ps1
  config:
    synopsis: |-
      Reconciles the current session's PATH to the tools that are actually present, and reports any running from
      outside the installer layer. Registered as a post-import janitor.
    description: |-
      A lightweight, quiet-on-clean pass over the tools.yml set. For each tool it:
        - re-resolves it in the session (after a Sync-SessionPath to recover dropped registry entries), and
        - when the tool is unresolvable but declares session_path_hints (e.g. nvm-managed node), prepends the
          hinted directory to $env:PATH so THIS session can still run it, and
        - when the tool declares session_host_probes and more than one install exists, moves the best one to the
          front of $env:PATH so THIS session runs it (Resolve-SessionToolHost) — for dotnet an SDK at the locked
          version first, else a runtime at the locked version. The other installs are left in place.
      Every present tool whose location is not owned by the installer layer (Test-ToolLocationManaged) is
      collected and reported on two lines: the advisory (the fact plus which tools) on the always-on information
      stream, and each tool's resolved location — diagnostic detail — on the verbose stream, so a plain import
      names the offenders and -Verbose adds the paths. The pass emits nothing when every present tool is
      installer-owned. Session-only — it never writes the registry — and a no-op in CI, where the pipeline
      provisions tools. Advisory, not a gate: Get-ToolsStatus stays the authoritative, subprocess-backed
      classifier.
    parameters:
      Silent: Suppress both advisory lines outright (even under -Verbose).
    examples:
      - Sync-SessionTools
---
#>

function Sync-SessionTools {
    [CmdletBinding()]
    param(
        [switch] $Silent
    )

    if (Test-IsRunningInPipeline) {
        return
    }

    # Recover tools whose PATH entry was dropped but whose install is still registry-known and on disk.
    Sync-SessionPath

    $allTools = Get-Config -Config tools
    $foreignNames = [System.Collections.Generic.List[string]]::new()
    $foreignLocations = [System.Collections.Generic.List[string]]::new()

    foreach ($toolName in $allTools.Keys) {
        $config = Get-ToolConfig -Tool $toolName

        $cmd = Get-Command $config.command -CommandType Application -ErrorAction Ignore | Select-Object -First 1
        $hosted = Resolve-SessionToolHost -Config $config
        if ($hosted) {
            $cmd = $hosted
        }
        if (-not $cmd) {
            # Not on PATH — try the declared hints to point this session at a known install.
            $cmd = Resolve-SessionToolHint -Config $config
        }
        if (-not $cmd) {
            continue   # genuinely missing — Install-*/Get-ToolsStatus own that story, not the janitor
        }

        if (-not (Test-ToolLocationManaged -Config $config -Location $cmd.Source)) {
            $foreignNames.Add($toolName)
            $foreignLocations.Add("$toolName ($($cmd.Source))")
        }
    }

    if (-not $Silent -and $foreignNames.Count -gt 0) {
        Write-Message "Session tools not managed by the installer layer: $($foreignNames -join '; ')"
        Write-Message "Locations: $($foreignLocations -join '; ')" -Verbose:($VerbosePreference -eq 'Continue')
    }
}
