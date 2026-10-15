<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-TerminologyCorpus.ps1
    kind: private-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-AZ-DATAMOD
      - ADR-PWSH-PESTER#9
---
#>

<#
.SYNOPSIS
    Builds the lower-cased text corpus the terminology orphan check searches — one bulk read, not a grep
    per term.
.DESCRIPTION
    The net is wider than Test-Spelling's scope, since narrowing it would manufacture false orphans.
.PARAMETER Root
    The repository root to scan under.
.PARAMETER Exclude
    Full paths to omit from the corpus (the registry file and the generated dictionaries).
.OUTPUTS
    [string] The concatenated, lower-cased corpus.
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
        [string[]] @('.md', '.ps1', '.psm1', '.psd1', '.yml', '.yaml', '.json', '.cs', '.bicep'),
        [System.StringComparer]::OrdinalIgnoreCase)

    # No-extension config files are included by name, or a term used only there would read as a false orphan.
    # [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md#comment2)
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

    # Anchored at the root, so a nested authored configuration folder stays in the corpus instead of being swallowed.
    # [comment:3](/docs/references/automation/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md#comment3)
    $configurationRegex = @(
        '^[\\/]configuration[\\/]'
        '^[\\/]infrastructure[\\/]templates[\\/].+[\\/]configuration[\\/]'
    ) -join '|'

    $excludeSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($e in $Exclude) {
        $resolved = (Resolve-Path -LiteralPath $e -ErrorAction Ignore)?.Path
        [void] $excludeSet.Add(($resolved ?? $e))
    }

    # Raw System.IO enumeration avoids per-file object wrapping, which makes a whole-tree scan markedly faster.
    # [comment:4](/docs/references/automation/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md#comment4)
    $ret = [System.Text.StringBuilder]::new()
    # Tracked files reach nine levels below the root, so ten leaves one level of headroom. The corpus is searched for words,
    # never read in order, so the walker's file order does not matter.
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
