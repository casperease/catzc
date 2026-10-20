<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Write-ReportModeFinding.ps1
    folder: private
    name: write-report-mode-finding
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
    test: pwsh/Catzc.Base.QualityGates/tests/Write-ReportModeFinding.Tests.ps1
    docs: "[Write-ReportModeFinding.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Write-ReportModeFinding.ps1.md)"
    cites:
      - ADR-PRIN-CONFIG-EXCEPTIONISCONFIGENTRY
---
#>

function Write-ReportModeFinding {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Check,

        [AllowEmptyCollection()]
        [string[]] $Finding = @()
    )

    if ($Finding.Count -eq 0) {
        return
    }
    foreach ($line in $Finding) {
        Write-Message "[$Check] $line" -NoHeader
    }
    Write-Message "$($Finding.Count) $Check finding(s) in report mode: listed, not failing the run (mode: report)." -ForegroundColor Yellow
}
