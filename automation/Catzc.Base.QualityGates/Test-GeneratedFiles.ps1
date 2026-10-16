<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/Test-GeneratedFiles.ps1
    name: test-generated-files
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1
    cites:
      - ADR-AUTO-TEST#35
  config:
    synopsis: 'Quality gate: checks that every generated file equals what its generator would write now.'
    description: |-
      One gate for every generator's drift
      ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)).
      Each writer runs in its report-only mode — -DryRun -PassThru, which composes the content and writes
      nothing — and every file it reports as changed is one issue naming the file, the generator, and the
      command that regenerates it:

        Build-AdrIndex               [index](/docs/adr/index.md) from adrs.yml
        Build-Glossary               [glossary](/docs/adr/glossary.md) from the configs/glossary.yml sources
        Build-Readme                 the READMEs generated from their docs/references articles (readme.yml)
        Build-ContractReference      the per-unit contract pages docs/references/contracts/<unit>.md from the contract assets
        Build-GitKeep               every managed .gitkeep from the shipped assets/gitkeep
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
    parameters:
      Generator: |-
        Check only these generators (default: every one). Build-RootConfig selects every managed root file;
        a generator it renders (New-Importer, …) selects only that generator's files.
      OutputFolder: The report base folder. Defaults to Write-QualityGateReport's (out/test-generated-files).
      PassThru: Return the gate result { Subject; IssueCount; Issues; ReportPath; Generators } instead of throwing on issues.
    outputs: '[pscustomobject] With -PassThru only.'
    examples:
      - Test-GeneratedFiles
      - (Test-GeneratedFiles -Generator Build-AdrIndex, New-Importer -PassThru).Issues
---
#>

function Test-GeneratedFiles {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string[]] $Generator,

        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $known = @(Get-GeneratedFileGenerator)
    foreach ($name in $Generator) {
        if ($name -notin $known) {
            throw "Unknown generator '$name'. The generators are: $($known -join ', ') (generated-files.yml lists the writers, rootconfig.yml the root-file generators)."
        }
    }
    $writers = (Get-Config -Config generated-files).writers
    $rootConfigGenerators = @($known | Where-Object { -not $writers.Contains($_) })
    # @() around the whole if: a one-generator selection must stay an array (.Count under strict mode).
    $selected = @(if ($Generator) {
            $Generator
        }
        else {
            $known
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

    # Each registered writer is run by its check; the registry (generated-files.yml) says which check and, for a file result, which property holds the path.
    foreach ($writer in $writers.Values) {
        $writerName = $writer.name
        switch ($writer.check) {
            'file' {
                if ($writerName -in $selected) {
                    foreach ($result in @(& $writerName -DryRun -PassThru -Silent)) {
                        if ($result.Changed) {
                            & $addStale $result.($writer.result_path) $writerName $writerName
                        }
                    }
                }
            }
            'english-dictionary' {
                # The committed English list, from its stamp: the pin is tools.yml's, read by address (no Tooling edge).
                if ($writerName -in $selected) {
                    $assetsFolder = Join-Path (Get-RepositoryRoot) 'automation/Catzc.Base.QualityGates/assets'
                    $pinned = "$(Get-ConfigValue -Address 'global.tools.cspell.version')"
                    foreach ($reason in @(Get-EnglishDictionaryDrift -AssetsFolder $assetsFolder -PinnedCspell $pinned)) {
                        $issues.Add("automation/Catzc.Base.QualityGates/assets/english.txt.gz: stale — $reason; regenerate with: $writerName (commit the gz and its stamp)")
                    }
                }
            }
            'root-config' {
                # The managed root files: the writer selects them all, a generator only the files it renders.
                if ($writerName -in $selected -or @($selected | Where-Object { $_ -in $rootConfigGenerators }).Count -gt 0) {
                    foreach ($result in @(& $writerName -DryRun -PassThru -Silent)) {
                        $name = if ($result.Generator) {
                            "$($result.Generator)"
                        }
                        else {
                            $writerName
                        }
                        if ($result.Changed -and ($writerName -in $selected -or $name -in $selected)) {
                            & $addStale $result.Target $name "$writerName '$($result.Target)'"
                        }
                    }
                }
            }
        }
    }

    Write-QualityGateReport -Subject generated-files -Title Test-GeneratedFiles -Issues $issues.ToArray() `
        -Facts ([ordered]@{ Generators = $selected.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
