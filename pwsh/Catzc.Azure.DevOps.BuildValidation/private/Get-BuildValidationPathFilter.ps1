<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
    folder: private
    name: get-build-validation-path-filter
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.DevOps.BuildValidation
    moduletype: pwsh-folder
    catzc_bundle: full
    visibility: private
  edges:
    docs: "[Get-BuildValidationPathFilter.ps1.md](docs/references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md)"
    cites:
      - ADR-FLOW-CD-GLOBS
      - ADR-FLOW-CD-TYPE-PRECOMMITBUDGET
---
#>

function Get-BuildValidationPathFilter {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [Catzc.Base.Globs.GlobSet] $GlobSet
    )

    $trigger = Get-GlobSetTrigger -GlobSet $GlobSet
    [string[]] @(foreach ($pattern in $trigger.GitHub) {
            if ($pattern.StartsWith('!')) {
                '!/' + $pattern.Substring(1)
            }
            else {
                '/' + $pattern
            }
        })
}
