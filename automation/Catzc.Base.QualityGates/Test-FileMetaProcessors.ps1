# catzc:
#   path: automation/Catzc.Base.QualityGates/Test-FileMetaProcessors.ps1
#   module: Catzc.Base.QualityGates
#   visibility: public

<#
.SYNOPSIS
    Quality gate: every meta kind resolves to a processor function, and every convention-named processor function belongs to a kind.
.DESCRIPTION
    Orphans are listed both ways, because neither a missing function nor a missing kind fails alone.
    [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35),
    [ADR-REPO-FILEMETA#4](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta4)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Test-FileMetaProcessors.ps1.md#comment1)
.PARAMETER Config
    The meta-kind registry. Default: the shipped one.
.PARAMETER OutputFolder
    The report base folder. Defaults to out/test-file-meta-processors/ (Write-QualityGateReport).
.PARAMETER PassThru
    Return the result ({ Subject; IssueCount; Issues; ReportPath; KindCount; ProcessorCount }) instead of throwing on issues.
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-FileMetaProcessors
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
