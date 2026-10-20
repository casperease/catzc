<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1
    folder: private
    name: resolve-map-label-term
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Maps
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.Maps/tests/Resolve-MapLabelTerm.Tests.ps1
    docs: "[Resolve-MapLabelTerm.ps1.md](docs/references/pwsh/catzc-base-maps/private/Resolve-MapLabelTerm.ps1.md)"
    cites:
      - ADR-DSGN-TRACK-LABELSNAMEDEFINEDTERMS
      - ADR-DSGN-TRACK-VALUECHAINMAP
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
