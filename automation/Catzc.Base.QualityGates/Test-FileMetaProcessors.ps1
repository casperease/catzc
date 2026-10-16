<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Test-FileMetaProcessors.ps1
    name: test-file-meta-processors
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
      test: automation/Catzc.Base.QualityGates/tests/Test-FileMetaProcessors.Tests.ps1
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-REPO-FILEMETA#4
  config:
    synopsis: 'Quality gate: every meta kind resolves to a processor function, and every convention-named processor function belongs to a kind.'
    description: |-
      A kind whose function is missing fails the run that reads the registry, and a function no kind names is never
      called, so this gate lists both orphans. A function is a processor candidate when it is named Get-<Kind>FileMetaFact or
      Get-<Kind>MarkdownConfigContribution.
    parameters:
      Config: 'The meta-kind registry. Default: the shipped one.'
      OutputFolder: The report base folder. Defaults to out/test-file-meta-processors/ (Write-QualityGateReport).
      PassThru: |-
        Return the result ({ Subject; IssueCount; Issues; ReportPath; KindCount; ProcessorCount }) instead of
        throwing on issues.
    outputs: '[pscustomobject] With -PassThru only.'
    examples:
      - Test-FileMetaProcessors
---
#>

function Test-FileMetaProcessors {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Catzc.Base.QualityGates.FileMetaConfig] $Config = (Get-Config -Config file-meta),

        [string] $OutputFolder,

        [switch] $PassThru
    )

    $issues = [System.Collections.Generic.List[string]]::new()
    $kinds = @($Config.kinds)
    $named = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

    foreach ($kind in $kinds) {
        [void]$named.Add($kind.processor)
        if (-not (Get-Command -Name $kind.processor -CommandType Function -ErrorAction Ignore)) {
            $issues.Add("kind '$($kind.id)' is subscribed by '$($kind.processor)', but no such function exists — add the function or remove the kind")
        }
    }

    # piped, not member-enumerated: .Name over an empty result throws in a strict scope
    $processors = @(Get-Command -Name 'Get-?*FileMetaFact', 'Get-?*MarkdownConfigContribution' -CommandType Function -ErrorAction Ignore |
            Select-Object -ExpandProperty Name | Sort-Object -Unique)
    foreach ($processor in $processors) {
        if (-not $named.Contains($processor)) {
            $issues.Add("$processor is named like a meta processor, but no kind in the registry names it — add the kind or rename the function")
        }
    }

    Write-QualityGateReport -Subject 'file-meta-processors' -Title 'Test-FileMetaProcessors' -Issues $issues `
        -Facts ([ordered]@{ KindCount = $kinds.Count; ProcessorCount = $processors.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
