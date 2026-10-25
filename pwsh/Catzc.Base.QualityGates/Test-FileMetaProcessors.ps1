<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-quality-gates/Test-FileMetaProcessors.ps1.md"
  header: "generated"
---
#>

function Test-FileMetaProcessors {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
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
