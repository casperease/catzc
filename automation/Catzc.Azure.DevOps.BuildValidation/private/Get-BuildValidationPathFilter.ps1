<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Azure.DevOps.BuildValidation
    moduletype: pwsh-folder-module
    bundle: full
    visibility: private
    adrs:
      - ADR-FLOW-CD-GLOBS
      - ADR-FLOW-CD-TYPE#4
  config:
    synopsis: The ADO branch-policy path filters for a globset — its native trigger projection, anchored with '/'.
    description: |-
      The single place the build-validation policy's `filenamePatterns` is derived (used by both
      Register- and Unregister-AdoBuildValidation), so the create side and the match-to-remove side always
      agree. Projects the globset to its GitHub-ordered native path list (Get-GlobSetTrigger,
      [ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md)) —
      '!' negation and last-match-wins, which ADO branch-policy path filters honour — and anchors each pattern
      with a leading '/', mapping '!p' to '!/p'. This is the same set of globs the pipeline triggers on; the
      policy is the server-side pre-commit half of that binding
      ([ADR-FLOW-CD-TYPE#4](/docs/adr/flow/pipeline-types.md#rule-adr-flow-cd-type4)), never a committed marker.
    parameters:
      GlobSet: The globset to project.
    outputs: '[string[]] The ''/''-anchored path filters, in projection order.'
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
