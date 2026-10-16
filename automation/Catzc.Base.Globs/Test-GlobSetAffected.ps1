<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1
    name: test-glob-set-affected
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    module: Catzc.Base.Globs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Base.Globs/tests/Test-GlobSetAffected.Tests.ps1
    adrs:
      - ADR-AUTO-FAILFAST
      - ADR-FLOW-CD-GLOBS#1
      - ADR-REPO-PROTGLOB#5
  config:
    synopsis: |-
      Whether the current context's change touches a globset — the in-pipeline "is there anything here for us
      to process?" check.
    description: |-
      The boolean a deployable unit's pipeline stage checks to stop early ("nothing for us; return") when its
      own area of control is untouched by the change. It reflects the context's diff (Get-GlobSetChangeRange,
      then Get-ChangedGlobSet) and reports whether the named set is among those touched. Because the range is
      resolved from real refs at run time
      ([ADR-FLOW-CD-GLOBS#1](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs1)), this check is immune to the
      squash-merge and
      concurrent-merge staleness a committed marker hash suffers.

      Fail-open ([ADR-REPO-PROTGLOB#5](/docs/adr/repository/protected-globs.md#rule-adr-repo-protglob5)): when the
      reference commit cannot be resolved or the diff cannot be computed —
      a shallow clone that cannot reach the base, an unresolved PR target ref, a first commit with no parent —
      this returns $true, proceed. A redundant run is safe; a wrong skip is an un-deployed change. It returns
      $false ONLY when it has positively confirmed, over a resolvable range, that the set is untouched. An
      undeclared name is a programming error, not a runtime ambiguity, so it throws (fail-fast,
      [ADR-AUTO-FAILFAST](/docs/adr/automation/fail-fast-with-asserts.md))
      rather than silently reporting "not affected" and skipping.
    parameters:
      Name: The globset — typically a deployable unit — to test.
    outputs: |-
      [bool] $true when the set is affected (or the range is indeterminate — fail-open); $false only when the
      set is confirmed untouched.
    examples:
      - if (-not (Test-GlobSetAffected -Name apex)) { return }
---
#>

function Test-GlobSetAffected {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config globs).Names })]
        [string] $Name
    )

    $config = Get-Config -Config globs
    if (-not $config.Contains($Name)) {
        throw "Test-GlobSetAffected: '$Name' is not a declared globset (globs.yml)."
    }

    $range = Get-GlobSetChangeRange
    if ($null -eq $range) {
        return $true
    }

    try {
        $touched = @(Get-ChangedGlobSet -Range $range)
    }
    catch {
        Write-Message "Test-GlobSetAffected: could not resolve change range '$range' ($($_.Exception.Message)); proceeding (fail-open)."
        return $true
    }

    [bool]($touched.Name -contains $Name)
}
