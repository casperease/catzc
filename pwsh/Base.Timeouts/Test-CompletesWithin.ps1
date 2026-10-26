<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-timeouts/Test-CompletesWithin.ps1.md"
  header: "generated"
---
#>

function Test-CompletesWithin {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [scriptblock] $ScriptBlock,

        [guid] $Budget = [guid]::Empty,

        [ValidateRange(1, [int]::MaxValue)]
        [int] $Seconds = (Get-TimeoutSeconds -Budget $Budget)
    )

    try {
        $null = Invoke-WithTimeout $ScriptBlock -Seconds $Seconds
        $true
    }
    catch [System.TimeoutException] {
        $false
    }
}
