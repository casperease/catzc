<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Files/Test-GitPathChanged.ps1
    name: test-git-path-changed
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Files
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Files/tests/Test-GitPathChanged.Tests.ps1
    docs: "[Test-GitPathChanged.ps1.md](docs/references/pwsh/catzc-base-files/Test-GitPathChanged.ps1.md)"
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
