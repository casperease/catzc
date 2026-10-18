<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1
    folder: private
    name: resolve-map-label-term
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Maps
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.Maps/tests/Resolve-MapLabelTerm.Tests.ps1
    cites:
      - ADR-DSGN-TRACK#{13,16}
---
#>

function Resolve-MapLabelTerm {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Label,

        [AllowEmptyCollection()]
        [string[]] $Term = @()
    )

    $colon = $Label.IndexOf(':')
    $head = ($colon -lt 0 ? $Label : $Label.Substring(0, $colon)).Trim().ToLowerInvariant()
    if ($head.Length -eq 0) {
        return
    }
    foreach ($candidate in $Term) {
        $lower = $candidate.ToLowerInvariant()
        if ($head -ceq $lower -or $head -ceq "${lower}s" -or $head -ceq "${lower}es") {
            return $candidate
        }
    }
}
