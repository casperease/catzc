<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Files/Assert-FileIsNotLocked.ps1
    name: assert-file-is-not-locked
    filetype: ps1
    role: function
    subkind: assert
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Files
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    docs: "[Assert-FileIsNotLocked.ps1.md](docs/references/pwsh/catzc-base-files/Assert-FileIsNotLocked.ps1.md)"
---
#>

function Assert-FileIsNotLocked {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [string] $ErrorText
    )

    if (Test-FileIsLocked $Path) {
        $message = if ($ErrorText) {
            $ErrorText
        }
        else {
            "Expected file not to be locked, but it is held open: $Path"
        }
        throw $message
    }
}
