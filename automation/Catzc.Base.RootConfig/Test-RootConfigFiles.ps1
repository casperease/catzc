<#
.SYNOPSIS
    Quality gate: every managed root config file agrees with rootconfig.yml on git tracking, .gitignore, and link
    mechanism.
.DESCRIPTION
    A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the
    opted-in entries of rootconfig.yml ([ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)), resolved
    exactly as Build-RootConfig resolves them (Get-RootConfigTargets). Per entry, `committed` decides git membership,
    and the registry, .gitignore, and git's tracked set must agree. It collects an issue for:

      - a committed:false target no .gitignore rule ignores, or that git tracks (a derived artifact; remove it with
        `git rm --cached <path>`);
      - a committed:true target git does not track (it is needed before the importer runs), or that an ignore rule
        matches;
      - a copyAsLink target that is not an effective link from this OS — a symbolic link resolving to its source, or
        a hard link whose bytes are CR-insensitively identical to it;
      - any other target that is a link — a copy or generator target must be a real, independent file (a flipped-back
        entry never converted would read through the link and look current).

    Ignore rules are evaluated with `git check-ignore --no-index`, the rules alone: the default consults the index and
    would call a wrongly tracked file "not ignored", masking the tracking check. Re-running the importer
    (Build-RootConfig) repairs the link issues. It drives the git CLI, so it needs a git work tree.
.PARAMETER OutputFolder
    The report base folder. Defaults to out/test-root-config-files/ (Write-QualityGateReport).
.PARAMETER PassThru
    Return the result ({ Subject; IssueCount; Issues; ReportPath; Files }) instead of throwing on issues.
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-RootConfigFiles
#>
function Test-RootConfigFiles {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    $repositoryRoot = Get-RepositoryRoot
    $entries = @(Get-RootConfigTargets -Config (Get-Config -Config rootconfig))
    $issues = [System.Collections.Generic.List[string]]::new()

    $ignored = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    if ($entries.Count -gt 0) {
        $quotedPaths = foreach ($entry in $entries) {
            "`"$($entry.target)`""
        }
        # Exit 0: some paths are ignored, 1: none are; anything else is a git failure.
        $ignoreResult = Invoke-Executable "git -C `"$repositoryRoot`" -c core.quotepath=off check-ignore --no-index -- $($quotedPaths -join ' ')" -PassThru -Silent -NoAssert
        if ($ignoreResult.ExitCode -gt 1) {
            throw "Test-RootConfigFiles: git check-ignore failed ($($ignoreResult.ExitCode)): $($ignoreResult.Errors)"
        }
        foreach ($line in ($ignoreResult.Output -split "`r?`n")) {
            if ($line) {
                [void]$ignored.Add($line)
            }
        }
    }

    foreach ($entry in $entries) {
        $target = $entry.target
        $isTracked = @(Get-GitTrackedPath $target).Count -gt 0
        $isIgnored = $ignored.Contains($target)
        if ($entry.committed) {
            if (-not $isTracked) {
                $issues.Add("${target}: committed:true but not tracked — it is needed before the importer runs")
            }
            if ($isIgnored) {
                $issues.Add("${target}: committed:true but matched by a .gitignore rule")
            }
        }
        else {
            if (-not $isIgnored) {
                $issues.Add("${target}: committed:false but no .gitignore rule ignores it")
            }
            if ($isTracked) {
                $issues.Add("${target}: committed:false but tracked — a gitignored artifact; run 'git rm --cached $target'")
            }
        }

        $targetPath = Join-Path $repositoryRoot $target
        $item = Get-Item -LiteralPath $targetPath -Force -ErrorAction Ignore
        if ($entry.copyAsLink) {
            $sourcePath = Join-Path $repositoryRoot $entry.source
            $effective = $false
            if ($item -and $item.LinkType -eq 'SymbolicLink') {
                $resolved = $item.ResolveLinkTarget($true)
                $effective = $resolved -and (
                    [System.IO.Path]::GetFullPath($resolved.FullName) -eq [System.IO.Path]::GetFullPath($sourcePath))
            }
            elseif ($item -and $item.LinkType -eq 'HardLink') {
                $targetText = [System.IO.File]::ReadAllText($targetPath) -replace "`r", ''
                $sourceText = [System.IO.File]::ReadAllText($sourcePath) -replace "`r", ''
                $effective = $targetText -ceq $sourceText
            }
            if (-not $effective) {
                $issues.Add("${target}: copyAsLink, but missing, stale, or not a link to $($entry.source) — re-run the importer (Build-RootConfig re-links)")
            }
        }
        elseif ($item -and $item.LinkType) {
            $issues.Add("${target}: a link, but must be a real, independent file — re-run the importer (Build-RootConfig rewrites it)")
        }
    }

    Write-QualityGateReport -Subject 'root-config-files' -Title 'Test-RootConfigFiles' -Issues $issues `
        -Facts ([ordered]@{ Files = $entries.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
