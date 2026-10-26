# pwsh/Base.Globs/Test-GlobSetIndependence.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Checks per-layer independence, that no two same-layer globsets select a common file on their own contribution.

### description

Within a layer, no two globsets may match a common file on their OWN membership (GlobSet.OwnMatches — the set's own include/exclude program,
compose IGNORED). Two that do "contain parts of each other" and are not independent. The check is per layer, never across layers: a
deployable-unit deliberately contains the base it composes, so cross-layer overlap is expected and correct. The 'loose-fileset' layer is
EXEMPT — its sets are cross-cutting check surfaces (a track's root concern, a scan scope, the reserved umbrellas) and overlap by design
([FDR-CD-GLOBS-EVERYSETHASLAYER](../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-everysethaslayer)).

Evaluates the declared registry (Get-GlobSet) AND the derived module sets (Get-ModuleGlobSet,
[ADR-REPO-PROTGLOB-DERIVEDMODULEGLOBSETS](../../../drs/repository/protected-globs.md#rule-adr-repo-protglob-derivedmoduleglobsets)) against
the tracked-file universe, collects one issue per violating pair ('`<layer>`: `<A>` `<->` `<B>` share N file(s), e.g. ...'), and ends with
Write-QualityGateReport ([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)): the report
lands in out/test-globset-independence/, and the gate throws once listing every pair (or returns the result with -PassThru).

### parameter `OutputFolder`

The report base folder. Defaults to Write-QualityGateReport's (out/test-globset-independence).

### parameter `PassThru`

Return the gate result { Subject; IssueCount; Issues; ReportPath; GlobSets; Files } instead of throwing.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

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
([FDR-CD-GLOBS-EVERYSETHASLAYER](/docs/drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-everysethaslayer)/10); every other layer is
checked.
```

## comment:2

Above `$own = @{}`, written with `#`.

```text
OWN members per set (compose ignored,
[FDR-CD-GLOBS-NOOVERLAPWITHINLAYER](/docs/drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-nooverlapwithinlayer)), computed once as a set for
O(1) intersection.
```
