<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.RootConfig/private/Get-RootConfigTargets.ps1
    folder: private
    name: get-root-config-targets
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.RootConfig
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.RootConfig/tests/Get-RootConfigTargets.Tests.ps1
    docs: "[Get-RootConfigTargets.ps1.md](docs/references/pwsh/catzc-base-rootconfig/private/Get-RootConfigTargets.ps1.md)"
    cites:
      - ADR-AUTO-IMPORTER-ENTRIESFOLLOWMIX
      - ADR-REPO-ROOTCFG
---
#>

function Get-RootConfigTargets {
    [OutputType([object[]])]
    param(
        [Parameter(Mandatory)]
        $Config,

        # Only where a file is materialised: a committed generated file reads the mix-independent list.
        [switch] $FollowMix
    )

    # An engine's importer entry follows the session's mix: it is managed only when one of the engines it serves is in the mix.
    $mixEngines = $null
    foreach ($entry in @($Config.files | Where-Object { $_.optIn })) {
        if (-not $FollowMix) {
            $entry
            continue
        }
        $servedBy = @(foreach ($engine in [Catzc.Base.Engines.ExecutionEngines]::All) {
                if ($engine.ImporterEntry -ceq $entry.target) {
                    $engine.Name
                }
            })
        if ($servedBy.Count -gt 0) {
            if ($null -eq $mixEngines) {
                $mixEngines = @((Get-ImportMix).engines)
            }
            $inMix = @(foreach ($name in $servedBy) {
                    if ($mixEngines -ccontains $name) {
                        $name
                    }
                })
            if ($inMix.Count -eq 0) {
                Write-Verbose "Root config '$($entry.target)' skipped: none of its engines ($($servedBy -join ', ')) is in the mix"
                continue
            }
        }
        $entry
    }
}
