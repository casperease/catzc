<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1
    kind: automation-function
    module: Catzc.Base.Globs
    visibility: public
    relatives:
      test: automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1
    adrs:
      - ADR-FLOW-CD-GLOBS#1
      - ADR-FLOW-CD-GLOBS#4
  config:
    synopsis: Projects a globset's scan program into vendor-native pipeline path filters — the no-start trigger.
    description: |-
      The pipeline trigger: project the set's flattened scan program
      ([ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)/8) straight into the vendor's
      own `paths` filter, so the trigger fires — or does not start at all — on the real files, with no committed
      hash to go stale across a squash or concurrent merge.

      Two dialects, from the one program:

      - GitHub `on.*.paths`: the program in order, each '-' rule rendered as a '!' negation. GitHub paths are
        ordered and last-match-wins — the same evaluator as GlobSet.Matches — so this projection is EXACT.
      - Azure DevOps `trigger.paths.include`/`exclude`: order-independent (union include minus union exclude).
        Each pattern is collapsed to its LAST select in the program, so a base exclude that a later compose
        include re-adds (e.g. '- configuration/*/**' then '+ configuration/apex/**') nets to an include — the
        order-independent lists then reproduce the last-match-wins result. ADO's documented rule that a deeper
        include overrides a broader exclude carries the compose re-add. A set whose ADO projection cannot
        reproduce exact membership (a root-glob re-added over an equal-depth exclude) is caught by the superset
        integrity test, not here; this function only performs the mechanical projection.
    parameters:
      Name: The declared globset to project.
      GlobSet: A [Catzc.Base.Globs.GlobSet] to project instead (the path a derived set takes).
    outputs: '[pscustomobject] { Name; GitHub = [string[]] ordered paths; AdoInclude = [string[]]; AdoExclude = [string[]] }.'
    examples:
      - Get-GlobSetTrigger -Name apex
      - (Get-GlobSetTrigger -Name automation).GitHub
---
#>

function Get-GlobSetTrigger {
    [CmdletBinding(DefaultParameterSetName = 'ByName')]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'ByName')]
        [ArgumentCompleter({ (Get-Config -Config globs).Names })]
        [string] $Name,

        [Parameter(Mandatory, ParameterSetName = 'ByObject')]
        [Catzc.Base.Globs.GlobSet] $GlobSet
    )

    $set = if ($PSCmdlet.ParameterSetName -eq 'ByName') {
        Get-GlobSet -Name $Name
    }
    else {
        $GlobSet
    }

    $gitHub = [System.Collections.Generic.List[string]]::new()
    $lastSelect = [ordered]@{}
    foreach ($rule in $set.ScanProgram()) {
        $pattern = $rule.Pattern.Pattern
        if ($rule.Select) {
            $gitHub.Add($pattern)
        }
        else {
            $gitHub.Add("!$pattern")
        }
        $lastSelect[$pattern] = [bool]$rule.Select
    }

    $adoInclude = [System.Collections.Generic.List[string]]::new()
    $adoExclude = [System.Collections.Generic.List[string]]::new()
    foreach ($pattern in $lastSelect.Keys) {
        if ($lastSelect[$pattern]) {
            $adoInclude.Add($pattern)
        }
        else {
            $adoExclude.Add($pattern)
        }
    }

    [pscustomobject]@{
        Name       = $set.Name
        GitHub     = $gitHub.ToArray()
        AdoInclude = $adoInclude.ToArray()
        AdoExclude = $adoExclude.ToArray()
    }
}
