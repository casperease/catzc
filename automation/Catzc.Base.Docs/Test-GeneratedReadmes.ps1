<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/Test-GeneratedReadmes.ps1
    kind: function
    subkind: gate
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Docs
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Base.Docs/tests/Test-GeneratedReadmes.Tests.ps1
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-REPO-README
  config:
    synopsis: 'Quality gate: every generated README is gitignored, untracked, and current with its source.'
    description: |-
      A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the
      generated READMEs ([ADR-REPO-README](/docs/adr/repository/generated-readmes.md)). readme.yml, expanded by
      Get-ReadmeMappings exactly as Build-Readme expands it, lists the folders whose README.md is generated from a docs/
      source — a derived artifact, never authored in place. For each, it collects an issue when the README is:

        - not matched by a .gitignore rule (`git check-ignore --no-index` evaluates the rules alone; the default would
          consult the index and call a wrongly tracked file "not ignored", masking the next check);
        - tracked in git (remove it with `git rm --cached <path>`; the file stays on disk, ignored);
        - missing or stale: not what Build-Readme would write now (Get-ReadmeContent, compared EOL-insensitively by
          Write-FileIfChanged -DryRun) — re-run the importer, which regenerates it.

      Hand-authored READMEs are the folders not in readme.yml and are out of scope. It reads the repository's files,
      .gitignore, and git index, which exist only in a git work tree of the source tree (Get-ReadmeMappings).
    parameters:
      OutputFolder: The report base folder. Defaults to out/test-generated-readmes/ (Write-QualityGateReport).
      PassThru: Return the result ({ Subject; IssueCount; Issues; ReportPath; Readmes }) instead of throwing on issues.
    outputs: '[pscustomobject] With -PassThru only.'
    examples:
      - Test-GeneratedReadmes
---
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
