<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-TerminologyCorpus.ps1.md"
  header: "generated"
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

    # Extension-less config files (.gitignore, .gitattributes) carry approved vocabulary too, so they join by name.
    $names = [System.Collections.Generic.HashSet[string]]::new(
        [string[]] @('.gitignore', '.gitattributes', '.markdownlintignore', '.prettierignore'),
        [System.StringComparer]::OrdinalIgnoreCase)

    # Test-Spelling's one scope: cspell.yml's ignorePaths, read as cspell reads them.
    $ignored = @(foreach ($glob in ([System.IO.File]::ReadAllText([Catzc.Base.RootConfig.RootConfigFiles]::SpellingConfigPath($Root)) | ConvertFrom-Yaml).ignorePaths) {
            [Catzc.Base.Objects.GlobPattern]::new($(if ($glob.Contains('/')) {
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

    # Read with System.IO: no per-file PSObject wrapping on a whole-tree scan.
    $ret = [System.Text.StringBuilder]::new()
    # Ten levels leaves one of headroom; the corpus is searched, never read in order.
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
