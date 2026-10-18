function Build-TerminologyDictionary {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [switch] $DryRun,

        [switch] $Silent,

        [switch] $PassThru
    )

    $cspellDir = Join-Path (Get-RepositoryRoot) '.cspell'

    # The registry and this file are the whole input: when every list already carries their stamp, nothing is parsed or written.
    $inputsSha = Get-InputStamp -Path (
        (Get-CatzcModuleRoot 'configs/terminology.yml'),
        (Get-Command Build-TerminologyDictionary).ScriptBlock.File
    )
    if (-not $PassThru -and (Test-Path -LiteralPath $cspellDir)) {
        $lists = @(Get-ChildPath $cspellDir -Depth 1 -File -Filter '*.txt')
        if ($lists.Count -gt 0 -and -not @($lists | Where-Object { -not (Test-GeneratedFileCurrent -Path $_ -InputsSha $inputsSha) })) {
            return [string[]] $lists
        }
    }

    $config = Get-Config -Config terminology

    $categories = @($config.categories)

    # The per-file status lines are verbose-level detail — shown only when this function is run with -Verbose.
    $emitVerbose = $VerbosePreference -ne [System.Management.Automation.ActionPreference]::SilentlyContinue

    if (-not $DryRun) {
        [void][System.IO.Directory]::CreateDirectory($cspellDir)
    }

    $ret = foreach ($category in $categories) {
        $words = [string[]] @(
            $config.terms |
                Where-Object { $_.category -eq $category } |
                ForEach-Object { $_.term.ToLowerInvariant() } |
                Select-Object -Unique
        )
        [System.Array]::Sort($words, [System.StringComparer]::Ordinal)

        $text = if ($words.Count -gt 0) {
            ($words -join "`n") + "`n"
        }
        else {
            ''
        }
        $content = Format-GeneratedFileHead -Text $text -Path ".cspell/$category.txt" -Carrier word-list -Generator Build-TerminologyDictionary -Source (ConvertTo-RepoRelativePath (Get-CatzcModuleRoot 'configs/terminology.yml')) -FileKind (Get-FileKind ".cspell/$category.txt") -InputsSha $inputsSha

        $dictPath = Join-Path $cspellDir "$category.txt"

        $existing = if (Test-Path $dictPath) {
            [System.IO.File]::ReadAllText($dictPath)
        }
        else {
            $null
        }
        $changed = $content -cne $existing

        if (-not $DryRun -and $changed) {
            $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
            [System.IO.File]::WriteAllText($dictPath, $content, $utf8NoBom)
        }

        $verb = if ($DryRun) {
            if ($changed) {
                'would regenerate'
            }
            else {
                'already current'
            }
        }
        else {
            if ($changed) {
                'regenerated'
            }
            else {
                'unchanged'
            }
        }
        if (-not $Silent) {
            Write-Message ".cspell/$category.txt $verb — $($words.Count) term(s)." -Verbose:$emitVerbose
        }

        [pscustomobject]@{
            Category  = $category
            Path      = $dictPath
            WordCount = $words.Count
            Changed   = [bool] $changed
            DryRun    = [bool] $DryRun
        }
    }
    $ret = @($ret)

    if ($PassThru) {
        return $ret
    }

    [string[]] @($ret.Path)
}
