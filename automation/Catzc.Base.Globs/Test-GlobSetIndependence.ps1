<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
    name: test-glob-set-independence
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Globs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-globs/Test-GlobSetIndependence.ps1.md
    test: automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1
    cites:
      - ADR-AUTO-TEST#35
      - ADR-FLOW-CD-GLOBS#{7,10}
      - ADR-REPO-PROTGLOB#7
  config:
    synopsis: |-
      Quality gate: checks per-layer independence — no two same-layer
      globsets select a common file on their OWN contribution.
    description: |-
      Within a layer, no two globsets may match a common file on their OWN membership (GlobSet.OwnMatches —
      the set's own include/exclude program, compose IGNORED). Two that do "contain parts of each other" and
      are not independent. The check is per layer, never across layers: a deployable-unit deliberately
      contains the base it composes, so cross-layer overlap is expected and correct. The 'loose-fileset' layer
      is EXEMPT — its sets are cross-cutting check surfaces (a track's root concern, a scan scope, the
      reserved umbrellas) and overlap by design
      ([ADR-FLOW-CD-GLOBS#7](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs7)).

      Evaluates the declared registry (Get-GlobSet) AND the derived module sets (Get-ModuleGlobSet,
      [ADR-REPO-PROTGLOB#7](/docs/adr/repository/protected-globs.md#rule-adr-repo-protglob7)) against the tracked-file
      universe, collects one issue per violating pair ('<layer>: <A> <-> <B> share N file(s), e.g. ...'), and ends
      with Write-QualityGateReport ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)):
      the report lands in out/test-globset-independence/, and the gate throws once listing every pair (or returns
      the result with -PassThru).
    parameters:
      OutputFolder: The report base folder. Defaults to Write-QualityGateReport's (out/test-globset-independence).
      PassThru: Return the gate result { Subject; IssueCount; Issues; ReportPath; GlobSets; Files } instead of throwing.
    outputs: '[pscustomobject] With -PassThru only.'
    examples:
      - Test-GlobSetIndependence
      - (Test-GlobSetIndependence -PassThru).Issues
---
#>

function Test-GlobSetIndependence {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    $exemptLayer = 'loose-fileset'

    $sets = @(Get-GlobSet) + @(Get-ModuleGlobSet)
    $tracked = [string[]] @(Get-TrackedFile)

    $own = @{}
    foreach ($set in $sets) {
        $own[$set.Name] = [System.Collections.Generic.HashSet[string]]::new(
            [string[]] @($set.SelectOwnMembers($tracked)), [System.StringComparer]::Ordinal)
    }

    $issues = [System.Collections.Generic.List[string]]::new()
    foreach ($layer in $sets | Group-Object Layer) {
        if ($layer.Name -eq $exemptLayer) {
            continue
        }
        $names = @($layer.Group.Name)
        for ($i = 0; $i -lt $names.Count; $i++) {
            for ($j = $i + 1; $j -lt $names.Count; $j++) {
                $a = $names[$i]
                $b = $names[$j]
                # The common case, a disjoint pair, is decided in one .NET call; only a violation lists its paths.
                if (-not $own[$a].Overlaps($own[$b])) {
                    continue
                }
                $shared = [System.Collections.Generic.List[string]]::new()
                foreach ($path in $own[$a]) {
                    if ($own[$b].Contains($path)) {
                        $shared.Add($path)
                    }
                }
                $sample = @($shared | Select-Object -First 5) -join ', '
                $issues.Add("$($layer.Name): $a <-> $b share $($shared.Count) file(s), e.g. $sample (ADR-FLOW-CD-GLOBS#10)")
            }
        }
    }

    Write-QualityGateReport -Subject globset-independence -Title Test-GlobSetIndependence -Issues $issues.ToArray() `
        -Facts ([ordered]@{ GlobSets = $sets.Count; Files = $tracked.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
