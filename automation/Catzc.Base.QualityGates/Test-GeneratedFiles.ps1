<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Test-GeneratedFiles.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: public
    adrs:
      - ADR-AUTO-TEST#35
---
#>

<#
.SYNOPSIS
    Quality gate: checks that every generated file equals what its generator would write now.
.DESCRIPTION
    Each writer runs report-only, composing its content without writing, so a stale file is reported, never fixed.
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
