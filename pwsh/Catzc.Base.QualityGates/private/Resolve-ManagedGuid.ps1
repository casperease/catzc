<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Resolve-ManagedGuid.ps1
    folder: private
    name: resolve-managed-guid
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    docs: "[Resolve-ManagedGuid.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Resolve-ManagedGuid.ps1.md)"
---
#>

function Resolve-ManagedGuid {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [guid] $Guid
    )

    $entries = Get-ManagedGuids
    foreach ($name in @($entries.Keys)) {
        $entry = $entries[$name]
        if ([guid]"$($entry.guid)" -eq $Guid) {
            return [ordered]@{
                name        = "$name"
                guid        = "$($entry.guid)"
                description = "$($entry.description)"
            }
        }
    }
    $null
}
