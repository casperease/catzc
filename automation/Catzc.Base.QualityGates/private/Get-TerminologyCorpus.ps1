<#
.SYNOPSIS
    Builds the lower-cased text corpus the terminology orphan check searches — one bulk read, not a grep
    per term.
.DESCRIPTION
    Concatenates the lower-cased text of the authored tree so orphan detection can confirm each registry term
    is genuinely referenced. The net is deliberately WIDER than Test-Spelling's lint scope: on top of the
    spell-scanned extensions it also scans the authored config files with no extension (.gitignore, .gitattributes,
    .markdownlintignore, .prettierignore), because a term can be justified solely by a usage there — e.g. a
    *.stackdump ignore pattern in .gitignore that the editor's cspell flags but the lint gate never scans.
    Narrowing the orphan net to the lint scope manufactures false orphans, so it searches the whole tree.

    Excludes the registry and its generated dictionaries — where every term trivially appears — so a hit in the
    corpus means the term is referenced elsewhere. Returned as one string; the caller tests membership with a
    case-insensitive substring check (ordinal, on already-lower-cased text), deliberately lenient: a term
    embedded in a larger identifier still counts as referenced.
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

    # Authored config files with no extension carry approved vocabulary too — a *.stackdump ignore pattern in
    # .gitignore, linguist attributes in .gitattributes — but have no extension for $exts to match. Include
    # them by name so a term referenced only here is not a false orphan (orphan detection scans the whole
    # authored tree, wider than the lint scope). [System.IO.Path]::GetExtension('.gitignore') is '.gitignore'.
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

    # The customer/machine-derived config tree (root configuration/, ADR-AZ-DATAMOD) and the Bicep template
    # configuration scaffold are out of the corpus — mirror Test-Spelling's scope. Match ROOT-RELATIVE and
    # anchored so a nested AUTHORED 'configuration' folder (e.g. docs/adr/configuration/) stays in the corpus
    # and can justify a term (a bare '[/]configuration[/]' substring would wrongly swallow the ADR folder).
    $configurationRegex = @(
        '^[\\/]configuration[\\/]'
        '^[\\/]infrastructure[\\/]templates[\\/].+[\\/]configuration[\\/]'
    ) -join '|'

    $excludeSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($e in $Exclude) {
        $resolved = (Resolve-Path -LiteralPath $e -ErrorAction Ignore)?.Path
        [void] $excludeSet.Add(($resolved ?? $e))
    }

    # Enumerate with [System.IO] rather than Get-ChildItem — no per-file PSObject wrapping, so a whole-tree
    # scan is markedly faster (ADR-AUTO-TEST:18). Directory/name filtering is done inline on the raw path string.
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
