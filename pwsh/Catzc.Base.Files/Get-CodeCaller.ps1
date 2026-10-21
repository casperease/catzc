<#
---
catzc:
  immutable:
    with_body_sha: "241a69bb8e07"
  edges:
    test: pwsh/Catzc.Base.Files/tests/Get-CodeCaller.Tests.ps1
    docs: "[Get-CodeCaller.ps1.md](../../docs/references/pwsh/catzc-base-files/Get-CodeCaller.ps1.md)"
    cites:
      - PDR-ONELIVE
---
#>

function Get-CodeCaller {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Name,

        [string[]] $Path = @('.')
    )

    $root = Get-RepositoryRoot
    $callers = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($relative in @(Get-GitTrackedPath $Path)) {
        $full = Join-Path $root $relative
        # A tracked file deleted from the working tree is still in the index, but names nothing.
        if (-not [System.IO.File]::Exists($full)) {
            continue
        }
        $text = [System.IO.File]::ReadAllText($full)
        if ($text.Contains([char] 0)) {
            continue
        }
        foreach ($item in $Name) {
            if ($text.Contains($item, [System.StringComparison]::OrdinalIgnoreCase)) {
                [void]$callers.Add($relative)
                break
            }
        }
    }
    $callers
}
