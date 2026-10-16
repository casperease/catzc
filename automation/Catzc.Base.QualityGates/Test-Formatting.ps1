<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Test-Formatting.ps1
    name: test-formatting
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-PRIN-CONFIG#1
  config:
    synopsis: 'Quality gate: checks that formatting would leave the repository unchanged.'
    description: |-
      One gate for every formatter's check ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)).
      It keeps no list of formatters of its own: Format-Code -DryRun runs every engine the file-language registry
      (languages.yml) names, over every tracked file of each language, and every file an engine would change is one
      issue naming the file and the command that fixes it
      ([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)).

      The C# file-scoped namespace is a repository content rule rather than a layout engine, so it is checked beside
      the engines: Format-Types -DryRun names every type source whose namespace is missing or wrong, and every
      block-scoped one, which needs a hand edit. It runs with the csharp language — on the full run, or when -Language
      names csharp.

      Collects every issue and ends with Write-QualityGateReport: the report lands in out/test-formatting/, and the gate
      throws once listing every issue (or returns the result with -PassThru). An engine whose tool is missing throws
      with the command that installs it. The scope is the source tree, so the gate needs the source mode
      (Assert-SourceTree).
    parameters:
      Language: 'Check only these file languages (default: every one).'
      OutputFolder: The report base folder. Defaults to Write-QualityGateReport's (out/test-formatting).
      PassThru: Return the gate result { Subject; IssueCount; Issues; ReportPath; Languages } instead of throwing on issues.
    outputs: '[pscustomobject] With -PassThru only.'
    examples:
      - Test-Formatting
      - (Test-Formatting -Language pipeline-yaml -PassThru).Issues
---
#>

function Test-Formatting {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
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
