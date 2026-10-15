<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Test-GeneratedFiles.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: public
---
#>

<#
.SYNOPSIS
    Quality gate: checks that every generated file equals what its generator would write now.
.DESCRIPTION
    Each writer runs report-only, composing its content without writing, so a stale file is reported, never fixed.
    [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Test-GeneratedFiles.ps1.md#comment1)
.PARAMETER Generator
    Build-RootConfig selects every managed root file; a generator it renders selects only that generator's files.
    [comment:2](/docs/references/automation/catzc-base-qualitygates/Test-GeneratedFiles.ps1.md#comment2)
.PARAMETER OutputFolder
    The report base folder. Defaults to Write-QualityGateReport's (out/test-generated-files).
.PARAMETER PassThru
    Return the gate result { Subject; IssueCount; Issues; ReportPath; Generators } instead of throwing on issues.
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-GeneratedFiles
.EXAMPLE
    (Test-GeneratedFiles -Generator Build-AdrIndex, New-Importer -PassThru).Issues
#>
function Test-GeneratedFiles {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [ValidateSet('Build-AdrIndex', 'Build-Glossary', 'Build-Readme', 'Build-ContractReference', 'Build-GitKeep', 'Build-TerminologyDictionary',
            'Build-EnglishDictionary', 'Build-RootConfig', 'New-Importer', 'New-GitIgnore', 'New-VSCodeSettings',
            'New-VSCodeExtensions', 'New-VSCodeLaunch', 'New-VSCodePipelineSchema', 'New-GoWorkspace')]
        [string[]] $Generator,

        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $rootConfigGenerators = @('New-Importer', 'New-GitIgnore', 'New-VSCodeSettings', 'New-VSCodeExtensions', 'New-VSCodeLaunch', 'New-VSCodePipelineSchema', 'New-GoWorkspace')
    # @() around the whole if: a one-generator selection must stay an array (.Count under strict mode).
    $selected = @(if ($Generator) {
            $Generator
        }
        else {
            @('Build-AdrIndex', 'Build-Glossary', 'Build-Readme', 'Build-ContractReference', 'Build-GitKeep', 'Build-TerminologyDictionary', 'Build-EnglishDictionary', 'Build-RootConfig') + $rootConfigGenerators
        })

    $issues = [System.Collections.Generic.List[string]]::new()
    # A writer reports absolute or repository-relative paths; an issue names the repository-relative one.
    $addStale = {
        param([string] $Path, [string] $Name, [string] $Command)
        $relative = if ([System.IO.Path]::IsPathRooted($Path)) {
            ConvertTo-RepoRelativePath $Path
        }
        else {
            $Path
        }
        $issues.Add("${relative}: stale — $Name would change it; regenerate with: $Command")
    }

    # The single-file writers: one result object with Path and Changed.
    foreach ($name in 'Build-AdrIndex', 'Build-Glossary') {
        if ($name -in $selected) {
            $result = & $name -DryRun -PassThru -Silent
            if ($result.Changed) {
                & $addStale $result.Path $name $name
            }
        }
    }

    # The per-file writers: one result object per file.
    if ('Build-Readme' -in $selected) {
        foreach ($result in @(Build-Readme -DryRun -PassThru -Silent)) {
            if ($result.Changed) {
                & $addStale $result.Readme 'Build-Readme' 'Build-Readme'
            }
        }
    }
    if ('Build-ContractReference' -in $selected) {
        foreach ($result in @(Build-ContractReference -DryRun -PassThru -Silent)) {
            if ($result.Changed) {
                & $addStale $result.Path 'Build-ContractReference' 'Build-ContractReference'
            }
        }
    }
    if ('Build-GitKeep' -in $selected) {
        foreach ($result in @(Build-GitKeep -DryRun -PassThru -Silent)) {
            if ($result.Changed) {
                & $addStale $result.Path 'Build-GitKeep' 'Build-GitKeep'
            }
        }
    }
    if ('Build-TerminologyDictionary' -in $selected) {
        foreach ($result in @(Build-TerminologyDictionary -DryRun -PassThru -Silent)) {
            if ($result.Changed) {
                & $addStale $result.Path 'Build-TerminologyDictionary' 'Build-TerminologyDictionary'
            }
        }
    }

    # The committed English list, from its stamp: the pin is tools.yml's, read by address (no Tooling edge).
    if ('Build-EnglishDictionary' -in $selected) {
        $assetsFolder = Join-Path (Get-RepositoryRoot) 'automation/Catzc.Base.QualityGates/assets'
        $pinned = "$(Get-ConfigValue -Address 'global.tools.cspell.version')"
        foreach ($reason in @(Get-EnglishDictionaryDrift -AssetsFolder $assetsFolder -PinnedCspell $pinned)) {
            $issues.Add("automation/Catzc.Base.QualityGates/assets/english.txt.gz: stale — $reason; regenerate with: Build-EnglishDictionary (commit the gz and its stamp)")
        }
    }

    # The managed root files: Build-RootConfig selects them all, a generator only the files it renders.
    $rootConfigSelected = @($selected | Where-Object { $_ -eq 'Build-RootConfig' -or $_ -in $rootConfigGenerators })
    if ($rootConfigSelected.Count -gt 0) {
        foreach ($result in @(Build-RootConfig -DryRun -PassThru -Silent)) {
            $name = if ($result.Generator) {
                "$($result.Generator)"
            }
            else {
                'Build-RootConfig'
            }
            if ($result.Changed -and ('Build-RootConfig' -in $selected -or $name -in $selected)) {
                & $addStale $result.Target $name "Build-RootConfig '$($result.Target)'"
            }
        }
    }

    Write-QualityGateReport -Subject generated-files -Title Test-GeneratedFiles -Issues $issues.ToArray() `
        -Facts ([ordered]@{ Generators = $selected.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
