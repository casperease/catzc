<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Test-TestInRunScope.ps1
    folder: private
    name: test-test-in-run-scope
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/private/Test-TestInRunScope.ps1.md
      test: automation/Catzc.Base.QualityGates/tests/Test-TestInRunScope.Tests.ps1
  config:
    synopsis: Whether a discovered test is inside a test run's tier and category scope.
    description: |-
      A test is in scope when neither its tier nor its category — each resolved along its block chain (Get-TestBlockTag,
      nearest contributing block wins) — is one of the run's exclude tags (Get-TestExcludeTag). The one scope check
      behind the work-list's scope filter (Select-InScopeTestFiles) and the opt-out exclusion (Get-TestOptOutExclusion),
      so both agree on which tests a run would execute.
    parameters:
      Test: A test from the run's discovery-only Pester result (Get-TestDiscovery).
      ExcludeTag: The run's tier/category exclude tags.
    outputs: '[bool]'
---
#>

function Test-TestInRunScope {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        $Test,

        [AllowEmptyCollection()]
        [string[]] $ExcludeTag = @()
    )

    $level = Get-TestBlockTag -Test $Test -Valid ([Catzc.Base.Timeouts.TestTiers]::Names)
    $category = Get-TestBlockTag -Test $Test -Valid 'logic', 'integrity'
    @(@($level) + @($category) | Where-Object { $_ -in $ExcludeTag }).Count -eq 0
}
