<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/private/Get-ChangeCheckPlan.ps1
    folder: private
    name: get-change-check-plan
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Get-ChangeCheckPlan.Tests.ps1
    cites:
      - ADR-PRIN-CONFIG
  config:
    synopsis: Maps changed repository files to the quality gates that check them, by file language.
    description: |-
      The checks half of Test-Change's plan, read from configuration, not code
      ([ADR-PRIN-CONFIG](/docs/adr/principles/configure-not-program.md)): each changed file that exists is looked up in the
      file-language registry (Get-FileLanguage -Path), and its language's `checks` list (languages.yml) names the gates.
      Returns one entry per gate, in the order a gate first appears, each with the changed files it applies to. A file with
      no file language, or whose language names no check, contributes nothing; a deleted file is skipped.
    parameters:
      Path: The changed repo-relative, '/'-separated paths.
      RepositoryRoot: The repository root the paths are relative to.
    outputs: '[pscustomobject] { Check; Path } — Path the changed files the gate applies to, in the order given.'
    examples:
      - Get-ChangeCheckPlan -Path 'docs/index.md' -RepositoryRoot (Get-RepositoryRoot)
---
#>

function Get-ChangeCheckPlan {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyCollection()]
        [string[]] $Path,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $plan = [ordered]@{}
    foreach ($changed in $Path) {
        if (-not [System.IO.File]::Exists([System.IO.Path]::Combine($RepositoryRoot, $changed))) {
            continue
        }
        $language = Get-FileLanguage -Path $changed
        if (-not $language) {
            continue
        }
        foreach ($check in $language.checks) {
            if (-not $plan.Contains($check)) {
                $plan[$check] = [System.Collections.Generic.List[string]]::new()
            }
            $plan[$check].Add($changed)
        }
    }
    foreach ($check in $plan.Keys) {
        [pscustomobject]@{ Check = $check; Path = @($plan[$check]) }
    }
}
