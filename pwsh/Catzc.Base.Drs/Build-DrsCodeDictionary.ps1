<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-drs/Build-DrsCodeDictionary.ps1.md"
  header: "generated"
---
#>

function Build-DrsCodeDictionary {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [switch] $DryRun,

        [switch] $Silent,

        [switch] $PassThru
    )

    $adrs = Get-Config -Config drs
    $adrRoot = Resolve-RepoPath $adrs.Root
    $index = Get-DrsFileIndex @($adrs.RuleSets) -DrsRoot $adrRoot
    $files = [string[]] @($index.Relative | ForEach-Object { [System.IO.Path]::Combine($index.Root, $_) })
    $relative = '.cspell/drs-codes.txt'
    $path = Join-Path (Get-RepositoryRoot) $relative

    $codes = [System.Collections.Generic.List[string]]::new()
    foreach ($ruleSet in $adrs.RuleSets) {
        $codes.Add($ruleSet.External)
    }
    foreach ($file in $files) {
        foreach ($match in [regex]::Matches([System.IO.File]::ReadAllText($file),
            "(?m)^### Rule (?<rule>$($adrs.CodeForm.Rule))\s*$")) {
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
    $content = Format-GeneratedFileHead -Text $text -Path $relative -Carrier word-list
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
