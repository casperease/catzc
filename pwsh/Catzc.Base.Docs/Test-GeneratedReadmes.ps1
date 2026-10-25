<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-docs/Test-GeneratedReadmes.ps1.md"
  warning: "Generated Header"
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
    $config = Get-Config -Config readme
    $mappings = @(Get-ReadmeMappings -Config $config)
    $targets = @($mappings | ForEach-Object { "$($_.folder)/README.md" } | Sort-Object -Unique)
    $issues = [System.Collections.Generic.List[string]]::new()

    # A folder a pattern matches gets its README only from an article; a missing article is a finding unless readme.yml names the folder.
    $missing = @(Get-ReadmeMappings -Config $config -Missing)
    $exempt = @($config.without_article | ForEach-Object { $_.folder })
    foreach ($entry in $missing | Where-Object { $_.folder -notin $exempt }) {
        $issues.Add("$($entry.folder): a readme.yml pattern matches it but its article $($entry.source) does not exist — write it, or name the folder under without_article with its reason")
    }
    $missingFolders = @($missing | ForEach-Object { $_.folder })
    foreach ($folder in $exempt | Where-Object { $_ -notin $missingFolders }) {
        $issues.Add("${folder}: readme.yml without_article names it, but it has its article or no pattern matches it — drop the entry")
    }

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
