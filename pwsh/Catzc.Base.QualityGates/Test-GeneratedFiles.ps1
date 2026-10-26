<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-quality-gates/Test-GeneratedFiles.ps1.md"
  header: "generated"
---
#>

function Test-GeneratedFiles {
    [CmdletBinding(DefaultParameterSetName = 'Writers')]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [Parameter(ParameterSetName = 'Writers')]
        [string[]] $Generator,

        [switch] $Changed,

        [Parameter(ParameterSetName = 'Stamp')]
        [switch] $StampOnly,

        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $known = @(Get-GeneratedFileGenerator)
    foreach ($name in $Generator) {
        Assert-True ($name -in $known) `
            -ErrorText "Unknown generator '$name'. The generators are: $($known -join ', ') (generated-files.yml lists the writers, rootconfig.yml the root-file generators)."
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
    # With -Changed only the writers Get-GeneratedWriterDue names run their dry run: the one reading of the inputs and
    # outputs lists.
    $dueNames = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    # A stamp-only check runs no writer, so it reads no due rows (the import's janitor has its own).
    if ($Changed -and -not $StampOnly) {
        foreach ($row in @(Get-GeneratedWriterDue | Where-Object Due)) {
            [void]$dueNames.Add($row.Name)
        }
    }
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

    $checkedWriters = @(if (-not $StampOnly) {
            $writers.Values
        })
    foreach ($writer in $checkedWriters) {
        $writerName = $writer.name
        if ($Changed -and -not $dueNames.Contains($writerName)) {
            continue
        }
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
                    $assetsFolder = Join-Path (Get-CatzcModulesRoot) 'Catzc.Base.QualityGates/assets'
                    $pinned = "$(Get-ConfigValue -Address 'global.tools.cspell.version')"
                    foreach ($reason in @(Get-EnglishDictionaryDrift -AssetsFolder $assetsFolder -PinnedCspell $pinned)) {
                        $issues.Add("$(ConvertTo-RepoRelativePath $assetsFolder)/english.txt.gz: stale — $reason; regenerate with: $writerName (commit the gz and its stamp)")
                    }
                }
            }
            'root-config' {
                # The managed root files: the writer selects them all, a generator only the files it renders.
                if ($writerName -in $selected -or
                    @($selected | Where-Object { $_ -in $rootConfigGenerators }).Count -gt 0) {
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

    # The stamp of every generated tracked file against its body; a file with no head yet is counted, not failed.
    $stamps = Get-GeneratedStampDrift -RepositoryRoot (Get-RepositoryRoot) -Changed:$Changed
    foreach ($issue in $stamps.Issues) {
        $issues.Add($issue)
    }

    Write-QualityGateReport -Subject generated-files -Title Test-GeneratedFiles -Issues $issues.ToArray() `
        -Facts ([ordered]@{ Generators = $selected.Count; Stamped = $stamps.Stamped; Unstamped = $stamps.Unstamped.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
