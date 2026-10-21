<#
---
catzc:
  immutable:
    with_body_sha: "1757c111e5db"
  edges:
    docs: "[Resolve-DotnetRemovalTarget.ps1.md](../../../docs/references/pwsh/catzc-tooling-toolchain/private/Resolve-DotnetRemovalTarget.ps1.md)"
    cites:
      - ADR-PWSH-PARAM-RESOLUTIONORDER
---
#>

function Resolve-DotnetRemovalTarget {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $machineDefault = 'C:\Program Files\dotnet'
    $command = Get-Command dotnet -CommandType Application -ErrorAction Ignore | Select-Object -First 1
    if (-not $command) {
        return $machineDefault
    }
    $onPath = Split-Path $command.Source -Parent
    if (Test-ExpectedPackageManager -Config (Get-ToolConfig -Tool 'dotnet') -Path $onPath) {
        return $machineDefault
    }
    $onPath
}
