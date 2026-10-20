<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-TestDurationHistory.ps1
    folder: private
    name: get-test-duration-history
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
    docs: "[Get-TestDurationHistory.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-TestDurationHistory.ps1.md)"
---
#>

function Get-TestDurationHistory {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    $history = @{}
    if (-not [System.IO.File]::Exists($Path)) {
        return $history
    }
    try {
        $parsed = [System.IO.File]::ReadAllText($Path) | ConvertFrom-Json -AsHashtable
    }
    catch {
        Write-Message "Ignoring an unreadable test duration history at '$Path': $($_.Exception.Message)"
        return $history
    }
    foreach ($key in @($parsed.Keys)) {
        $value = $parsed[$key]
        if ($value -is [int] -or $value -is [long] -or $value -is [double]) {
            $history[$key] = [double] $value
        }
    }
    $history
}
