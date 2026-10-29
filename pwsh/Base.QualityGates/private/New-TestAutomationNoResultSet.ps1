function New-TestAutomationNoResultSet {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string[]] $TestPath,

        [Parameter(Mandatory)]
        [string] $ResultsPath,

        [Parameter(Mandatory)]
        [string] $LogPath,

        [AllowEmptyString()]
        [string] $PesterError = ''
    )

    # The results file may be whole although the run object is lost: its counts say what ran.
    $counts = if ([System.IO.File]::Exists($ResultsPath)) {
        try {
            $root = ([xml] [System.IO.File]::ReadAllText($ResultsPath)).DocumentElement
            "results file: total $($root.GetAttribute('total')), failures $($root.GetAttribute('failures'))," +
            " errors $($root.GetAttribute('errors')), not-run $($root.GetAttribute('not-run'))"
        }
        catch {
            "results file unreadable: $($_.Exception.Message)"
        }
    }
    else {
        'no results file'
    }
    $printed = ("$PesterError" -replace '\x1b\[[0-9;]*m', '').Trim()
    $message = "Invoke-Pester returned no result (an error after its run; $counts; console: $LogPath)" +
    $(if ($printed) {
            "`n$printed"
        })

    # One failed container per test path, so the run fails with the reason and never reads as a pass.
    $rows = foreach ($path in $TestPath) {
        [pscustomobject]@{
            ExpandedPath = "$([System.IO.Path]::GetFileName($path)) (no Pester result)"
            ExpandedName = 'no Pester result'
            Result       = 'Failed'
            DurationMs   = 0
            Level        = ''
            Category     = ''
            Rules        = ''
            File         = $path
            Line         = 0
            ErrorMessage = $message
            ErrorStack   = ''
            SkipReason   = ''
        }
    }
    # A zero duration is unmeasured: the dealing history keeps the larger, the file's decayed last duration.
    $files = foreach ($path in $TestPath) {
        [pscustomobject]@{
            File         = $path
            DurationMs   = 0
            Result       = 'Failed'
            ErrorMessage = $message
        }
    }

    [pscustomobject]@{
        Rows  = @($rows)
        Files = @($files)
    }
}
