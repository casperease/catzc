<#
---
catzc:
  immutable:
    with_body_sha: "7e3f66a59a45"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1
    docs: "[Test-GeneratedFiles.ps1.md](../../docs/references/pwsh/catzc-base-quality-gates/Test-GeneratedFiles.ps1.md)"
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
      - ADR-REPO-FILEMETA-COMPOSEDFILES
---
#>

function Test-GeneratedFiles {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
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
                    $assetsFolder = Join-Path (Get-CatzcModulesRoot) 'Catzc.Base.QualityGates/assets'
                    $pinned = "$(Get-ConfigValue -Address 'global.tools.cspell.version')"
                    foreach ($reason in @(Get-EnglishDictionaryDrift -AssetsFolder $assetsFolder -PinnedCspell $pinned)) {
                        $issues.Add("$(ConvertTo-RepoRelativePath $assetsFolder)/english.txt.gz: stale — $reason; regenerate with: $writerName (commit the gz and its stamp)")
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

    # The stamp of every generated tracked file against its body; a file with no head yet is counted, not failed.
    $stamps = Get-GeneratedStampDrift -RepositoryRoot (Get-RepositoryRoot)
    foreach ($issue in $stamps.Issues) {
        $issues.Add($issue)
    }

    Write-QualityGateReport -Subject generated-files -Title Test-GeneratedFiles -Issues $issues.ToArray() `
        -Facts ([ordered]@{ Generators = $selected.Count; Stamped = $stamps.Stamped; Unstamped = $stamps.Unstamped.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
