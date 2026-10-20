<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-TerminologyCorpus.ps1
    folder: private
    name: get-terminology-corpus
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    docs: "[Get-TerminologyCorpus.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md)"
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
        [string[]] @('.md', '.ps1', '.psm1', '.psd1', '.yml', '.yaml', '.json', '.cs', '.bicep', '.py'),
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
