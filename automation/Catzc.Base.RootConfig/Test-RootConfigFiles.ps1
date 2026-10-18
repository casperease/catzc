<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1
    name: test-root-config-files
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.RootConfig
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.RootConfig/tests/Test-RootConfigFiles.Tests.ps1
    cites:
      - ADR-AUTO-TEST#35
      - ADR-REPO-ROOTCFG
---
#>

function Test-RootConfigFiles {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    $repositoryRoot = Get-RepositoryRoot
    # One check per managed file: a wildcard entry expands to the files its generator renders (none yet is none).
    $entries = @(foreach ($entry in @(Get-RootConfigTargets -Config (Get-Config -Config rootconfig))) {
            if ([System.Management.Automation.WildcardPattern]::ContainsWildcardCharacters($entry.target)) {
                foreach ($file in @(Get-RootConfigRenderedFile -Entry $entry)) {
                    [pscustomobject]@{ target = $file.Target; source = $entry.source; committed = [bool] $entry.committed; copyAsLink = [bool] $entry.copyAsLink }
                }
            }
            else {
                $entry
            }
        })
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
