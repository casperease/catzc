<#
---
catzc:
  immutable:
    with_body_sha: e2e75960671f
  edges:
    test: pwsh/Catzc.Base.Timeouts/tests/Test-CompletesWithin.Tests.ps1
    docs: "[Test-CompletesWithin.ps1.md](../../docs/references/pwsh/catzc-base-timeouts/Test-CompletesWithin.ps1.md)"
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
