<#
.SYNOPSIS
    Builds the lower-cased text corpus the terminology orphan check searches — one bulk read, not a grep
    per term.
.DESCRIPTION
    Concatenates the lower-cased text of the authored tree so orphan detection can confirm each registry term is...
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md#comment1)
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

    # Authored config files with no extension carry approved vocabulary too — a *.stackdump ignore pattern...
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
    ) -join '|'

    # The customer/machine-derived config tree (root configuration/, ) and the Bicep template configuration scaffold...
    # [ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)
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

    # Enumerate with [System.IO] rather than Get-ChildItem — no per-file PSObject wrapping, so a whole-tree scan is...
    # [ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)
    # [comment:4](/docs/references/automation/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md#comment4)
    $ret = [System.Text.StringBuilder]::new()
    foreach ($path in [System.IO.Directory]::EnumerateFiles($Root, '*', [System.IO.SearchOption]::AllDirectories)) {
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
