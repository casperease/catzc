<#
---
catzc:
  immutable:
    with_body_sha: "6034e83514c6"
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
