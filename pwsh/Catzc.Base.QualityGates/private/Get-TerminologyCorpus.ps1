<#
---
catzc:
  immutable:
    with_body_sha: f18bdd244e85
  edges:
    docs: "[Get-TerminologyCorpus.ps1.md](docs/references/pwsh/catzc-base-quality-gates/private/Get-TerminologyCorpus.ps1.md)"
    cites:
      - ADR-AZ-DATAMOD
      - ADR-PWSH-PESTER-SYSTEMIOONHOTPATHS
---
#>

function Get-TerminologyCorpus {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Root,

        [string[]] $Exclude = @()
    )

    $exts = [System.Collections.Generic.HashSet[string]]::new(
        [string[]] @((Get-Config -Config languages).ExtensionsCheckedBy('Test-Spelling')),
        [System.StringComparer]::OrdinalIgnoreCase)

    $names = [System.Collections.Generic.HashSet[string]]::new(
        [string[]] @('.gitignore', '.gitattributes', '.markdownlintignore', '.prettierignore'),
        [System.StringComparer]::OrdinalIgnoreCase)

    # Mirror Test-Spelling's content scope: skip vendor, generated, and output trees.
    $excludeRegex = @(
        '[\\/]\.git[\\/]'
        '[\\/]\.vendor[\\/]'
        '[\\/]assets[\\/]scripts[\\/]'
        '[\\/]\.compiled[\\/]'
        '[\\/]obj[\\/]'
        '[\\/]bin[\\/]'
        '[\\/]out[\\/]'
        '[\\/]docs[\\/]notes[\\/]'
        '[\\/]\.unordered[\\/]'
    ) -join '|'

    $configurationRegex = @(
        '^[\\/]configuration[\\/]'
        '^[\\/]infrastructure[\\/]templates[\\/].+[\\/]configuration[\\/]'
    ) -join '|'

    $excludeSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($e in $Exclude) {
        $resolved = (Resolve-Path -LiteralPath $e -ErrorAction Ignore)?.Path
        [void] $excludeSet.Add(($resolved ?? $e))
    }

    $ret = [System.Text.StringBuilder]::new()
    foreach ($path in Get-ChildPath $Root -File -Depth 10) {
        if (-not $exts.Contains([System.IO.Path]::GetExtension($path)) -and
            -not $names.Contains([System.IO.Path]::GetFileName($path))) {
            continue
        }
        if ($path -match $excludeRegex) {
            continue
        }
        if ($path.Substring($Root.Length) -match $configurationRegex) {
            continue
        }
        if ([System.IO.Path]::GetFileName($path) -eq 'cspell.yml') {
            continue
        }
        if ($excludeSet.Contains($path)) {
            continue
        }
        [void] $ret.Append([System.IO.File]::ReadAllText($path).ToLowerInvariant()).Append("`n")
    }

    $ret.ToString()
}
