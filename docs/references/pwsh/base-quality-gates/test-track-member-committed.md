# pwsh/Base.QualityGates/Test-TrackMemberCommitted.ps1

The quality gate for tracks: every track member's committed fact must agree with the git index.

## help

### synopsis

Quality gate: every track member's committed fact agrees with the git index.

### description

A track declares each member with a `committed` fact
([DDR-TRACK-ISPLACEDCLUSTER](../../../drs/design/tracks.md#rule-ddr-track-isplacedcluster)), and the git index is what it must agree with. A
committed member of which files lie on disk but none is tracked is one issue, and a member declared not committed of which git tracks a file
is one issue naming the first tracked file. A committed member with nothing on disk yet, such as an empty landing address, has nothing to
disagree with. The members come from Get-TrackMember and the index from Get-GitTrackedPath, so the gate sits above both Catzc.Base.Variants
and the git readers.

Ends with Write-QualityGateReport: the report lands in out/test-track-member-committed/, and the gate throws once listing every issue (or
returns the result with -PassThru). Needs the source tree (Assert-SourceTree).

### parameter `OutputFolder`

The report base folder. Defaults to Write-QualityGateReport's (out/test-track-member-committed).

### parameter `PassThru`

Return the gate result { Subject; IssueCount; Issues; ReportPath; Members } instead of throwing on issues.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-TrackMemberCommitted
```

### example 2

```powershell
(Test-TrackMemberCommitted -PassThru).Issues
```

## Declared against the index

A member's committed fact is declared, and the git index is what it must agree with
([DDR-TRACK-ISPLACEDCLUSTER](../../../drs/design/tracks.md#rule-ddr-track-isplacedcluster)). A committed member with nothing on disk yet,
such as an empty landing address, has nothing to disagree with.

## Generated members

A member that a catzc generator writes takes its generated fact from that generator's target, never from its own declaration as well.
