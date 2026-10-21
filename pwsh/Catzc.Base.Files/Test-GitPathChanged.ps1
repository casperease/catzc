<#
---
catzc:
  immutable:
    with_body_sha: b0a05ac5d37d
  edges:
    test: pwsh/Catzc.Base.Files/tests/Test-GitPathChanged.Tests.ps1
    docs: "[Test-GitPathChanged.ps1.md](../../docs/references/pwsh/catzc-base-files/Test-GitPathChanged.ps1.md)"
---
#>

function Test-GitPathChanged {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Path
    )

    $quotedPaths = foreach ($item in $Path) {
        "`"$item`""
    }
    $status = Invoke-Executable "git status --porcelain -- $($quotedPaths -join ' ')" -PassThru -Silent
    -not [string]::IsNullOrWhiteSpace($status.Output)
}
