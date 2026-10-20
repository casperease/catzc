<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Docs/Build-AdrCodeDictionary.ps1
    name: build-adr-code-dictionary
    filetype: ps1
    role: function
    subkind: writer
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Docs/tests/Build-AdrCodeDictionary.Tests.ps1
    docs: "[Build-AdrCodeDictionary.ps1.md](docs/references/pwsh/catzc-base-docs/Build-AdrCodeDictionary.ps1.md)"
    cites:
      - ADR-AUTO-DRYRUN
      - ADR-REPO-ADRCODE-SEGMENTSAREWORDS
---
#>

function Build-AdrCodeDictionary {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [switch] $DryRun,

        [switch] $Silent,

        [switch] $PassThru
    )

    $adrRoot = Resolve-RepoPath 'docs/adr'
    $adrs = Get-Config -Config adrs
    $index = Get-AdrFileIndex @($adrs.RuleSets) -AdrRoot $adrRoot
    $files = [string[]] @($index.Relative | ForEach-Object { [System.IO.Path]::Combine($index.Root, $_) })
    $relative = '.cspell/adr-codes.txt'
    $path = Join-Path (Get-RepositoryRoot) $relative

    $codes = [System.Collections.Generic.List[string]]::new()
    foreach ($ruleSet in $adrs.RuleSets) {
        $codes.Add($ruleSet.External)
    }
    foreach ($file in $files) {
        foreach ($match in [regex]::Matches([System.IO.File]::ReadAllText($file), '(?m)^### Rule (?<rule>ADR-\S+)\s*$')) {
            $codes.Add($match.Groups['rule'].Value)
        }
    }
    $words = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($code in $codes) {
        foreach ($segment in $code.Split([char[]] @('-', ':'))) {
            if ($segment -cmatch '^[A-Z][A-Z0-9]*$') {
                [void]$words.Add($segment.ToLowerInvariant())
            }
        }
    }

    $text = if ($words.Count -gt 0) {
        (@($words) -join "`n") + "`n"
    }
    else {
        ''
    }
    $content = Format-GeneratedFileHead -Text $text -Path $relative -Carrier word-list -Generator Build-AdrCodeDictionary -Source (ConvertTo-RepoRelativePath (Get-CatzcModuleRoot 'configs/adrs.yml')) -FileKind (Get-FileKind $relative)
    $existing = if (Test-Path -LiteralPath $path) {
        [System.IO.File]::ReadAllText($path)
    }
    else {
        $null
    }
    $changed = $content -cne $existing
    if ($changed -and -not $DryRun) {
        [void][System.IO.Directory]::CreateDirectory((Split-Path $path -Parent))
        [System.IO.File]::WriteAllText($path, $content, [System.Text.UTF8Encoding]::new($false))
    }
    if (-not $Silent) {
        $verb = if ($changed) {
            $DryRun ? 'would regenerate' : 'regenerated'
        }
        else {
            'unchanged'
        }
        Write-Message "$relative $verb — $($words.Count) word(s)."
    }

    $result = [pscustomobject]@{
        Path      = $path
        WordCount = $words.Count
        Changed   = [bool] $changed
        DryRun    = [bool] $DryRun
    }
    if ($PassThru) {
        return $result
    }
    $path
}
