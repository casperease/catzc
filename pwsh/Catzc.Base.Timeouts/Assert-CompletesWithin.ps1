<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Timeouts/Assert-CompletesWithin.ps1
    name: assert-completes-within
    filetype: ps1
    role: function
    subkind: assert
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Timeouts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Timeouts/tests/Assert-CompletesWithin.Tests.ps1
    docs: "[Assert-CompletesWithin.ps1.md](docs/references/pwsh/catzc-base-timeouts/Assert-CompletesWithin.ps1.md)"
---
#>

function Assert-CompletesWithin {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [scriptblock] $ScriptBlock,

        [guid] $Budget = [guid]::Empty,

        [ValidateRange(1, [int]::MaxValue)]
        [int] $Seconds = (Get-TimeoutSeconds -Budget $Budget),

        [string] $Activity = $ScriptBlock.ToString().Trim()
    )

    $null = Invoke-WithTimeout $ScriptBlock -Seconds $Seconds -Activity $Activity
}
