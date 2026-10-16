<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Test-ParameterConsistency.ps1
    kind: gate
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.QualityGates
    visibility: public
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Test-ParameterConsistency.Tests.ps1
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-PWSH-PARAM
  config:
    synopsis: 'Quality gate: one parameter name means one type across the public functions.'
    description: |-
      A caller learns a parameter once — `-Path` takes paths, `-TimeoutSeconds` takes whole seconds — so the same name
      carries the same type in every public function ([ADR-PWSH-PARAM](/docs/adr/pwsh/parameter-design.md),
      [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)). Reads every tracked public function
      file (automation/<Module>/<Name>.ps1) and reports each parameter name whose declarations disagree on their element
      type (Get-ParameterTypeConflict: [string] and [string[]] agree; untyped, [object] and [psobject] never conflict).

      A name that genuinely means different things in different functions is listed in parameter-consistency.yml (`exempt`)
      with the reason; an exempt name is not reported, and an exempt name that no longer conflicts is reported, so the list
      holds only what is real. Ends with Write-QualityGateReport: the report lands in out/test-parameter-consistency/, and
      the gate throws once listing every issue (or returns the result with -PassThru). Needs the source tree
      (Assert-SourceTree).
    parameters:
      OutputFolder: The report base folder. Defaults to Write-QualityGateReport's (out/test-parameter-consistency).
      PassThru: Return the gate result { Subject; IssueCount; Issues; ReportPath; Functions; Exempt } instead of throwing on issues.
    outputs: '[pscustomobject] With -PassThru only.'
    examples:
      - Test-ParameterConsistency
      - (Test-ParameterConsistency -PassThru).Issues
---
#>

function Test-ParameterConsistency {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree
    $repositoryRoot = Get-RepositoryRoot
    $config = Get-Config -Config parameter-consistency
    $files = @(Get-GitTrackedPath 'automation' | Where-Object { $_ -match '^automation/[^/.][^/]*/[^/]+\.ps1$' } |
            ForEach-Object { Join-Path $repositoryRoot $_ })

    $issues = [System.Collections.Generic.List[string]]::new()
    $conflicting = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($conflict in @(Get-ParameterTypeConflict -Path $files)) {
        [void]$conflicting.Add($conflict.Name)
        if ($config.IsExempt($conflict.Name)) {
            continue
        }
        $types = ($conflict.Types | ForEach-Object { "[$($_.Type)] in $($_.Functions -join ', ')" }) -join '; '
        $issues.Add("-$($conflict.Name): one name, more than one type — $types. Give it one type, or exempt it in parameter-consistency.yml with the reason")
    }
    foreach ($name in @($config.exempt.Keys | Sort-Object)) {
        if (-not $conflicting.Contains($name)) {
            $issues.Add("automation/Catzc.Base.QualityGates/configs/parameter-consistency.yml: -$name is exempt but no longer conflicts — remove the entry")
        }
    }

    Write-QualityGateReport -Subject parameter-consistency -Title Test-ParameterConsistency -Issues $issues.ToArray() `
        -Facts ([ordered]@{ Functions = $files.Count; Exempt = $config.exempt.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
