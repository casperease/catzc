<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Write-ReportModeFinding.ps1.md"
  warning: "Generated Header"
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
