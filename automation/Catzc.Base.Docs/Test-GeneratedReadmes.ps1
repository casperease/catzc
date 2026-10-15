<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/Test-GeneratedReadmes.ps1
    kind: function
    module: Catzc.Base.Docs
    visibility: public
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-REPO-README
---
#>

<#
.SYNOPSIS
    Quality gate: every generated README is gitignored, untracked, and current with its source.
.DESCRIPTION
    The ignore check uses git check-ignore --no-index, so a wrongly tracked README is judged on the rules alone.
    [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35),
    [ADR-REPO-README](/docs/adr/repository/generated-readmes.md)
    [comment:1](/docs/references/automation/catzc-base-docs/Test-GeneratedReadmes.ps1.md#comment1)
.PARAMETER OutputFolder
    The report base folder. Defaults to out/test-generated-readmes/ (Write-QualityGateReport).
.PARAMETER PassThru
    Return the result ({ Subject; IssueCount; Issues; ReportPath; Readmes }) instead of throwing on issues.
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-GeneratedReadmes
#>
function Test-GeneratedReadmes {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    $repositoryRoot = Get-RepositoryRoot
    $mappings = @(Get-ReadmeMappings -Config (Get-Config -Config readme))
    $targets = @($mappings | ForEach-Object { "$($_.folder)/README.md" } | Sort-Object -Unique)
    $issues = [System.Collections.Generic.List[string]]::new()

    if ($targets.Count -gt 0) {
        $quotedPaths = foreach ($target in $targets) {
            "`"$target`""
        }
        # Exit 0: some paths are ignored, 1: none are; anything else is a git failure.
        $ignoreResult = Invoke-Executable "git -C `"$repositoryRoot`" -c core.quotepath=off check-ignore --no-index -- $($quotedPaths -join ' ')" -PassThru -Silent -NoAssert
        if ($ignoreResult.ExitCode -gt 1) {
            throw "Test-GeneratedReadmes: git check-ignore failed ($($ignoreResult.ExitCode)): $($ignoreResult.Errors)"
        }
        $ignored = [System.Collections.Generic.HashSet[string]]::new([string[]]@($ignoreResult.Output -split "`r?`n" | Where-Object { $_ }), [System.StringComparer]::Ordinal)
        foreach ($target in $targets) {
            if (-not $ignored.Contains($target)) {
                $issues.Add("${target}: no .gitignore rule ignores this generated README")
            }
        }

        foreach ($tracked in @(Get-GitTrackedPath $targets)) {
            $issues.Add("${tracked}: committed, but a generated README is a gitignored artifact — run 'git rm --cached $tracked'")
        }
    }

    foreach ($mapping in $mappings) {
        $readmePath = Join-Path $repositoryRoot "$($mapping.folder)/README.md"
        if (Write-FileIfChanged -Path $readmePath -Content (Get-ReadmeContent -Mapping $mapping) -DryRun) {
            $issues.Add("$($mapping.folder)/README.md: missing, or stale against $($mapping.source) — re-run the importer (Build-Readme regenerates it)")
        }
    }

    Write-QualityGateReport -Subject 'generated-readmes' -Title 'Test-GeneratedReadmes' -Issues $issues `
        -Facts ([ordered]@{ Readmes = $targets.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
