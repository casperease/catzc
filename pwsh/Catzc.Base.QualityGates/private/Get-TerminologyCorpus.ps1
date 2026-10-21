<#
---
catzc:
  immutable:
    with_body_sha: "6759e5bf5651"
  edges:
    docs: "[Get-TerminologyCorpus.ps1.md](docs/references/pwsh/catzc-base-quality-gates/private/Get-TerminologyCorpus.ps1.md)"
    cites:
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

    # Test-Spelling's one scope: the ignorePaths of the root cspell.yml, read as cspell reads them, where a glob with no '/' matches a name at any depth.
    $ignored = @(foreach ($glob in ([System.IO.File]::ReadAllText((Join-Path $Root 'cspell.yml')) | ConvertFrom-Yaml).ignorePaths) {
            [Catzc.Base.Globs.GlobPattern]::new($(if ($glob.Contains('/')) {
                        $glob
                    }
                    else {
                        "**/$glob"
                    }))
        })

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
        $relative = $path.Substring($Root.Length).TrimStart('\', '/').Replace('\', '/')
        if (@($ignored | Where-Object { $_.Matches($relative) }).Count) {
            continue
        }
        if ($excludeSet.Contains($path)) {
            continue
        }
        [void] $ret.Append([System.IO.File]::ReadAllText($path).ToLowerInvariant()).Append("`n")
    }

    $ret.ToString()
}
