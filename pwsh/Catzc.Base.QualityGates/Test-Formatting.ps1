<#
---
catzc:
  immutable:
    with_body_sha: f523908ef8df
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1
    docs: "[Test-Formatting.ps1.md](../../docs/references/pwsh/catzc-base-quality-gates/Test-Formatting.ps1.md)"
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
      - DDR-TRACK-MIGRATEONEFILEPERCOMMIT
      - PDR-CONFIG-VARYINGBEHAVIOURISCONFIG
      - TDR-NORMALFORM-UNCONTESTED
---
#>

function Test-Formatting {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [ArgumentCompleter({ Get-FileLanguage | ForEach-Object name })]
        [string[]] $Language,

        [Catzc.Base.Asserts.ValidatePathGiven()]
        [string[]] $Path,

        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $config = Get-Config -Config languages
    $selected = @(if ($Language) {
            foreach ($name in $Language) {
                $match = @($config.languages | Where-Object { $_.name -ceq $name })
                Assert-True ($match.Count -eq 1) -ErrorText "Test-Formatting: unknown file language '$name' (languages.yml declares: $(@($config.languages | ForEach-Object name) -join ', '))."
                $match[0]
            }
        }
        else {
            $config.languages
        })

    $issues = [System.Collections.Generic.List[string]]::new()
    $addIssue = {
        param([string] $Path, [string] $Problem)
        $issues.Add("$(ConvertTo-RepoRelativePath $Path): $Problem")
    }

    $formatted = @($selected | Where-Object { $_.formatter } | ForEach-Object name)
    if ($formatted.Count -gt 0) {
        $scope = @{ Language = $formatted }
        if ($Path) {
            $scope['Path'] = $Path
        }
        foreach ($result in @(Format-Code @scope -DryRun -PassThru)) {
            foreach ($file in $result.ChangedFiles) {
                & $addIssue $file "not formatted — run Format-Code -Language $($result.Language)"
            }
            # What an imprint step found wrong but cannot repair needs a hand edit.
            foreach ($file in $result.Unfixable.Keys) {
                & $addIssue $file $result.Unfixable[$file]
            }
        }
    }

    # Every file in scope is format-managed: a file no formatter covers is a finding, unless a language was named to narrow the run.
    if (-not $Language) {
        foreach ($file in @(Get-FormatScope -RepositoryRoot (Get-RepositoryRoot) -Path $Path)) {
            $fileLanguage = $config.ForPath($file)
            if ($null -eq $fileLanguage) {
                & $addIssue $file 'no Format-* command covers it — no file language in languages.yml claims its extension'
            }
            elseif (-not $fileLanguage.formatter) {
                & $addIssue $file "no Format-* command covers it — its language '$($fileLanguage.name)' has no formatter ($($fileLanguage.no_formatter))"
            }
        }
    }

    Write-QualityGateReport -Subject formatting -Title Test-Formatting -Issues $issues.ToArray() `
        -Facts ([ordered]@{ Languages = $selected.Count; Paths = @($Path).Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
