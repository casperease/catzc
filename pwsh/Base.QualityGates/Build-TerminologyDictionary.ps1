function Build-TerminologyDictionary {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [switch] $DryRun,

        [switch] $Silent,

        [switch] $PassThru
    )

    # The dictionaries are gitignored, so a fresh clone has no .cspell/ to write into yet.
    $cspellDir = Join-Path (Get-RepositoryRoot) '.cspell'

    $config = Get-Config -Config terminology

    # One cspell word list per category, so cspell.yml can enable each on its own.
    $categories = @($config.categories)

    # The per-file status lines are verbose-level detail — shown only when this function is run with -Verbose.
    $emitVerbose = $VerbosePreference -ne [System.Management.Automation.ActionPreference]::SilentlyContinue

    if (-not $DryRun) {
        [void][System.IO.Directory]::CreateDirectory($cspellDir)
    }

    $ret = foreach ($category in $categories) {
        # The terms themselves, lower-cased, de-duplicated, ordinal-sorted; an expansion is a word cspell knows.
        $words = [string[]] @(
            $config.terms |
                Where-Object { $_.category -eq $category } |
                ForEach-Object { $_.term.ToLowerInvariant() } |
                Select-Object -Unique
        )
        [System.Array]::Sort($words, [System.StringComparer]::Ordinal)

        # The do-not-edit head is content cspell skips as comments, and drift compares it too.
        $text = if ($words.Count -gt 0) {
            ($words -join "`n") + "`n"
        }
        else {
            ''
        }
        $content = Format-GeneratedFileHead -Text $text -Path ".cspell/$category.txt" -Carrier word-list

        # The fixed path cspell.yml names, a gitignored generated file.
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
