<#
.SYNOPSIS
    Quality gate: checks that every generated file equals what its generator would write now.
.DESCRIPTION
    One gate for every generator's drift
    ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)).
    Each writer runs in its report-only mode — -DryRun -PassThru, which composes the content and writes
    nothing — and every file it reports as changed is one issue naming the file, the generator, and the
    command that regenerates it:

      Build-AdrIndex               [index](/docs/adr/index.md) from adrs.yml
      Build-Glossary               [glossary](/docs/adr/glossary.md) from the configs/glossary.yml sources
      Build-Readme                 the READMEs generated from their docs/references articles (readme.yml)
      Build-GitKeep                every managed .gitkeep from the shipped assets/gitkeep
      Build-TerminologyDictionary  the .cspell/<category>.txt lists from terminology.yml
      Build-EnglishDictionary      the committed english.txt.gz, checked from its stamp (Get-EnglishDictionaryDrift)
                                   — its -DryRun re-flattens cspell's tries through node, so the stamp is the
                                   cheap equivalent: the pinned cspell version and the gz's word count
      Build-RootConfig             every opted-in managed root file (rootconfig.yml); a file rendered by a
                                   generator is attributed to that generator — New-Importer, New-GitIgnore,
                                   New-VSCodeSettings, New-VSCodeExtensions, New-VSCodeLaunch,
                                   New-VSCodePipelineSchema, New-GoWorkspace (one issue per stale file of a
                                   multi-file generator, e.g. each go/tests/<folder>/go.mod)

    Collects every stale file and ends with Write-QualityGateReport: the report lands in
    out/test-generated-files/, and the gate throws once listing every issue (or returns the result with -PassThru).
    The generators read and write the source tree, so the gate needs the source mode (Assert-SourceTree).
.PARAMETER Generator
    Check only these generators (default: every one). Build-RootConfig selects every managed root file;
    a generator it renders (New-Importer, …) selects only that generator's files.
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
        [ValidateSet('Build-AdrIndex', 'Build-Glossary', 'Build-Readme', 'Build-GitKeep', 'Build-TerminologyDictionary',
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
            @('Build-AdrIndex', 'Build-Glossary', 'Build-Readme', 'Build-GitKeep', 'Build-TerminologyDictionary', 'Build-EnglishDictionary', 'Build-RootConfig') + $rootConfigGenerators
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
