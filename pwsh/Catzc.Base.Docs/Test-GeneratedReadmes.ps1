<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Docs/Test-GeneratedReadmes.ps1
    name: test-generated-readmes
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Docs/tests/Test-GeneratedReadmes.Tests.ps1
    docs: "[Test-GeneratedReadmes.ps1.md](docs/references/pwsh/catzc-base-docs/Test-GeneratedReadmes.ps1.md)"
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
      - ADR-REPO-README
---
#>

function Test-GeneratedReadmes {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
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
