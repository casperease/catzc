<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/Test-Formatting.ps1
    name: test-formatting
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1
    docs: "[Test-Formatting.ps1.md](docs/references/pwsh/catzc-base-qualitygates/Test-Formatting.ps1.md)"
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
      - ADR-PRIN-CONFIG-VARYINGBEHAVIOURISCONFIG
---
#>

function Test-Formatting {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [ArgumentCompleter({ Get-FileLanguage | ForEach-Object name })]
        [string[]] $Language,

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
        foreach ($result in @(Format-Code -Language $formatted -DryRun -PassThru)) {
            foreach ($file in $result.ChangedFiles) {
                & $addIssue $file "not formatted — run Format-Code -Language $($result.Language)"
            }
            # What an imprint step found wrong but cannot repair needs a hand edit.
            foreach ($file in $result.Unfixable.Keys) {
                & $addIssue $file $result.Unfixable[$file]
            }
        }
    }

    Write-QualityGateReport -Subject formatting -Title Test-Formatting -Issues $issues.ToArray() `
        -Facts ([ordered]@{ Languages = $selected.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
