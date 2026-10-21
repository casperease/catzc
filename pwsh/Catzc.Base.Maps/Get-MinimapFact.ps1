<#
---
catzc:
  immutable:
    with_body_sha: "98de20dbf195"
  edges:
    test: pwsh/Catzc.Base.Maps/tests/Get-MinimapFact.Tests.ps1
    docs: "[Get-MinimapFact.ps1.md](docs/references/pwsh/catzc-base-maps/Get-MinimapFact.ps1.md)"
---
#>

function Get-MinimapFact {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyCollection()]
        [string[]] $Path
    )

    # One Get-FileMetaFact read for every path, so a call over many folders pays its git processes once.
    $facts = @{}
    $unique = @($Path | Sort-Object -Unique)
    if ($unique.Count -gt 0) {
        foreach ($fact in @(Get-FileMetaFact -Path $unique)) {
            $facts[$fact.Path] = $fact.Immutable
        }
    }
    $facts
}
