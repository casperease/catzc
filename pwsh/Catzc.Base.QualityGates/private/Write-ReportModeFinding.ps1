<#
---
catzc:
  immutable:
    with_body_sha: aeeba2f56f86
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Write-ReportModeFinding.Tests.ps1
    docs: "[Write-ReportModeFinding.ps1.md](docs/references/pwsh/catzc-base-quality-gates/private/Write-ReportModeFinding.ps1.md)"
    cites:
      - PDR-CONFIG-EXCEPTIONISCONFIGENTRY
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
