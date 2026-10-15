<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Test-Change.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: public
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-PRIN-CONFIG
---
#>

<#
.SYNOPSIS
    Quality gate over what changed: runs the tests and the checks of the changed files, and reports only their issues.
.DESCRIPTION
    Gates that take a -Path get the changed files; other gates run whole and count only issues naming a changed file.
.PARAMETER Path
    The changed repo-relative, '/'-separated paths. Default: the working tree's changes (Get-GitChangedPath).
.PARAMETER WholeModule
    The default runs only the test files that cover the changed files by convention.
.PARAMETER DryRun
    Plan only: return { Path; Tests; Checks } and run nothing.
.PARAMETER OutputFolder
    The report base folder. Defaults to Write-QualityGateReport's (out/test-change).
.PARAMETER PassThru
    Without it the gate throws on issues, so the result object is how a caller reads them instead.
.OUTPUTS
    [pscustomobject] With -PassThru or -DryRun only.
.EXAMPLE
    Test-Change
.EXAMPLE
    Test-Change -DryRun
.EXAMPLE
    (Test-Change 'automation/Catzc.Base.Files/Get-GitChangedPath.ps1' -PassThru).Issues
#>
function Test-Change {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Position = 0)]
        [AllowEmptyCollection()]
        [string[]] $Path = @(Get-GitChangedPath),

        [switch] $WholeModule,

        [switch] $DryRun,

        [string] $OutputFolder,

        [switch] $PassThru
    )

    $repositoryRoot = Get-RepositoryRoot
    $changed = @($Path | ForEach-Object { $_ -replace '\\', '/' } | Sort-Object -Unique)
    $tests = @(Get-ChangeTestFile -Path $changed -RepositoryRoot $repositoryRoot -Module:$WholeModule)
    $checks = @(Get-ChangeCheckPlan -Path $changed -RepositoryRoot $repositoryRoot)
    if ($DryRun) {
        return [pscustomobject]@{ Path = $changed; Tests = $tests; Checks = $checks }
    }

    $issues = [System.Collections.Generic.List[string]]::new()
    $unattributed = 0
    if ($changed.Count -eq 0) {
        Write-Message 'Nothing changed against HEAD — no test or check to run.'
    }

    if ($tests.Count -gt 0) {
        $run = Invoke-TestFile -Path $tests -Output Minimal -PassThru
        $failedRows = @($run.Rows | Where-Object { $_.Result -eq 'Failed' })
        foreach ($row in $failedRows) {
            $file = ConvertTo-RepoRelativePath $row.File
            $message = ("$($row.ErrorMessage)".Trim() -split '\r?\n')[0]
            $issues.Add("${file}: $($row.ExpandedPath) — $message")
        }
        if ($run.Result -eq 'Failed' -and $failedRows.Count -eq 0) {
            $issues.Add("tests: the run of $($tests.Count) test file(s) failed with no failed test — a file failed before its tests ran (its error is printed above; artifacts in $($run.RunDirectory))")
        }
    }

    Push-Location -LiteralPath $repositoryRoot
    try {
        foreach ($entry in $checks) {
            $command = Get-Command $entry.Check -CommandType Function -ErrorAction Ignore
            if (-not $command) {
                $issues.Add("$($entry.Check): no such command — languages.yml names it as a check")
                continue
            }
            $arguments = @{ PassThru = $true }
            $pathParameter = $command.Parameters['Path']
            $scoped = $null -ne $pathParameter -and $pathParameter.ParameterType -eq [string[]]
            if ($scoped) {
                $arguments['Path'] = $entry.Path
            }
            try {
                $result = & $command @arguments 6> $null
            }
            catch {
                $issues.Add("$($entry.Check): $($_.Exception.Message)")
                continue
            }
            foreach ($issue in @($result.Issues)) {
                $text = "$issue"
                $normalized = $text -replace '\\', '/'
                if ($scoped -or @($entry.Path | Where-Object { $normalized.Contains($_) }).Count -gt 0) {
                    $issues.Add("$($entry.Check): $text")
                }
                else {
                    $unattributed++
                }
            }
        }
    }
    finally {
        Pop-Location
    }

    Write-QualityGateReport -Subject change -Title Test-Change -Issues $issues.ToArray() -Facts ([ordered]@{
            Changed      = $changed.Count
            Tests        = $tests.Count
            Checks       = $checks.Count
            Unattributed = $unattributed
        }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
