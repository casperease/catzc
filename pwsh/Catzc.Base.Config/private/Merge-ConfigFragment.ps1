<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Config/private/Merge-ConfigFragment.ps1
    folder: private
    name: merge-config-fragment
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Config
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.Config/tests/Merge-ConfigFragment.Tests.ps1
    docs: "[Merge-ConfigFragment.ps1.md](docs/references/pwsh/catzc-base-config/private/Merge-ConfigFragment.ps1.md)"
    cites:
      - ADR-AUTO-OVERLAY
---
#>

function Merge-ConfigFragment {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Base,

        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Fragment
    )

    $merged = [ordered]@{}
    foreach ($key in $Base.Keys) {
        $merged[$key] = $Base[$key]
    }
    foreach ($key in $Fragment.Keys) {
        $value = $Fragment[$key]
        if ($null -eq $value) {
            $merged.Remove($key)
        }
        elseif ($value -is [System.Collections.IDictionary] -and $merged[$key] -is [System.Collections.IDictionary]) {
            $merged[$key] = Merge-ConfigFragment -Base $merged[$key] -Fragment $value
        }
        else {
            $merged[$key] = $value
        }
    }
    $merged
}
