<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Files/Test-FileIsNotLocked.ps1
    name: test-file-is-not-locked
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
    docs: "[Test-FileIsNotLocked.ps1.md](docs/references/pwsh/catzc-base-files/Test-FileIsNotLocked.ps1.md)"
---
#>

function Test-FileIsNotLocked {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    -not (Test-FileIsLocked $Path)
}
