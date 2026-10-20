<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Timeouts/Test-CompletesWithin.ps1
    name: test-completes-within
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Timeouts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Timeouts/tests/Test-CompletesWithin.Tests.ps1
    docs: "[Test-CompletesWithin.ps1.md](docs/references/pwsh/catzc-base-timeouts/Test-CompletesWithin.ps1.md)"
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
