# automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: checks per-layer independence — no two same-layer globsets select a common file on their OWN contribution.

### description

Within a layer, no two globsets may match a common file on their OWN membership (GlobSet.OwnMatches — the set's own include/exclude program,
compose IGNORED). Two that do "contain parts of each other" and are not independent. The check is per layer, never across layers: a
deployable-unit deliberately contains the base it composes, so cross-layer overlap is expected and correct. The 'loose-fileset' layer is
EXEMPT — its sets are cross-cutting check surfaces (a track's root concern, a scan scope, the reserved umbrellas) and overlap by design
([ADR-FLOW-CD-GLOBS#7](../../../adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs7)).

Evaluates the declared registry (Get-GlobSet) AND the derived module sets (Get-ModuleGlobSet,
[ADR-REPO-PROTGLOB#7](../../../adr/repository/protected-globs.md#rule-adr-repo-protglob7)) against the tracked-file universe, collects one
issue per violating pair ('`<layer>`: `<A>` `<->` `<B>` share N file(s), e.g. ...'), and ends with Write-QualityGateReport
([ADR-AUTO-TEST#35](../../../adr/automation/test-automation.md#rule-adr-auto-test35)): the report lands in out/test-globset-independence/,
and the gate throws once listing every pair (or returns the result with -PassThru).

### parameter OutputFolder

The report base folder. Defaults to Write-QualityGateReport's (out/test-globset-independence).

### parameter PassThru

Return the gate result { Subject; IssueCount; Issues; ReportPath; GlobSets; Files } instead of throwing.

### outputs

`[pscustomobject]` With -PassThru only.

### example 1

```powershell
Test-GlobSetIndependence
```

### example 2

```powershell
(Test-GlobSetIndependence -PassThru).Issues
```

## comment:1

Above `$exemptLayer = 'loose-fileset'`, written with `#`.

```text
loose-filesets are cross-cutting and overlap-exempt
([ADR-FLOW-CD-GLOBS#7](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs7)/10); every other layer is
checked.
```

## comment:2

Above `$own = @{}`, written with `#`.

```text
OWN members per set (compose ignored,
[ADR-FLOW-CD-GLOBS#10](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs10)), computed once as a set for
O(1) intersection.
```
