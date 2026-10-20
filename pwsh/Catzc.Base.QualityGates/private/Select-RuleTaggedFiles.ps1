<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Select-RuleTaggedFiles.ps1
    folder: private
    name: select-rule-tagged-files
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Select-RuleTaggedFiles.Tests.ps1
    docs: "[Select-RuleTaggedFiles.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Select-RuleTaggedFiles.ps1.md)"
---
#>

function Select-RuleTaggedFiles {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $TestFile,

        [Parameter(Mandatory)]
        $Discovery,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Rule
    )

    $ruleWanted = [System.Collections.Generic.HashSet[string]]::new([string[]] $Rule, [System.StringComparer]::Ordinal)
    $ruleFiles = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($test in @($Discovery.Tests)) {
        # The test's run file: its test file, or the Go test folder of a Go bridge test.
        $file = Get-TestRunFile -Test $test
        if (-not $file) {
            continue
        }
        foreach ($citation in (Get-TestRuleTags -Test $test)) {
            if ($ruleWanted.Contains($citation)) {
                [void]$ruleFiles.Add($file)
                break
            }
        }
    }

    @($TestFile | Where-Object { $ruleFiles.Contains($_) })
}
