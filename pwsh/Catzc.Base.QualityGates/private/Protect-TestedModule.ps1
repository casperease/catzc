<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Protect-TestedModule.ps1
    folder: private
    name: protect-tested-module
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    docs: "[Protect-TestedModule.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Protect-TestedModule.ps1.md)"
    cites:
      - ADR-REPO-PROTGLOB-PROTECTIONKEY
      - ADR-REPO-PROTGLOB-ORCHESTRATORDECIDES
---
#>

function Protect-TestedModule {
    [CmdletBinding()]
    param(
        [AllowEmptyCollection()]
        [string[]] $Candidates = @(),

        [AllowEmptyCollection()]
        [object[]] $Rows = @(),

        [AllowEmptyCollection()]
        [string[]] $FailedShardLabels = @(),

        [Parameter(Mandatory)]
        [string] $ProtectionKey
    )

    if ($Candidates.Count -eq 0) {
        return
    }

    $failedModules = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $modulesWithRows = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $failedRowCount = 0
    foreach ($row in $Rows) {
        if ($row.File) {
            [void]$modulesWithRows.Add((Get-TestFileModule $row.File))
        }
        if ($row.Result -ne 'Failed') {
            continue
        }
        $failedRowCount++
        if ($row.File) {
            [void]$failedModules.Add((Get-TestFileModule $row.File))
        }
        else {
            # a failed row with no file cannot be attributed — promote nothing
            return
        }
    }

    if ($FailedShardLabels.Count -gt 0 -and $failedRowCount -eq 0) {
        # a shard failed without a single failed row: a container/discovery error — promote nothing
        return
    }

    foreach ($unit in $Candidates) {
        if ($modulesWithRows.Contains($unit) -and -not $failedModules.Contains($unit)) {
            Protect-GlobSet -Test $ProtectionKey -Name $unit
        }
    }
}
